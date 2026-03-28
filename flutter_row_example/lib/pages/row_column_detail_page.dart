import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'row_column_catalog.dart';

class RowColumnDetailPage extends StatelessWidget {
  const RowColumnDetailPage({required this.page, super.key});

  final LayoutPageSpec page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(page.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              'Dynamic route: /layouts/${page.slug}',
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
                child: page.kind == LayoutKind.row
                    ? _buildRowPreview(page.slug)
                    : _buildColumnPreview(page.slug),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(page.message)),
          );
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

  Widget _buildRowPreview(String slug) {
    if (slug == 'row-rainbow') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _tile(Colors.red, 50),
          _tile(Colors.orange, 70),
          _tile(Colors.green, 90),
          _tile(Colors.blue, 110),
        ],
      );
    }

    return Row(
      children: <Widget>[
        _chip('Create', Icons.add),
        const SizedBox(width: 8),
        _chip('Share', Icons.share),
        const SizedBox(width: 8),
        _chip('Archive', Icons.archive_outlined),
        const Spacer(),
        const Icon(Icons.more_horiz),
      ],
    );
  }

  Widget _buildColumnPreview(String slug) {
    if (slug == 'column-cards') {
      return Column(
        children: <Widget>[
          _infoCard('Planning', '3 tasks due today', Colors.deepPurple),
          const SizedBox(height: 10),
          _infoCard('Review', '2 pull requests waiting', Colors.indigo),
          const SizedBox(height: 10),
          _infoCard('Deploy', 'Staging deployment green', Colors.teal),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.purple.shade100,
            alignment: Alignment.center,
            child: const Text('Top Overview'),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            color: Colors.purple.shade200,
            alignment: Alignment.center,
            child: const Text('Middle KPI'),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.purple.shade300,
            alignment: Alignment.center,
            child: const Text('Bottom Activity Feed'),
          ),
        ),
      ],
    );
  }

  Widget _tile(Color color, double height) {
    return Container(
      width: 52,
      height: height,
      color: color,
    );
  }

  Widget _chip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String subtitle, MaterialColor color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}
