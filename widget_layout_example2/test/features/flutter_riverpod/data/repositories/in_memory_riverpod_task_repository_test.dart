import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/data/datasources/in_memory_riverpod_task_data_source.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/data/models/riverpod_task_model.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/data/repositories/in_memory_riverpod_task_repository.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/entities/riverpod_task.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/repositories/riverpod_task_repository.dart';

void main() {
  group('InMemoryRiverpodTaskRepository', () {
    late RiverpodTaskRepository repository;

    setUp(() {
      repository = InMemoryRiverpodTaskRepository(
        dataSource: InMemoryRiverpodTaskDataSource(
          responseDelay: Duration.zero,
          initialTasks: const <RiverpodTaskModel>[
            RiverpodTaskModel(
              id: 'task-1',
              title: 'Existing task',
              isCompleted: false,
            ),
          ],
        ),
      );
    });

    test('maps records and persists task mutations', () async {
      await repository.addTask('New task');
      final List<RiverpodTask> addedTasks = await repository.getTasks();

      expect(addedTasks.map((RiverpodTask task) => task.title), <String>[
        'Existing task',
        'New task',
      ]);

      await repository.toggleTask('task-1');
      expect((await repository.getTasks()).first.isCompleted, isTrue);

      await repository.clearCompletedTasks();
      expect(
        (await repository.getTasks()).map((RiverpodTask task) => task.title),
        <String>['New task'],
      );
    });

    test('maps a missing data record to a domain exception', () async {
      await expectLater(
        repository.deleteTask('missing'),
        throwsA(
          isA<RiverpodTaskNotFoundException>().having(
            (RiverpodTaskNotFoundException error) => error.id,
            'id',
            'missing',
          ),
        ),
      );
    });
  });
}
