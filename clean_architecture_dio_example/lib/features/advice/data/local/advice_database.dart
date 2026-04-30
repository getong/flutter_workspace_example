import 'package:drift/drift.dart';

import '../../domain/entities/advice.dart';
import 'advice_database_stub.dart'
    if (dart.library.io) 'advice_database_io.dart';

part 'advice_database.g.dart';

class AdviceEntries extends Table {
  IntColumn get entryId => integer().autoIncrement()();

  IntColumn get adviceId => integer()();

  TextColumn get message => text()();

  TextColumn get source => text()();

  TextColumn get author => text().nullable()();

  DateTimeColumn get updatedAt => dateTime()();
}

@DriftDatabase(tables: [AdviceEntries])
class AdviceDatabase extends _$AdviceDatabase {
  AdviceDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.renameColumn(
          adviceEntries,
          'id',
          adviceEntries.adviceId,
        );
        await customStatement(
          'ALTER TABLE advice_entries ADD COLUMN entry_id INTEGER;',
        );
        await customStatement('''
          CREATE TABLE advice_entries_v2 (
            entry_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            advice_id INTEGER NOT NULL,
            message TEXT NOT NULL,
            source TEXT NOT NULL,
            author TEXT,
            updated_at TEXT NOT NULL
          );
          ''');
        await customStatement('''
          INSERT INTO advice_entries_v2 (advice_id, message, source, author, updated_at)
          SELECT advice_id, message, source, author, updated_at
          FROM advice_entries
          ORDER BY updated_at ASC;
          ''');
        await customStatement('DROP TABLE advice_entries;');
        await customStatement(
          'ALTER TABLE advice_entries_v2 RENAME TO advice_entries;',
        );
      }
    },
  );

  Future<void> cacheAdvice(Advice advice) {
    return into(adviceEntries).insert(
      AdviceEntriesCompanion.insert(
        adviceId: advice.id,
        message: advice.message,
        source: advice.source,
        author: Value(advice.author),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<Advice?> getLatestAdvice() async {
    final row =
        await (select(adviceEntries)
              ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)])
              ..limit(1))
            .getSingleOrNull();

    return row == null ? null : _mapRowToAdvice(row);
  }

  Future<List<Advice>> getSavedAdvice() async {
    final rows = await (select(adviceEntries)
          ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]))
        .get();

    return rows.map(_mapRowToAdvice).toList(growable: false);
  }

  Stream<List<Advice>> watchSavedAdvice() {
    return (select(adviceEntries)
          ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]))
        .watch()
        .map((rows) => rows.map(_mapRowToAdvice).toList(growable: false));
  }

  Advice _mapRowToAdvice(AdviceEntry row) {
    return Advice(
      id: row.adviceId,
      message: row.message,
      source: row.source,
      author: row.author,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    return await createAdviceQueryExecutor();
  });
}
