import 'package:flutter/material.dart';

/// Demonstrates basic Expanded usage in a Column
/// The Expanded widget will take up all available vertical space
class BasicColumnExample extends StatelessWidget {
  const BasicColumnExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          // Fixed height container
          ColoredBox(
            color: Colors.red,
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Fixed Height (50px)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // Expanded takes remaining space
          Expanded(
            child: ColoredBox(
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Expanded (fills remaining space)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // Another fixed height container
          ColoredBox(
            color: Colors.green,
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Fixed Height (40px)',
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
