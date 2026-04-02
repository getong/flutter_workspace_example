import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class MergeSemanticsPage extends StatelessWidget {
  const MergeSemanticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MergeSemantics Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'MergeSemantics combines the semantics of multiple descendant widgets into a single accessibility node. It is useful when separate visual pieces should be announced as one coherent item.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _MergeSemanticsExampleCard(
              title: 'Checkbox Row',
              description:
                  'A checkbox and its label can be merged so assistive technology reads them as one control instead of separate elements.',
              child: MergeSemantics(
                child: Row(
                  children: <Widget>[
                    Checkbox(value: true, onChanged: null),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Receive weekly product updates',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _MergeSemanticsExampleCard(
              title: 'Profile Summary',
              description:
                  'An avatar, title, and subtitle can be merged into one concise accessibility node for simpler navigation.',
              child: MergeSemantics(
                child: Row(
                  children: <Widget>[
                    const CircleAvatar(radius: 24, child: Text('AL')),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            'Alicia Lee',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 4),
                          Text('Operations Manager'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _MergeSemanticsExampleCard(
              title: 'Setting Tile',
              description:
                  'Leading icons, labels, and state text can be merged so the whole tile reads like one setting row.',
              child: MergeSemantics(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.blueGrey.shade100),
                  ),
                  child: const Row(
                    children: <Widget>[
                      Icon(Icons.notifications_active, color: Colors.blue),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Notifications',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text('Enabled'),
                    ],
                  ),
                ),
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

class _MergeSemanticsExampleCard extends StatelessWidget {
  const _MergeSemanticsExampleCard({
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
