import 'package:flutter/material.dart';

/// Demonstrates nested Expanded widgets
class NestedExample extends StatelessWidget {
  const NestedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          // Left section with nested column
          Expanded(
            flex: 2,
            child: Column(
              children: [
                ColoredBox(
                  color: Colors.red,
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Top Left',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        'Bottom Left\n(Expanded)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Right section with nested column
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ColoredBox(
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        'Top Right\n(flex: 1)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ColoredBox(
                    color: Colors.purple,
                    child: Center(
                      child: Text(
                        'Bottom Right\n(flex: 2)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
