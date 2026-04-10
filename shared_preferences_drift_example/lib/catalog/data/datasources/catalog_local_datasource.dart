import 'package:drift/drift.dart';

import '../app_database.dart';
import '../models/catalog_item.dart';

class CatalogLocalDataSource {
  const CatalogLocalDataSource(this._database);

  final AppDatabase _database;

  Stream<List<CatalogItem>> watchItems() {
    final query = _database.select(_database.catalogEntries)
      ..orderBy(<OrderingTerm Function(CatalogEntries)>[
        (CatalogEntries table) => OrderingTerm.desc(table.isPopular),
        (CatalogEntries table) => OrderingTerm.asc(table.title),
      ]);

    return query.watch().map(
      (List<CatalogEntry> rows) =>
          rows.map(CatalogItem.fromRow).toList(growable: false),
    );
  }

  Future<List<CatalogItem>> getItems() async {
    final query = _database.select(_database.catalogEntries)
      ..orderBy(<OrderingTerm Function(CatalogEntries)>[
        (CatalogEntries table) => OrderingTerm.desc(table.isPopular),
        (CatalogEntries table) => OrderingTerm.asc(table.title),
      ]);

    final rows = await query.get();
    return rows.map(CatalogItem.fromRow).toList(growable: false);
  }

  Future<int> countItems() async {
    final countExpression = _database.catalogEntries.id.count();
    final query = _database.selectOnly(_database.catalogEntries)
      ..addColumns(<Expression<Object>>[countExpression]);
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }

  Future<void> replaceAll(List<CatalogItem> items) async {
    await _database.transaction(() async {
      await _database.delete(_database.catalogEntries).go();
      await _database.batch((Batch batch) {
        batch.insertAll(
          _database.catalogEntries,
          items.map((CatalogItem item) => item.toCompanion()).toList(),
        );
      });
    });
  }

  Future<void> close() => _database.close();
}
