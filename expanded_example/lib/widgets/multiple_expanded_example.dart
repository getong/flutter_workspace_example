import 'package:flutter/material.dart';

/// Demonstrates multiple Expanded widgets with different flex values
/// flex determines the proportion of space each Expanded widget gets
class MultipleExpandedExample extends StatelessWidget {
  const MultipleExpandedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          // flex: 1 (takes 1/6 of available space)
          Expanded(
            flex: 1,
            child: ColoredBox(
              color: Colors.red,
              child: Center(
                child: Text('flex: 1', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          // flex: 2 (takes 2/6 of available space)
          Expanded(
            flex: 2,
            child: ColoredBox(
              color: Colors.blue,
              child: Center(
                child: Text('flex: 2', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          // flex: 3 (takes 3/6 of available space)
          Expanded(
            flex: 3,
            child: ColoredBox(
              color: Colors.green,
              child: Center(
                child: Text('flex: 3', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
