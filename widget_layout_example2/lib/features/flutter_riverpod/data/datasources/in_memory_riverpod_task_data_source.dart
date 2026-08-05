import 'package:widget_layout_example2/features/flutter_riverpod/data/models/riverpod_task_model.dart';

abstract interface class RiverpodTaskDataSource {
  Future<List<RiverpodTaskModel>> fetchTasks();

  Future<void> insertTask(String title);

  Future<void> toggleTask(String id);

  Future<void> deleteTask(String id);

  Future<void> deleteCompletedTasks();
}

final class InMemoryRiverpodTaskDataSource implements RiverpodTaskDataSource {
  InMemoryRiverpodTaskDataSource({
    this.responseDelay = const Duration(milliseconds: 220),
    List<RiverpodTaskModel>? initialTasks,
  }) : _tasks = List<RiverpodTaskModel>.of(
         initialTasks ??
             const <RiverpodTaskModel>[
               RiverpodTaskModel(
                 id: 'task-1',
                 title: 'Review clean architecture boundaries',
                 isCompleted: true,
               ),
               RiverpodTaskModel(
                 id: 'task-2',
                 title: 'Connect the Riverpod dependency graph',
                 isCompleted: false,
               ),
               RiverpodTaskModel(
                 id: 'task-3',
                 title: 'Cover providers with tests',
                 isCompleted: false,
               ),
             ],
       );

  final Duration responseDelay;
  final List<RiverpodTaskModel> _tasks;
  int _nextId = 4;

  @override
  Future<List<RiverpodTaskModel>> fetchTasks() async {
    await Future<void>.delayed(responseDelay);
    return List<RiverpodTaskModel>.unmodifiable(_tasks);
  }

  @override
  Future<void> insertTask(String title) async {
    await Future<void>.delayed(responseDelay);
    _tasks.add(
      RiverpodTaskModel(
        id: 'task-${_nextId++}',
        title: title,
        isCompleted: false,
      ),
    );
  }

  @override
  Future<void> toggleTask(String id) async {
    await Future<void>.delayed(responseDelay);
    final int index = _tasks.indexWhere(
      (RiverpodTaskModel task) => task.id == id,
    );
    if (index == -1) {
      throw RiverpodTaskRecordNotFoundException(id);
    }
    final RiverpodTaskModel task = _tasks[index];
    _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
  }

  @override
  Future<void> deleteTask(String id) async {
    await Future<void>.delayed(responseDelay);
    final int removedCount = _tasks.length;
    _tasks.removeWhere((RiverpodTaskModel task) => task.id == id);
    if (_tasks.length == removedCount) {
      throw RiverpodTaskRecordNotFoundException(id);
    }
  }

  @override
  Future<void> deleteCompletedTasks() async {
    await Future<void>.delayed(responseDelay);
    _tasks.removeWhere((RiverpodTaskModel task) => task.isCompleted);
  }
}

final class RiverpodTaskRecordNotFoundException implements Exception {
  const RiverpodTaskRecordNotFoundException(this.id);

  final String id;
}
