/// {@template cache_repository}
/// Repository for caching operations
/// {@endtemplate}
abstract class CacheRepository {
  Future<T?> get<T>(String key);
  Future<void> set<T>(String key, T value, {Duration? ttl});
  Future<void> remove(String key);
  Future<void> clear();
  Future<List<String>> getKeys();
}

/// {@template cache_entry}
/// Cache entry with TTL support
/// {@endtemplate}
class CacheEntry<T> {
  const CacheEntry({
    required this.value,
    required this.timestamp,
    this.ttl,
  });

  final T value;
  final DateTime timestamp;
  final Duration? ttl;

  bool get isExpired {
    if (ttl == null) return false;
    return DateTime.now().difference(timestamp) > ttl!;
  }
}

/// {@template mock_cache_repository}
/// Mock implementation of CacheRepository
/// {@endtemplate}
class MockCacheRepository implements CacheRepository {
  final Map<String, CacheEntry> _cache = {};

  @override
  Future<T?> get<T>(String key) async {
    await Future.delayed(const Duration(milliseconds: 50));

    final entry = _cache[key];
    if (entry == null || entry.isExpired) {
      if (entry?.isExpired == true) {
        _cache.remove(key);
      }
      return null;
    }

    return entry.value as T?;
  }

  @override
  Future<void> set<T>(String key, T value, {Duration? ttl}) async {
    await Future.delayed(const Duration(milliseconds: 50));

    _cache[key] = CacheEntry(
      value: value,
      timestamp: DateTime.now(),
      ttl: ttl,
    );
  }

  @override
  Future<void> remove(String key) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _cache.remove(key);
  }

  @override
  Future<void> clear() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cache.clear();
  }

  @override
  Future<List<String>> getKeys() async {
    await Future.delayed(const Duration(milliseconds: 50));

    // Remove expired entries
    final now = DateTime.now();
    _cache.removeWhere((key, entry) => entry.isExpired);

    return _cache.keys.toList();
  }
}
