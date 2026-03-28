import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RowBasicsPage extends StatelessWidget {
  const RowBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row Basics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Example 1: spaceEvenly + fixed boxes'),
            const SizedBox(height: 10),
            Container(
              color: Colors.teal.shade50,
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _box('A', Colors.redAccent),
                  _box('B', Colors.green),
                  _box('C', Colors.blue),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Example 2: baseline alignment'),
            const SizedBox(height: 10),
            Container(
              color: Colors.orange.shade50,
              height: 120,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text('Row', style: TextStyle(fontSize: 28)),
                  SizedBox(width: 12),
                  Text('with', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 12),
                  Text('Baseline', style: TextStyle(fontSize: 36)),
                ],
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        TextButton.icon(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.home),
          label: const Text('Back Home'),
        ),
      ],
    );
  }

  Widget _box(String text, Color color) {
    return Container(
      width: 70,
      height: 70,
      color: color,
      alignment: Alignment.center,
      child: Text(
        text,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
