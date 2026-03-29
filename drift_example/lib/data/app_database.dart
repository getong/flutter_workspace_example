import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 120)();

  TextColumn get description => text().nullable()();

  BoolColumn get isDone => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: <Type>[Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'drift_todo.sqlite'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  Stream<List<Todo>> watchAllTodos() {
    return (select(todos)..orderBy(<OrderingTerm Function(Todos)>[
          (Todos t) => OrderingTerm.asc(t.isDone),
          (Todos t) => OrderingTerm.desc(t.createdAt),
        ]))
        .watch();
  }

  Stream<Todo?> watchTodoById(int id) {
    return (select(
      todos,
    )..where((Todos t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<Todo?> getTodoById(int id) {
    return (select(
      todos,
    )..where((Todos t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> createTodo({required String title, String? description}) {
    final String normalizedTitle = title.trim();
    final String? normalizedDescription = _normalizeDescription(description);

    return into(todos).insert(
      TodosCompanion.insert(
        title: normalizedTitle,
        description: Value<String?>(normalizedDescription),
      ),
    );
  }

  Future<int> updateTodo({
    required int id,
    required String title,
    String? description,
  }) {
    final String normalizedTitle = title.trim();
    final String? normalizedDescription = _normalizeDescription(description);

    return (update(todos)..where((Todos t) => t.id.equals(id))).write(
      TodosCompanion(
        title: Value<String>(normalizedTitle),
        description: Value<String?>(normalizedDescription),
      ),
    );
  }

  Future<int> setTodoDone({required int id, required bool isDone}) {
    return (update(todos)..where((Todos t) => t.id.equals(id))).write(
      TodosCompanion(isDone: Value<bool>(isDone)),
    );
  }

  Future<int> deleteTodo(int id) {
    return (delete(todos)..where((Todos t) => t.id.equals(id))).go();
  }

  String? _normalizeDescription(String? description) {
    final String? trimmed = description?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
