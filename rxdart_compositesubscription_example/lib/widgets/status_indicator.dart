import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final bool isActive;

  const StatusIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.play_circle : Icons.stop_circle,
            color: isActive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            'Subscriptions: ${isActive ? 'Active' : 'Stopped'}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
