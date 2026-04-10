import '../datasources/catalog_local_datasource.dart';
import '../datasources/catalog_remote_datasource.dart';
import '../datasources/catalog_sync_preferences.dart';
import '../models/catalog_cache_snapshot.dart';
import '../models/catalog_item.dart';
import '../models/catalog_refresh_result.dart';

abstract interface class CatalogRepository {
  Stream<List<CatalogItem>> watchItems();

  Future<CatalogRefreshResult> ensureHydrated();

  Future<CatalogRefreshResult> refresh({bool force = false});

  Future<CatalogCacheSnapshot> getCacheSnapshot();

  Future<void> dispose();
}

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({
    required CatalogLocalDataSource localDataSource,
    required CatalogRemoteDataSource remoteDataSource,
    required CatalogSyncPreferences syncPreferences,
    this.cacheTtl = const Duration(minutes: 5),
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _syncPreferences = syncPreferences;

  final CatalogLocalDataSource _localDataSource;
  final CatalogRemoteDataSource _remoteDataSource;
  final CatalogSyncPreferences _syncPreferences;
  final Duration cacheTtl;

  @override
  Stream<List<CatalogItem>> watchItems() => _localDataSource.watchItems();

  @override
  Future<CatalogRefreshResult> ensureHydrated() async {
    final snapshot = await getCacheSnapshot();
    if (snapshot.localItemCount > 0 && !snapshot.isExpired) {
      return CatalogRefreshResult(
        didRefresh: false,
        servedFromCache: true,
        message: 'Loaded ${snapshot.localItemCount} fresh items from drift.',
      );
    }

    // Pass snapshot so refresh() doesn't recompute it.
    return _refreshInternal(force: true, precomputedSnapshot: snapshot);
  }

  @override
  Future<CatalogRefreshResult> refresh({bool force = false}) =>
      _refreshInternal(force: force);

  Future<CatalogRefreshResult> _refreshInternal({
    bool force = false,
    CatalogCacheSnapshot? precomputedSnapshot,
  }) async {
    final snapshot = precomputedSnapshot ?? await getCacheSnapshot();
    if (!force && snapshot.localItemCount > 0 && !snapshot.isExpired) {
      return CatalogRefreshResult(
        didRefresh: false,
        servedFromCache: true,
        message: 'Skipped remote fetch because the cache is still fresh.',
      );
    }

    try {
      final remoteItems = await _remoteDataSource.fetchCatalog();
      final syncedAt = DateTime.now();
      final cachedItems = remoteItems
          .map((CatalogItem item) => item.copyWith(cachedAt: syncedAt))
          .toList(growable: false);

      await _localDataSource.upsertAll(cachedItems);
      // Prune items that disappeared from the remote source.
      await _localDataSource.pruneExcept(
        cachedItems.map((CatalogItem i) => i.id).toSet(),
      );
      await _syncPreferences.markSyncedAt(syncedAt);

      return CatalogRefreshResult(
        didRefresh: true,
        servedFromCache: false,
        message:
            'Fetched ${cachedItems.length} items and refreshed local cache.',
      );
    } catch (error) {
      if (snapshot.localItemCount > 0) {
        return CatalogRefreshResult(
          didRefresh: false,
          servedFromCache: true,
          message:
              'Remote fetch failed, showing ${snapshot.localItemCount} cached items.',
        );
      }
      rethrow;
    }
  }

  @override
  Future<CatalogCacheSnapshot> getCacheSnapshot() async {
    // getLastSyncAt() reads from the in-memory cache — no disk I/O.
    final lastSyncAt = _syncPreferences.getLastSyncAt();
    final localItemCount = await _localDataSource.countItems();
    final isExpired = lastSyncAt == null
        ? true
        : DateTime.now().difference(lastSyncAt) > cacheTtl;

    return CatalogCacheSnapshot(
      lastSyncAt: lastSyncAt,
      isExpired: isExpired,
      localItemCount: localItemCount,
      cacheTtl: cacheTtl,
    );
  }

  @override
  Future<void> dispose() => _localDataSource.close();
}
