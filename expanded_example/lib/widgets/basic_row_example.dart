import 'package:flutter/material.dart';

/// Demonstrates basic Expanded usage in a Row
/// The Expanded widget will take up all available horizontal space
class BasicRowExample extends StatelessWidget {
  const BasicRowExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          // Fixed width container
          ColoredBox(
            color: Colors.purple,
            child: SizedBox(
              width: 80,
              height: double.infinity,
              child: Center(
                child: Text(
                  'Fixed\n80px',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // Expanded takes remaining space
          Expanded(
            child: ColoredBox(
              color: Colors.orange,
              child: Center(
                child: Text(
                  'Expanded\n(fills remaining space)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // Another fixed width container
          ColoredBox(
            color: Colors.teal,
            child: SizedBox(
              width: 60,
              height: double.infinity,
              child: Center(
                child: Text(
                  'Fixed\n60px',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
