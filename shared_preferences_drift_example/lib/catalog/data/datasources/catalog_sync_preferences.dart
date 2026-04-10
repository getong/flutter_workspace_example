import 'package:shared_preferences/shared_preferences.dart';

class CatalogSyncPreferences {
  const CatalogSyncPreferences(this._preferences);

  static const String lastSyncKey = 'catalog.last_sync_epoch_ms';

  final SharedPreferencesWithCache _preferences;

  DateTime? getLastSyncAt() {
    final milliseconds = _preferences.getInt(lastSyncKey);
    if (milliseconds == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  Future<void> markSyncedAt(DateTime value) {
    return _preferences.setInt(lastSyncKey, value.millisecondsSinceEpoch);
  }

  Future<void> reload() => _preferences.reloadCache();
}
