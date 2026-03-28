import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GridExtentPage extends StatelessWidget {
  const GridExtentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid Extent')),
      body: GridView.extent(
        padding: const EdgeInsets.all(16),
        maxCrossAxisExtent: 140,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: List<Widget>.generate(24, (int index) {
          final MaterialAccentColor base =
              Colors.accents[index % Colors.accents.length];
          return Container(
            decoration: BoxDecoration(
              color: base.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Tile ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  'maxCrossAxisExtent: 140',
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 11),
                ),
              ],
            ),
          );
        }),
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
