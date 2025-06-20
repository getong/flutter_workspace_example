import 'package:flutter/material.dart';

class StreamDataCard extends StatelessWidget {
  final int timerCount;
  final String lastButtonClick;
  final String textInputValue;

  const StreamDataCard({
    super.key,
    required this.timerCount,
    required this.lastButtonClick,
    required this.textInputValue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timer Count: $timerCount',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Button: $lastButtonClick',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Text Input: $textInputValue',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
