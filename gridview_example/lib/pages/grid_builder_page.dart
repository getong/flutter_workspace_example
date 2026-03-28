import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GridBuilderPage extends StatelessWidget {
  const GridBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid Builder')),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double width = constraints.maxWidth;
          final int crossAxisCount = width >= 1000
              ? 6
              : width >= 760
              ? 5
              : width >= 520
              ? 4
              : 3;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: 30,
            itemBuilder: (BuildContext context, int index) {
              final MaterialColor color =
                  Colors.primaries[index % Colors.primaries.length];
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Card $index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          );
        },
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
}
