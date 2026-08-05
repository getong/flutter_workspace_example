import 'package:widget_layout_example2/features/flutter_riverpod/domain/entities/riverpod_task.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/repositories/riverpod_task_repository.dart';

final class GetRiverpodTasks {
  const GetRiverpodTasks(this._repository);

  final RiverpodTaskRepository _repository;

  Future<List<RiverpodTask>> call() => _repository.getTasks();
}

final class AddRiverpodTask {
  const AddRiverpodTask(this._repository);

  final RiverpodTaskRepository _repository;

  Future<void> call(String title) {
    final String normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      throw const InvalidRiverpodTaskTitleException();
    }
    return _repository.addTask(normalizedTitle);
  }
}

final class ToggleRiverpodTask {
  const ToggleRiverpodTask(this._repository);

  final RiverpodTaskRepository _repository;

  Future<void> call(String id) => _repository.toggleTask(id);
}

final class DeleteRiverpodTask {
  const DeleteRiverpodTask(this._repository);

  final RiverpodTaskRepository _repository;

  Future<void> call(String id) => _repository.deleteTask(id);
}

final class ClearCompletedRiverpodTasks {
  const ClearCompletedRiverpodTasks(this._repository);

  final RiverpodTaskRepository _repository;

  Future<void> call() => _repository.clearCompletedTasks();
}
