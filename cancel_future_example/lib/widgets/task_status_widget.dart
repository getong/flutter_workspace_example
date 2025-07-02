import 'package:flutter/material.dart';
import '../models/task_state.dart';

/// Widget that displays the current status and progress of a task
class TaskStatusWidget extends StatelessWidget {
  final TaskState taskState;

  const TaskStatusWidget({
    super.key,
    required this.taskState,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Status: ${taskState.status}',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (taskState.isLoading) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: taskState.progress > 0 ? taskState.progress / 10 : null,
              ),
              const SizedBox(height: 8),
              Text('Progress: ${taskState.progress}/10'),
            ],
            if (taskState.error != null) ...[
              const SizedBox(height: 8),
              Text(
                'Error: ${taskState.error}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
