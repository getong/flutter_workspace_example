import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StackAlignmentPage extends StatelessWidget {
  const StackAlignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack Alignment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _alignmentBlock(
              label: 'Alignment.topLeft',
              alignment: Alignment.topLeft,
            ),
            const SizedBox(height: 16),
            _alignmentBlock(
              label: 'Alignment.center',
              alignment: Alignment.center,
            ),
            const SizedBox(height: 16),
            _alignmentBlock(
              label: 'Alignment.bottomRight',
              alignment: Alignment.bottomRight,
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

  Widget _alignmentBlock({
    required String label,
    required Alignment alignment,
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
              child: Stack(
                alignment: alignment,
                children: <Widget>[
                  _square(98, Colors.teal.shade200),
                  _square(62, Colors.teal.shade400),
                  _square(28, Colors.teal.shade700),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _square(double size, Color color) {
    return Container(width: size, height: size, color: color);
  }
}
