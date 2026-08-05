import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/entities/riverpod_task.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/repositories/riverpod_task_repository.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/presentation/pages/flutter_riverpod_page.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/riverpod_task_dependencies.dart';

void main() {
  testWidgets('adds a task and filters completed tasks', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 780));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _WidgetTestTaskRepository repository = _WidgetTestTaskRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          riverpodTaskRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: FlutterRiverpodPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('riverpod.taskField')),
      'Ship Riverpod example',
    );
    await tester.tap(find.byKey(const Key('riverpod.addButton')));
    await tester.pumpAndSettle();

    expect(find.text('Ship Riverpod example'), findsOneWidget);
    expect(repository.titles, contains('Ship Riverpod example'));

    await tester.tap(find.byKey(const Key('riverpod.toggle.task-2')));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const Key('riverpod.filter')),
      const Offset(-120, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('Ship Riverpod example'), findsOneWidget);
    expect(find.text('Initial task'), findsNothing);
  });
}

final class _WidgetTestTaskRepository implements RiverpodTaskRepository {
  final List<RiverpodTask> _tasks = <RiverpodTask>[
    const RiverpodTask(id: 'task-1', title: 'Initial task', isCompleted: false),
  ];

  Iterable<String> get titles => _tasks.map((RiverpodTask task) => task.title);

  @override
  Future<List<RiverpodTask>> getTasks() async {
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
