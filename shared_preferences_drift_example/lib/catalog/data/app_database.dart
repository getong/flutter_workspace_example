import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class CatalogEntries extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get summary => text()();

  TextColumn get category => text()();

  RealColumn get price => real()();

  IntColumn get stock => integer()();

  BoolColumn get isPopular => boolean()();

  DateTimeColumn get remoteUpdatedAt => dateTime()();

  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DriftDatabase(tables: [CatalogEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'catalog_cache'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}
