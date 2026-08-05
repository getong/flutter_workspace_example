import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/entities/riverpod_task.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/domain/repositories/riverpod_task_repository.dart';
import 'package:widget_layout_example2/features/flutter_riverpod/presentation/providers/riverpod_task_providers.dart';

@RoutePage(name: RouteName.flutterRiverpod)
class FlutterRiverpodPage extends ConsumerStatefulWidget {
  const FlutterRiverpodPage({super.key});

  @override
  ConsumerState<FlutterRiverpodPage> createState() =>
      _FlutterRiverpodPageState();
}

class _FlutterRiverpodPageState extends ConsumerState<FlutterRiverpodPage> {
  static const double _maxContentWidth = 760;
  static const double _pagePadding = 20;
  static const double _sectionSpacing = 20;
  static const double _itemSpacing = 12;

  // 输入草稿只属于当前 TextField，是短生命周期 UI 状态，不需要放进 Riverpod。
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    final String title = _taskController.text;
    await ref.read(riverpodTaskListProvider.notifier).addTask(title);
    if (mounted && ref.read(riverpodTaskListProvider).hasValue) {
      _taskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 这三个 watch 分别订阅“完整列表、实时派生列表、筛选条件”。Provider
    // 发布新状态时，Riverpod 会安排当前 Consumer 在下一帧重建；未 watch
    // 这些 Provider 的其他现有组件不会受到影响。
    final AsyncValue<List<RiverpodTask>> allTasks = ref.watch(
      riverpodTaskListProvider,
    );
    final AsyncValue<List<RiverpodTask>> visibleTasks = ref.watch(
      visibleRiverpodTasksProvider,
    );
    final RiverpodTaskFilter filter = ref.watch(riverpodTaskFilterProvider);
    final List<RiverpodTask> taskValues =
        allTasks.value ?? const <RiverpodTask>[];
    final int completedCount = taskValues
        .where((RiverpodTask task) => task.isCompleted)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_riverpod', overflow: TextOverflow.ellipsis),
        actions: <Widget>[
          IconButton(
            key: const Key('riverpod.clearCompletedButton'),
            tooltip: 'Clear completed',
            onPressed: completedCount == 0 || allTasks.isLoading
                ? null
                : () => ref
                      .read(riverpodTaskListProvider.notifier)
                      .clearCompletedTasks(),
            icon: const Icon(Icons.cleaning_services_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: ListView(
              padding: const EdgeInsets.all(_pagePadding),
              children: <Widget>[
                _TaskSummary(
                  totalCount: taskValues.length,
                  completedCount: completedCount,
                ),
                const SizedBox(height: _sectionSpacing),
                _TaskComposer(
                  controller: _taskController,
                  isLoading: allTasks.isLoading,
                  onSubmitted: _addTask,
                ),
                const SizedBox(height: _sectionSpacing),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<RiverpodTaskFilter>(
                    key: const Key('riverpod.filter'),
                    showSelectedIcon: false,
                    segments: const <ButtonSegment<RiverpodTaskFilter>>[
                      ButtonSegment<RiverpodTaskFilter>(
                        value: RiverpodTaskFilter.all,
                        icon: Icon(Icons.list_alt_outlined),
                        label: Text('All'),
                      ),
                      ButtonSegment<RiverpodTaskFilter>(
                        value: RiverpodTaskFilter.active,
                        icon: Icon(Icons.radio_button_unchecked),
                        label: Text('Active'),
                      ),
                      ButtonSegment<RiverpodTaskFilter>(
                        value: RiverpodTaskFilter.completed,
                        icon: Icon(Icons.task_alt),
                        label: Text('Done'),
                      ),
                    ],
                    selected: <RiverpodTaskFilter>{filter},
                    onSelectionChanged: (Set<RiverpodTaskFilter> selection) {
                      // read 只发送事件，不建立额外订阅。Notifier 更新 state 后，
                      // 上面的 watch 会收到变化并实时刷新选中项和任务列表。
                      ref
                          .read(riverpodTaskFilterProvider.notifier)
                          .select(selection.single);
                    },
                  ),
                ),
                const SizedBox(height: _itemSpacing),
                visibleTasks.when(
                  data: (List<RiverpodTask> tasks) => _TaskList(
                    tasks: tasks,
                    onToggle: (String id) => ref
                        .read(riverpodTaskListProvider.notifier)
                        .toggleTask(id),
                    onDelete: (String id) => ref
                        .read(riverpodTaskListProvider.notifier)
                        .deleteTask(id),
                  ),
                  error: (Object error, StackTrace stackTrace) =>
                      _TaskErrorPanel(
                        message: _errorMessage(error),
                        onRetry: () =>
                            ref.read(riverpodTaskListProvider.notifier).retry(),
                      ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 72),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _errorMessage(Object error) {
    return switch (error) {
      InvalidRiverpodTaskTitleException() => 'Enter a task title.',
      RiverpodTaskNotFoundException() => 'That task is no longer available.',
      _ => 'Tasks could not be updated. Try again.',
    };
  }
}

class _TaskSummary extends StatelessWidget {
  const _TaskSummary({required this.totalCount, required this.completedCount});

  final int totalCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int remainingCount = totalCount - completedCount;

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Today\'s tasks',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$remainingCount remaining',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _CountBadge(value: completedCount, label: 'done'),
        const SizedBox(width: 8),
        _CountBadge(value: totalCount, label: 'total'),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 58),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$value',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskComposer extends StatelessWidget {
  const _TaskComposer({
    required this.controller,
    required this.isLoading,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool isLoading;
  final Future<void> Function() onSubmitted;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget field = TextField(
          key: const Key('riverpod.taskField'),
          controller: controller,
          enabled: !isLoading,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmitted(),
          decoration: const InputDecoration(
            labelText: 'New task',
            prefixIcon: Icon(Icons.edit_note_outlined),
            border: OutlineInputBorder(),
          ),
        );
        final Widget button = FilledButton.icon(
          key: const Key('riverpod.addButton'),
          onPressed: isLoading ? null : onSubmitted,
          icon: const Icon(Icons.add),
          label: const Text('Add task'),
        );

        if (constraints.maxWidth < 520) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[field, const SizedBox(height: 12), button],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(child: field),
            const SizedBox(width: 12),
            button,
          ],
        );
      },
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
  });

  final List<RiverpodTask> tasks;
  final void Function(String id) onToggle;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const _EmptyTaskPanel();
    }

    return Column(
      children: <Widget>[
        for (final RiverpodTask task in tasks) ...<Widget>[
          Card(
            key: Key('riverpod.task.${task.id}'),
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
              leading: Checkbox(
                key: Key('riverpod.toggle.${task.id}'),
                value: task.isCompleted,
                onChanged: (_) => onToggle(task.id),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: IconButton(
                tooltip: 'Delete task',
                onPressed: () => onDelete(task.id),
                icon: const Icon(Icons.delete_outline),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _EmptyTaskPanel extends StatelessWidget {
  const _EmptyTaskPanel();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text('No tasks in this view', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _TaskErrorPanel extends StatelessWidget {
  const _TaskErrorPanel({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: <Widget>[
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
