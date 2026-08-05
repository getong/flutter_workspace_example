import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/entities/riverpod_task.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/repositories/riverpod_task_repository.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/presentation/providers/riverpod_task_providers.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/riverpod_task_dependencies.dart';

void main() {
  group('RiverpodTaskNotifier', () {
    late _FakeRiverpodTaskRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _FakeRiverpodTaskRepository();
      container = ProviderContainer(
        overrides: [
          riverpodTaskRepositoryProvider.overrideWithValue(repository),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('loads tasks through the overridden domain repository', () async {
      final List<RiverpodTask> tasks = await container.read(
        riverpodTaskListProvider.future,
      );

      expect(tasks.single.title, 'Initial task');
      expect(repository.getTasksCallCount, 1);
    });

    test('runs a command and publishes the refreshed immutable list', () async {
      await container.read(riverpodTaskListProvider.future);

      await container
          .read(riverpodTaskListProvider.notifier)
          .addTask('  Added through Notifier  ');

      final List<RiverpodTask> tasks = container
          .read(riverpodTaskListProvider)
          .requireValue;
      expect(tasks.last.title, 'Added through Notifier');
      expect(repository.getTasksCallCount, 2);
    });

    test('exposes domain validation failures as AsyncError', () async {
      await container.read(riverpodTaskListProvider.future);

      await container.read(riverpodTaskListProvider.notifier).addTask('   ');

      expect(
        container.read(riverpodTaskListProvider).error,
        isA<InvalidRiverpodTaskTitleException>(),
      );
    });
  });
}

final class _FakeRiverpodTaskRepository implements RiverpodTaskRepository {
  final List<RiverpodTask> _tasks = <RiverpodTask>[
    const RiverpodTask(id: 'task-1', title: 'Initial task', isCompleted: false),
  ];
  int getTasksCallCount = 0;

  @override
  Future<List<RiverpodTask>> getTasks() async {
    getTasksCallCount += 1;
    return List<RiverpodTask>.unmodifiable(_tasks);
  }

  @override
  Future<void> addTask(String title) async {
    _tasks.add(
      RiverpodTask(
        id: 'task-${_tasks.length + 1}',
        title: title,
        isCompleted: false,
      ),
    );
  }

  @override
  Future<void> clearCompletedTasks() async {
    _tasks.removeWhere((RiverpodTask task) => task.isCompleted);
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((RiverpodTask task) => task.id == id);
  }

  @override
  Future<void> toggleTask(String id) async {
    final int index = _tasks.indexWhere((RiverpodTask task) => task.id == id);
    final RiverpodTask task = _tasks[index];
    _tasks[index] = RiverpodTask(
      id: task.id,
      title: task.title,
      isCompleted: !task.isCompleted,
    );
  }
}
