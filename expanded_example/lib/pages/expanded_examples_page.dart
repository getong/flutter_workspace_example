import 'package:flutter/material.dart';
import '../widgets/basic_column_example.dart';
import '../widgets/basic_row_example.dart';
import '../widgets/multiple_expanded_example.dart';
import '../widgets/interactive_example.dart';
import '../widgets/mixed_example.dart';
import '../widgets/nested_example.dart';
import '../docs/expanded_documentation.dart';

/// Main page demonstrating various Expanded widget use cases
///
/// The Expanded widget is used to make a child of a Row, Column, or Flex
/// expand to fill the available space. It's particularly useful for:
/// - Creating responsive layouts
/// - Distributing space proportionally
/// - Making widgets take up remaining space
class ExpandedExamplesPage extends StatefulWidget {
  const ExpandedExamplesPage({super.key});

  @override
  State<ExpandedExamplesPage> createState() => _ExpandedExamplesPageState();
}

class _ExpandedExamplesPageState extends State<ExpandedExamplesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expanded Widget Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'View Documentation',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExpandedDocumentationPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tap the help icon above to view comprehensive documentation',
                        style: TextStyle(color: Colors.blue.shade700),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ExpandedDocumentationPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.book),
                      label: const Text('Docs'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('1. Basic Expanded in Column'),
            const BasicColumnExample(),

            const SizedBox(height: 24),
            _buildSectionTitle('2. Basic Expanded in Row'),
            const BasicRowExample(),

            const SizedBox(height: 24),
            _buildSectionTitle(
              '3. Multiple Expanded with Different Flex Values',
            ),
            const MultipleExpandedExample(),

            const SizedBox(height: 24),
            _buildSectionTitle('4. Interactive Flex Control'),
            const InteractiveExample(),

            const SizedBox(height: 24),
            _buildSectionTitle('5. Mixed Expanded and Fixed Size Widgets'),
            const MixedExample(),

            const SizedBox(height: 24),
            _buildSectionTitle('6. Nested Expanded Widgets'),
            const NestedExample(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
