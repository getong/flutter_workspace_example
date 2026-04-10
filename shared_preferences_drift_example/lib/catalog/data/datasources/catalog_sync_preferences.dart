import 'package:shared_preferences/shared_preferences.dart';

class CatalogSyncPreferences {
  CatalogSyncPreferences(this._preferences)
    : _cachedLastSync = _readFromPrefs(_preferences);

  static const String lastSyncKey = 'catalog.last_sync_epoch_ms';

  final SharedPreferencesWithCache _preferences;

  /// In-memory cache of the last sync timestamp.
  /// Updated on write so reads never hit disk.
  DateTime? _cachedLastSync;

  static DateTime? _readFromPrefs(SharedPreferencesWithCache prefs) {
    final milliseconds = prefs.getInt(lastSyncKey);
    if (milliseconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  /// Returns the last sync timestamp from the in-memory cache.
  DateTime? getLastSyncAt() => _cachedLastSync;

  /// Persists [value] and keeps the in-memory cache in sync.
  Future<void> markSyncedAt(DateTime value) async {
    await _preferences.setInt(lastSyncKey, value.millisecondsSinceEpoch);
    _cachedLastSync = value;
  }

  /// Force-reload from disk — only needed after an external process writes
  /// to SharedPreferences (e.g. another isolate).
  Future<void> reload() async {
    await _preferences.reloadCache();
    _cachedLastSync = _readFromPrefs(_preferences);
  }
}
