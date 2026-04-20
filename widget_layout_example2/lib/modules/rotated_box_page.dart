import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RotatedBoxExamplePage extends StatelessWidget {
  const RotatedBoxExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RotatedBox Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'RotatedBox rotates a child in quarter turns during layout, unlike Transform.rotate which only affects painting.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _ExampleCard(
              title: 'Quarter Turns',
              description:
                  'RotatedBox is ideal for vertical labels, sideways tabs, or indicators aligned to the layout grid.',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _RotatedTag(quarterTurns: 0, label: '0 turns'),
                  _RotatedTag(quarterTurns: 1, label: '1 turn'),
                  _RotatedTag(quarterTurns: 2, label: '2 turns'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Typical Use Case',
              description:
                  'This kind of rotated label is common in dashboards, timelines, and chart-side annotations.',
              child: Row(
                children: <Widget>[
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'TREND',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'The label takes part in layout with its rotated dimensions, which makes alignment more predictable than a pure paint transform.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _RotatedTag extends StatelessWidget {
  const _RotatedTag({required this.quarterTurns, required this.label});

  final int quarterTurns;
  final String label;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
