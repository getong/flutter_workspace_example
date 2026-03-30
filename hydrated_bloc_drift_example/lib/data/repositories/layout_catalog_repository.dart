import '../../domain/layout_item.dart';
import '../local/app_database.dart';
import '../remote/layout_api_client.dart';

class CachedLayoutCatalog {
  const CachedLayoutCatalog({required this.items, this.cachedAt});

  final List<LayoutItem> items;
  final DateTime? cachedAt;
}

class LayoutCatalogRepository {
  LayoutCatalogRepository({
    required LayoutApiClient apiClient,
    required AppDatabase database,
  }) : _apiClient = apiClient,
       _database = database;

  final LayoutApiClient _apiClient;
  final AppDatabase _database;

  Future<CachedLayoutCatalog> readCachedCatalog() async {
    final List<PersistedLayoutCatalogRow> rows = await _database
        .readLayoutCatalogRows();
    if (rows.isEmpty) {
      return const CachedLayoutCatalog(items: <LayoutItem>[]);
    }

    return CachedLayoutCatalog(
      items: rows.map(_mapRow).toList(),
      cachedAt: rows.first.fetchedAt,
    );
  }

  Future<CachedLayoutCatalog> refreshCatalog() async {
    final DateTime fetchedAt = DateTime.now();
    final List<LayoutItem> items = await _apiClient.fetchLayouts();
    await _database.replaceLayoutCatalog(items: items, fetchedAt: fetchedAt);
    return CachedLayoutCatalog(items: items, cachedAt: fetchedAt);
  }

  Future<List<PersistedLayoutCatalogRow>> readCachedRows() {
    return _database.readLayoutCatalogRows();
  }

  LayoutItem _mapRow(PersistedLayoutCatalogRow row) {
    return LayoutItem(
      id: row.id,
      slug: row.slug,
      title: row.title,
      message: row.message,
      kind: row.kind,
    );
  }
}
