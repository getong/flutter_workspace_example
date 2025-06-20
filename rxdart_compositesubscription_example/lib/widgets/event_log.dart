import 'package:flutter/material.dart';

class EventLog extends StatelessWidget {
  final List<String> events;

  const EventLog({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Combined Events:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[events.length - 1 - index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.event, size: 16),
                  title: Text(event, style: const TextStyle(fontSize: 14)),
                  subtitle: Text('${DateTime.now().millisecondsSinceEpoch}'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
