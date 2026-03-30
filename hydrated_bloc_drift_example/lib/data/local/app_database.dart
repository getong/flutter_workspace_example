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

class PersistedFetchHistoryRow {
  const PersistedFetchHistoryRow({
    required this.id,
    required this.url,
    required this.statusCode,
    required this.isSuccess,
    required this.responseBody,
    required this.fetchedAt,
  });

  final int id;
  final String url;
  final int? statusCode;
  final bool isSuccess;
  final String responseBody;
  final DateTime fetchedAt;
}

class AppDatabase extends GeneratedDatabase {
  AppDatabase._(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await _createSchemaIfNeeded();
    },
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 2) {
        await customStatement('''
          CREATE TABLE IF NOT EXISTS dio_fetch_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT NOT NULL,
            status_code INTEGER,
            is_success INTEGER NOT NULL,
            response_body TEXT NOT NULL,
            fetched_at INTEGER NOT NULL
          )
        ''');
      }
    },
    beforeOpen: (OpeningDetails details) async {
      await _createSchemaIfNeeded();
    },
  );

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
    await customStatement('''
      CREATE TABLE IF NOT EXISTS dio_fetch_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT NOT NULL,
        status_code INTEGER,
        is_success INTEGER NOT NULL,
        response_body TEXT NOT NULL,
        fetched_at INTEGER NOT NULL
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

  Future<int> insertFetchHistory({
    required String url,
    required int? statusCode,
    required bool isSuccess,
    required String responseBody,
    required DateTime fetchedAt,
  }) async {
    await customStatement(
      '''
      INSERT INTO dio_fetch_history (
        url,
        status_code,
        is_success,
        response_body,
        fetched_at
      ) VALUES (?, ?, ?, ?, ?)
      ''',
      <Object?>[
        url,
        statusCode,
        isSuccess ? 1 : 0,
        responseBody,
        fetchedAt.millisecondsSinceEpoch,
      ],
    );
    final QueryRow row = await customSelect(
      'SELECT last_insert_rowid() AS id',
    ).getSingle();
    return row.read<int>('id');
  }

  Future<List<PersistedFetchHistoryRow>> readFetchHistoryRows() async {
    final List<QueryRow> rows = await customSelect('''
      SELECT id, url, status_code, is_success, response_body, fetched_at
      FROM dio_fetch_history
      ORDER BY fetched_at DESC, id DESC
    ''').get();

    return rows.map(_mapFetchHistoryRow).toList();
  }

  Future<PersistedFetchHistoryRow?> readFetchHistoryRowById(int id) async {
    final QueryRow? row = await customSelect(
      '''
      SELECT id, url, status_code, is_success, response_body, fetched_at
      FROM dio_fetch_history
      WHERE id = ?
      LIMIT 1
      ''',
      variables: <Variable<Object>>[Variable<int>(id)],
    ).getSingleOrNull();

    if (row == null) {
      return null;
    }
    return _mapFetchHistoryRow(row);
  }

  PersistedFetchHistoryRow _mapFetchHistoryRow(QueryRow row) {
    return PersistedFetchHistoryRow(
      id: row.read<int>('id'),
      url: row.read<String>('url'),
      statusCode: row.readNullable<int>('status_code'),
      isSuccess: row.read<int>('is_success') == 1,
      responseBody: row.read<String>('response_body'),
      fetchedAt: DateTime.fromMillisecondsSinceEpoch(
        row.read<int>('fetched_at'),
      ),
    );
  }
}
