import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'grid_catalog.dart';

class GridDetailPage extends StatelessWidget {
  const GridDetailPage({required this.page, super.key});

  final GridPageSpec page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(page.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              'Dynamic route: /grids/${page.slug}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: page.color.withAlpha(31),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: page.color, width: 2),
                ),
                child: _buildGridPreview(page.slug, page.kind),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(page.message)));
        },
        child: Icon(page.icon),
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

  Widget _buildGridPreview(String slug, GridKind kind) {
    if (kind == GridKind.fixedCount) {
      final List<Color> palette = slug == 'photo-board'
          ? <Color>[
              Colors.amber,
              Colors.deepOrange,
              Colors.lightBlue,
              Colors.green,
              Colors.purple,
              Colors.pink,
            ]
          : <Color>[
              Colors.blueGrey,
              Colors.teal,
              Colors.indigo,
              Colors.cyan,
              Colors.deepPurple,
              Colors.orange,
            ];

      return GridView.builder(
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          final Color color = palette[index % palette.length];
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withAlpha(210),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '#${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      );
    }

    return GridView.extent(
      maxCrossAxisExtent: 150,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: List<Widget>.generate(14, (int index) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.indigo[(index % 8 + 1) * 100]!,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                slug == 'analytics-overview'
                    ? 'KPI ${index + 1}'
                    : 'Tool ${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Text(
                'GridView.extent',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        );
      }),
    );
  }
}
