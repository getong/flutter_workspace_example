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
        // await customStatement('DROP TABLE IF EXISTS advice_entries;');
        await migrator.createTable(adviceEntries);
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
    final rows = await (select(
      adviceEntries,
    )..orderBy([(table) => OrderingTerm.desc(table.updatedAt)])).get();

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
