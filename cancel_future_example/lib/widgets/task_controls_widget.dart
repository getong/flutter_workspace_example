import 'package:flutter/material.dart';

/// Widget that displays control buttons for task operations
class TaskControlsWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onStartTask;
  final VoidCallback? onCancelTask;
  final VoidCallback? onNetworkRequest;

  const TaskControlsWidget({
    super.key,
    required this.isLoading,
    this.onStartTask,
    this.onCancelTask,
    this.onNetworkRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: isLoading ? null : onStartTask,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Long Task (5 seconds)'),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: isLoading ? onCancelTask : null,
          icon: const Icon(Icons.stop),
          label: const Text('Cancel Task'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: isLoading ? null : onNetworkRequest,
          icon: const Icon(Icons.cloud_download),
          label: const Text('Network Request (with timeout)'),
        ),
      ],
    );
  }
}
