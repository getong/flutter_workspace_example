import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GesturedetectorPage extends StatelessWidget {
  const GesturedetectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GestureDetector')),
      body: SelectionArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Text was tapped.')));
          },
          child: const Center(child: Text('This text is tappable')),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}
