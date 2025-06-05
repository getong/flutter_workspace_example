import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flexible Widget Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FlexibleExamplePage(title: 'Flexible Widget Examples'),
    );
  }
}

class FlexibleExamplePage extends StatelessWidget {
  const FlexibleExamplePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row Examples
            const Text(
              'Row Examples:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Equal flex values
            const Text('Equal Flex (1:1:1):'),
            const SizedBox(height: 8),
            Container(
              height: 60,
              decoration: BoxDecoration(border: Border.all()),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.red[300],
                      child: const Center(child: Text('Flex: 1')),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.green[300],
                      child: const Center(child: Text('Flex: 1')),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.blue[300],
                      child: const Center(child: Text('Flex: 1')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Different flex values
            const Text('Different Flex (1:2:3):'),
            const SizedBox(height: 8),
            Container(
              height: 60,
              decoration: BoxDecoration(border: Border.all()),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.red[300],
                      child: const Center(child: Text('Flex: 1')),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      color: Colors.green[300],
                      child: const Center(child: Text('Flex: 2')),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      color: Colors.blue[300],
                      child: const Center(child: Text('Flex: 3')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Column Examples
            const Text(
              'Column Examples:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const Text('Equal Flex Column (1:1:1):'),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all()),
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      color: Colors.orange[300],
                      child: const Center(child: Text('Flex: 1')),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      color: Colors.purple[300],
                      child: const Center(child: Text('Flex: 1')),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      color: Colors.cyan[300],
                      child: const Center(child: Text('Flex: 1')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text('Different Flex Column (1:3:2):'),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all()),
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      color: Colors.orange[300],
                      child: const Center(child: Text('Flex: 1')),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      color: Colors.purple[300],
                      child: const Center(child: Text('Flex: 3')),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      color: Colors.cyan[300],
                      child: const Center(child: Text('Flex: 2')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Explanation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How Flexible Works:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Flexible widgets divide available space proportionally',
                  ),
                  Text('• The flex value determines the proportion of space'),
                  Text('• Total space = sum of all flex values'),
                  Text(
                    '• Each widget gets: (its flex / total flex) × available space',
                  ),
                  Text('• Example: flex values 1:2:3 = 1/6, 2/6, 3/6 of space'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
