import 'package:drift/drift.dart';

import '../app_database.dart';
import '../models/catalog_item.dart';

class CatalogLocalDataSource {
  CatalogLocalDataSource(this._database);

  final AppDatabase _database;

  /// Shared ordering clause reused by both watch and one-shot queries.
  static final _defaultOrder = <OrderingTerm Function(CatalogEntries)>[
    (CatalogEntries t) => OrderingTerm.desc(t.isPopular),
    (CatalogEntries t) => OrderingTerm.asc(t.title),
  ];

  Stream<List<CatalogItem>> watchItems() {
    final query = _database.select(_database.catalogEntries)
      ..orderBy(_defaultOrder);

    return query.watch().map(
      (List<CatalogEntry> rows) =>
          rows.map(CatalogItem.fromRow).toList(growable: false),
    );
  }

  Future<List<CatalogItem>> getItems() async {
    final query = _database.select(_database.catalogEntries)
      ..orderBy(_defaultOrder);

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

  /// Upserts items instead of delete-all + re-insert.
  ///
  /// This avoids destroying every row and triggering a full stream rebuild
  /// when only a subset of fields changed. Drift's stream query system can
  /// detect that untouched rows are unchanged and skip unnecessary UI rebuilds.
  Future<void> upsertAll(List<CatalogItem> items) async {
    await _database.batch((Batch batch) {
      batch.insertAllOnConflictUpdate(
        _database.catalogEntries,
        items.map((CatalogItem item) => item.toCompanion()).toList(),
      );
    });
  }

  /// Removes rows whose IDs are NOT in [retainIds].
  ///
  /// Call after [upsertAll] to prune items that vanished from the remote
  /// source without deleting rows that are still current.
  Future<void> pruneExcept(Set<String> retainIds) async {
    if (retainIds.isEmpty) return;
    await (_database.delete(_database.catalogEntries)
          ..where(($CatalogEntriesTable t) => t.id.isNotIn(retainIds.toList())))
        .go();
  }

  Future<void> close() => _database.close();
}
