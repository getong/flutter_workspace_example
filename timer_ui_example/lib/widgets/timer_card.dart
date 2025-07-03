import 'package:flutter/material.dart';

class TimerCard extends StatelessWidget {
  final String title;
  final String timeDisplay;
  final bool isRunning;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onReset;
  final Color? timeColor;
  final bool hasControls;
  final bool isCountDisplay;

  const TimerCard({
    super.key,
    required this.title,
    required this.timeDisplay,
    this.isRunning = false,
    this.onStart,
    this.onStop,
    this.onReset,
    this.timeColor,
    this.hasControls = true,
    this.isCountDisplay = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              timeDisplay,
              style: TextStyle(
                fontSize: isCountDisplay ? 24 : 32,
                fontFamily: isCountDisplay ? null : 'monospace',
                color: timeColor ?? Colors.black,
              ),
            ),
            if (hasControls) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: isRunning ? null : onStart,
                    child: const Text('Start'),
                  ),
                  ElevatedButton(
                    onPressed: isRunning ? onStop : null,
                    child: const Text('Stop'),
                  ),
                  ElevatedButton(
                    onPressed: onReset,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
