import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ColumnBasicsPage extends StatelessWidget {
  const ColumnBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column Basics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Example 1: vertical stack'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 220,
              color: Colors.green.shade50,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _panel('Header', Colors.green.shade200),
                  const SizedBox(height: 8),
                  _panel('Body', Colors.green.shade300),
                  const SizedBox(height: 8),
                  _panel('Footer', Colors.green.shade400),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Example 2: mainAxisSize.min'),
            const SizedBox(height: 10),
            Center(
              child: Container(
                color: Colors.blue.shade50,
                padding: const EdgeInsets.all(12),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Compact'),
                    SizedBox(height: 4),
                    Text('Column'),
                    SizedBox(height: 4),
                    Text('Card'),
                  ],
                ),
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

  Widget _panel(String label, Color color) {
    return Expanded(
      child: Container(
        color: color,
        alignment: Alignment.center,
        child: Text(label),
      ),
    );
  }
}
