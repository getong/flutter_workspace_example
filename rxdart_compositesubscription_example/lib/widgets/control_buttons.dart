import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  final bool subscriptionsActive;
  final VoidCallback onToggleSubscriptions;
  final VoidCallback onRestart;

  const ControlButtons({
    super.key,
    required this.subscriptionsActive,
    required this.onToggleSubscriptions,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: onToggleSubscriptions,
          icon: Icon(subscriptionsActive ? Icons.stop : Icons.play_arrow),
          label: Text(subscriptionsActive ? 'Stop All' : 'Start All'),
          style: ElevatedButton.styleFrom(
            backgroundColor: subscriptionsActive ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: onRestart,
          icon: const Icon(Icons.refresh),
          label: const Text('Restart'),
        ),
      ],
    );
  }
}
