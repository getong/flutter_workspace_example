import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ColumnAlignmentPage extends StatelessWidget {
  const ColumnAlignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column Alignment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _columnBlock(
              label: 'crossAxisAlignment.start',
              alignment: CrossAxisAlignment.start,
            ),
            const SizedBox(height: 16),
            _columnBlock(
              label: 'crossAxisAlignment.center',
              alignment: CrossAxisAlignment.center,
            ),
            const SizedBox(height: 16),
            _columnBlock(
              label: 'crossAxisAlignment.end',
              alignment: CrossAxisAlignment.end,
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

  Widget _columnBlock({
    required String label,
    required CrossAxisAlignment alignment,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Column(
                crossAxisAlignment: alignment,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.circle, size: 16),
                  SizedBox(height: 8),
                  Icon(Icons.circle, size: 24),
                  SizedBox(height: 8),
                  Icon(Icons.circle, size: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
