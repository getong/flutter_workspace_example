import 'package:widget_layout_example2/features/flutter_riverpod/domain/entities/riverpod_task.dart';

abstract interface class RiverpodTaskRepository {
  Future<List<RiverpodTask>> getTasks();

  Future<void> addTask(String title);

  Future<void> toggleTask(String id);

  Future<void> deleteTask(String id);

  Future<void> clearCompletedTasks();
}

final class InvalidRiverpodTaskTitleException implements Exception {
  const InvalidRiverpodTaskTitleException();

  @override
  String toString() => 'Task title cannot be empty.';
}

final class RiverpodTaskNotFoundException implements Exception {
  const RiverpodTaskNotFoundException(this.id);

  final String id;

  @override
  String toString() => 'Task $id was not found.';
}
