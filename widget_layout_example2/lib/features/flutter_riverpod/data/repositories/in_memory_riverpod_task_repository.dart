import 'package:widget_layout_example2/features/flutter_riverpod/data/datasources/in_memory_riverpod_task_data_source.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/data/models/riverpod_task_model.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/entities/riverpod_task.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/repositories/riverpod_task_repository.dart';

final class InMemoryRiverpodTaskRepository implements RiverpodTaskRepository {
  const InMemoryRiverpodTaskRepository({
    required RiverpodTaskDataSource dataSource,
  }) : _dataSource = dataSource;

  final RiverpodTaskDataSource _dataSource;

  @override
  Future<List<RiverpodTask>> getTasks() async {
    final List<RiverpodTaskModel> models = await _dataSource.fetchTasks();
    return List<RiverpodTask>.unmodifiable(
      models.map((RiverpodTaskModel model) => model.toEntity()),
    );
  }

  @override
  Future<void> addTask(String title) => _dataSource.insertTask(title);

  @override
  Future<void> clearCompletedTasks() => _dataSource.deleteCompletedTasks();

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _dataSource.deleteTask(id);
    } on RiverpodTaskRecordNotFoundException {
      throw RiverpodTaskNotFoundException(id);
    }
  }

  @override
  Future<void> toggleTask(String id) async {
    try {
      await _dataSource.toggleTask(id);
    } on RiverpodTaskRecordNotFoundException {
      throw RiverpodTaskNotFoundException(id);
    }
  }
}
