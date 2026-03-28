import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RowAlignmentPage extends StatelessWidget {
  const RowAlignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row Alignment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _rowBlock(
              label: 'MainAxisAlignment.start',
              alignment: MainAxisAlignment.start,
            ),
            const SizedBox(height: 16),
            _rowBlock(
              label: 'MainAxisAlignment.center',
              alignment: MainAxisAlignment.center,
            ),
            const SizedBox(height: 16),
            _rowBlock(
              label: 'MainAxisAlignment.end',
              alignment: MainAxisAlignment.end,
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

  Widget _rowBlock({
    required String label,
    required MainAxisAlignment alignment,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 70,
          color: Colors.grey.shade200,
          child: Row(
            mainAxisAlignment: alignment,
            children: const <Widget>[
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 8),
              Icon(Icons.favorite, color: Colors.pink),
              SizedBox(width: 8),
              Icon(Icons.bolt, color: Colors.deepPurple),
            ],
          ),
        ),
      ],
    );
  }
}
