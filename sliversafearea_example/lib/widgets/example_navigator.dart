import 'package:flutter/material.dart';
import '../examples/basic_comparison_example.dart';
import '../examples/advanced_safe_area_example.dart';
import '../examples/custom_safe_area_example.dart';

class ExampleNavigator extends StatefulWidget {
  const ExampleNavigator({super.key});

  @override
  State<ExampleNavigator> createState() => _ExampleNavigatorState();
}

class _ExampleNavigatorState extends State<ExampleNavigator> {
  int currentIndex = 0;

  final List<Widget> examples = [
    const BasicComparisonExample(),
    const AdvancedSafeAreaExample(),
    const CustomSafeAreaExample(),
  ];

  final List<String> titles = [
    'Basic Comparison',
    'Advanced Features',
    'Custom Configuration',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: examples[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.compare),
            label: 'Basic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.featured_play_list),
            label: 'Advanced',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Custom',
          ),
        ],
      ),
    );
  }
}
