import 'package:drift/drift.dart';

import '../../domain/entities/advice.dart';
import 'advice_database_stub.dart'
    if (dart.library.io) 'advice_database_io.dart';

part 'advice_database.g.dart';

class AdviceEntries extends Table {
  IntColumn get id => integer()();

  TextColumn get message => text()();

  TextColumn get source => text()();

  TextColumn get author => text().nullable()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(tables: [AdviceEntries])
class AdviceDatabase extends _$AdviceDatabase {
  AdviceDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> cacheAdvice(Advice advice) {
    return into(adviceEntries).insertOnConflictUpdate(
      AdviceEntriesCompanion(
        id: Value(advice.id),
        message: Value(advice.message),
        source: Value(advice.source),
        author: Value(advice.author),
        updatedAt: Value(DateTime.now()),
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

  Stream<List<Advice>> watchSavedAdvice() {
    return (select(adviceEntries)
          ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]))
        .watch()
        .map((rows) => rows.map(_mapRowToAdvice).toList(growable: false));
  }

  Advice _mapRowToAdvice(AdviceEntry row) {
    return Advice(
      id: row.id,
      message: row.message,
      source: row.source,
      author: row.author,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    return createAdviceQueryExecutor();
  });
}
