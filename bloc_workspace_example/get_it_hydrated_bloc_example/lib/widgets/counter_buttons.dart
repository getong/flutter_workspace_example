import 'package:flutter/material.dart';

class CounterButtons extends StatelessWidget {
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onReset;
  final bool showReset;

  const CounterButtons({
    super.key,
    required this.onIncrement,
    required this.onDecrement,
    this.onReset,
    this.showReset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onDecrement,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Icon(Icons.remove),
        ),
        if (showReset && onReset != null)
          ElevatedButton(onPressed: onReset, child: const Text('Reset')),
        ElevatedButton(
          onPressed: onIncrement,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
