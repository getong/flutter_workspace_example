import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app_database.dart';

class DriftHydratedStorage implements Storage {
  DriftHydratedStorage._(this._database, this._cache);

  final AppDatabase _database;
  final Map<String, dynamic> _cache;

  static Future<DriftHydratedStorage> build(AppDatabase database) async {
    final Map<String, dynamic> cache = await database.readHydratedCache();
    return DriftHydratedStorage._(database, cache);
  }

  @override
  dynamic read(String key) => _cache[key];

  @override
  Future<void> write(String key, dynamic value) async {
    _cache[key] = value;
    await _database.upsertHydratedValue(key, value);
  }

  @override
  Future<void> delete(String key) async {
    _cache.remove(key);
    await _database.deleteHydratedValue(key);
  }

  @override
  Future<void> clear() async {
    _cache.clear();
    await _database.clearHydratedValues();
  }

  Future<List<PersistedHydratedRow>> readRows() {
    return _database.readHydratedRows();
  }

  @override
  Future<void> close() async {
    await _database.close();
  }
}
