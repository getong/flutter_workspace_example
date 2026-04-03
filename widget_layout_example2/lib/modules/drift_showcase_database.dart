import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'drift_showcase_database.g.dart';

@DataClassName('DriftTodoEntry')
class DriftTodos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 120)();

  TextColumn get category => text().withDefault(const Constant('General'))();

  IntColumn get priority => integer().withDefault(const Constant(3))();

  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

class DriftTodoSummary {
  const DriftTodoSummary({
    required this.total,
    required this.completed,
    required this.pending,
    required this.highPriority,
  });

  final int total;
  final int completed;
  final int pending;
  final int highPriority;
}

class DriftCategoryCount {
  const DriftCategoryCount({
    required this.category,
    required this.itemCount,
    required this.completedCount,
  });

  final String category;
  final int itemCount;
  final int completedCount;
}

@DriftDatabase(tables: <Type>[DriftTodos])
class DriftShowcaseDatabase extends _$DriftShowcaseDatabase {
  DriftShowcaseDatabase()
    : super(driftDatabase(name: 'widget_layout_example2_drift_showcase'));

  @override
  int get schemaVersion => 1;

  Future<void> seedDemoData() async {
    final QueryRow row = await customSelect(
      'SELECT COUNT(*) AS item_count FROM drift_todos',
      readsFrom: <TableInfo<Table, Object?>>{driftTodos},
    ).getSingle();

    if (row.read<int>('item_count') > 0) {
      return;
    }

    await batch((Batch batch) {
      batch.insertAll(driftTodos, _sampleTodoCompanions);
    });
  }

  Future<int> addTodo({
    required String title,
    required String category,
    required int priority,
    String? notes,
  }) {
    return into(driftTodos).insert(
      DriftTodosCompanion.insert(
        title: title,
        category: Value(category),
        priority: Value(priority),
        notes: Value(notes?.trim().isEmpty ?? true ? null : notes!.trim()),
      ),
    );
  }

  Stream<List<DriftTodoEntry>> watchTodos({
    required String search,
    required bool hideCompleted,
  }) {
    final SimpleSelectStatement<$DriftTodosTable, DriftTodoEntry> query =
        select(driftTodos)..orderBy(<OrderingTerm Function(DriftTodos)>[
          (DriftTodos table) => OrderingTerm.asc(table.completed),
          (DriftTodos table) => OrderingTerm.desc(table.priority),
          (DriftTodos table) => OrderingTerm.desc(table.createdAt),
        ]);

    final String trimmedSearch = search.trim();
    if (trimmedSearch.isNotEmpty) {
      query.where(
        (DriftTodos table) =>
            table.title.contains(trimmedSearch) |
            table.category.contains(trimmedSearch) |
            table.notes.contains(trimmedSearch),
      );
    }

    if (hideCompleted) {
      query.where((DriftTodos table) => table.completed.equals(false));
    }

    return query.watch();
  }

  Stream<DriftTodoSummary> watchSummary() {
    return customSelect(
      'SELECT '
      'COUNT(*) AS total_count, '
      'SUM(CASE WHEN completed = 1 THEN 1 ELSE 0 END) AS completed_count, '
      'SUM(CASE WHEN completed = 0 THEN 1 ELSE 0 END) AS pending_count, '
      'SUM(CASE WHEN priority >= 4 THEN 1 ELSE 0 END) AS high_priority_count '
      'FROM drift_todos',
      readsFrom: <TableInfo<Table, Object?>>{driftTodos},
    ).watchSingle().map((QueryRow row) {
      return DriftTodoSummary(
        total: row.read<int>('total_count'),
        completed: row.read<int>('completed_count'),
        pending: row.read<int>('pending_count'),
        highPriority: row.read<int>('high_priority_count'),
      );
    });
  }

  Stream<List<DriftCategoryCount>> watchCategoryCounts() {
    return customSelect(
      'SELECT '
      'category, '
      'COUNT(*) AS item_count, '
      'SUM(CASE WHEN completed = 1 THEN 1 ELSE 0 END) AS completed_count '
      'FROM drift_todos '
      'GROUP BY category '
      'ORDER BY item_count DESC, category ASC',
      readsFrom: <TableInfo<Table, Object?>>{driftTodos},
    ).watch().map((List<QueryRow> rows) {
      return rows
          .map(
            (QueryRow row) => DriftCategoryCount(
              category: row.read<String>('category'),
              itemCount: row.read<int>('item_count'),
              completedCount: row.read<int>('completed_count'),
            ),
          )
          .toList();
    });
  }

  Future<int> toggleCompleted(DriftTodoEntry entry) {
    return (update(driftTodos)
          ..where((DriftTodos table) => table.id.equals(entry.id)))
        .write(DriftTodosCompanion(completed: Value(!entry.completed)));
  }

  Future<int> increasePriority(int id, int currentPriority) {
    final int nextPriority = currentPriority >= 5 ? 5 : currentPriority + 1;
    return (update(driftTodos)
          ..where((DriftTodos table) => table.id.equals(id)))
        .write(DriftTodosCompanion(priority: Value(nextPriority)));
  }

  Future<int> renameFirstPending() async {
    final DriftTodoEntry? firstPending =
        await (select(driftTodos)
              ..where((DriftTodos table) => table.completed.equals(false))
              ..orderBy(<OrderingTerm Function(DriftTodos)>[
                (DriftTodos table) => OrderingTerm.desc(table.priority),
                (DriftTodos table) => OrderingTerm.asc(table.createdAt),
              ])
              ..limit(1))
            .getSingleOrNull();

    if (firstPending == null) {
      return 0;
    }

    return (update(
      driftTodos,
    )..where((DriftTodos table) => table.id.equals(firstPending.id))).write(
      DriftTodosCompanion(title: Value('${firstPending.title} • reviewed')),
    );
  }

  Future<int> markCategoryDone(String category) {
    return (update(driftTodos)..where(
          (DriftTodos table) =>
              table.category.equals(category) & table.completed.equals(false),
        ))
        .write(const DriftTodosCompanion(completed: Value(true)));
  }

  Future<int> deleteTodo(int id) {
    return (delete(
      driftTodos,
    )..where((DriftTodos table) => table.id.equals(id))).go();
  }

  Future<int> clearCompleted() {
    return (delete(
      driftTodos,
    )..where((DriftTodos table) => table.completed.equals(true))).go();
  }

  Future<void> resetDemo() async {
    await transaction(() async {
      await delete(driftTodos).go();
      await batch((Batch batch) {
        batch.insertAll(driftTodos, _sampleTodoCompanions);
      });
    });
  }

  List<DriftTodosCompanion> get _sampleTodoCompanions => <DriftTodosCompanion>[
    DriftTodosCompanion.insert(
      title: 'Review drift database setup',
      category: Value('Development'),
      priority: Value(5),
      notes: Value(
        'Open the module and inspect the generated SQL-backed list.',
      ),
    ),
    DriftTodosCompanion.insert(
      title: 'Draft migration checklist',
      category: Value('Planning'),
      priority: Value(4),
      notes: Value('Schema changes, seed data, and app upgrade notes.'),
    ),
    DriftTodosCompanion.insert(
      title: 'Polish desktop interactions',
      category: Value('UX'),
      priority: Value(3),
      notes: Value('Verify keyboard and mouse flows on macOS.'),
    ),
    DriftTodosCompanion.insert(
      title: 'Archive completed experiments',
      category: Value('Maintenance'),
      priority: Value(2),
      completed: Value(true),
      notes: Value('Use clear completed to remove these rows.'),
    ),
  ];
}
