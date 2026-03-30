import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

class PersistedHydratedRow {
  const PersistedHydratedRow({
    required this.key,
    required this.value,
    required this.updatedAt,
  });

  final String key;
  final String value;
  final DateTime updatedAt;
}

class AppDatabase extends GeneratedDatabase {
  AppDatabase._(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const <Never>[];

  static Future<AppDatabase> create() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File databaseFile = File(
      '${directory.path}/hydrated_bloc_drift.sqlite',
    );
    final AppDatabase database = AppDatabase._(
      NativeDatabase.createInBackground(databaseFile),
    );
    await database._createSchemaIfNeeded();
    return database;
  }

  Future<void> _createSchemaIfNeeded() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS hydrated_storage (
        key TEXT PRIMARY KEY NOT NULL,
        value TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }

  Future<Map<String, dynamic>> readHydratedCache() async {
    final List<QueryRow> rows = await customSelect(
      'SELECT key, value FROM hydrated_storage',
    ).get();

    final Map<String, dynamic> cache = <String, dynamic>{};
    for (final QueryRow row in rows) {
      final String key = row.read<String>('key');
      final String value = row.read<String>('value');
      try {
        cache[key] = jsonDecode(value);
      } catch (_) {
        // Ignore malformed row values so hydration can continue.
      }
    }
    return cache;
  }

  Future<void> upsertHydratedValue(String key, dynamic value) async {
    final int now = DateTime.now().millisecondsSinceEpoch;
    final String encoded = jsonEncode(value);

    await customStatement(
      '''
      INSERT INTO hydrated_storage (key, value, updated_at)
      VALUES (?, ?, ?)
      ON CONFLICT(key) DO UPDATE SET
        value = excluded.value,
        updated_at = excluded.updated_at
      ''',
      <Object>[key, encoded, now],
    );
  }

  Future<void> deleteHydratedValue(String key) async {
    await customStatement(
      'DELETE FROM hydrated_storage WHERE key = ?',
      <Object>[key],
    );
  }

  Future<void> clearHydratedValues() async {
    await customStatement('DELETE FROM hydrated_storage');
  }

  Future<List<PersistedHydratedRow>> readHydratedRows() async {
    final List<QueryRow> rows = await customSelect('''
      SELECT key, value, updated_at
      FROM hydrated_storage
      ORDER BY updated_at DESC
      ''').get();

    return rows.map((QueryRow row) {
      return PersistedHydratedRow(
        key: row.read<String>('key'),
        value: row.read<String>('value'),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          row.read<int>('updated_at'),
        ),
      );
    }).toList();
  }
}
