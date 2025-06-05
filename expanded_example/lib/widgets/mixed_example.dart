import 'package:flutter/material.dart';

/// Shows mixing Expanded widgets with fixed-size widgets
class MixedExample extends StatelessWidget {
  const MixedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          // Fixed header
          ColoredBox(
            color: Colors.indigo,
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Header (Fixed 40px)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // Expanded content area
          Expanded(
            child: Row(
              children: [
                // Fixed sidebar
                ColoredBox(
                  color: Colors.deepOrange,
                  child: SizedBox(
                    width: 100,
                    height: double.infinity,
                    child: Center(
                      child: Text(
                        'Sidebar\n(Fixed 100px)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // Main content (expanded)
                Expanded(
                  child: ColoredBox(
                    color: Colors.lightBlue,
                    child: Center(
                      child: Text(
                        'Main Content\n(Expanded)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Fixed footer
          ColoredBox(
            color: Colors.grey,
            child: SizedBox(
              height: 30,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Footer (Fixed 30px)',
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
