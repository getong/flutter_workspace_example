import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.expandedVsFlexible)
class ExpandedVsFlexiblePage extends StatelessWidget {
  const ExpandedVsFlexiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expanded vs Flexible Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Expanded and Flexible are both used inside Row, Column, and Flex. Expanded forces its child to fill the remaining space. Flexible lets its child participate in flex layout without always stretching to all available space.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Quick Rule',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Use Expanded when the child should definitely take the leftover space.',
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Use Flexible when the child may use remaining space but can still stay smaller with FlexFit.loose.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Expanded Focus',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'In this row, the center panel is forced to fill all remaining width between two fixed side panels.',
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 150, child: _ExpandedPreview()),
                    const SizedBox(height: 16),
                    Text(
                      'Typical use cases: search bars, primary content panels, timeline bodies, chat input rows, and any area that should expand to consume the leftover space.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Flexible Focus',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Here the flexible children join the row layout, but they are allowed to keep a smaller natural width instead of being forced to stretch all the way.',
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 150, child: _FlexiblePreview()),
                    const SizedBox(height: 16),
                    Text(
                      'Typical use cases: tags, toolbar text, chips, labels beside icons, and layouts where a child should adapt without being forced to fill every pixel.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Difference Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _DifferenceRow(
                      label: 'Default fit',
                      expanded:
                          'Always behaves like Flexible(fit: FlexFit.tight)',
                      flexible:
                          'Can be tight or loose, depending on fit parameter',
                    ),
                    const SizedBox(height: 12),
                    const _DifferenceRow(
                      label: 'Space behavior',
                      expanded:
                          'Forces the child to fill the allocated remaining space',
                      flexible:
                          'Allows the child to be smaller than the allocated space',
                    ),
                    const SizedBox(height: 12),
                    const _DifferenceRow(
                      label: 'Best for',
                      expanded:
                          'Main content that should stretch and occupy leftover room',
                      flexible:
                          'Content that should adapt but keep natural size when possible',
                    ),
                    const SizedBox(height: 12),
                    const _DifferenceRow(
                      label: 'Common mistake',
                      expanded:
                          'Using it when a child should stay content-sized',
                      flexible:
                          'Expecting loose fit to automatically fill the row',
                    ),
                  ],
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

class _DifferenceRow extends StatelessWidget {
  const _DifferenceRow({
    required this.label,
    required this.expanded,
    required this.flexible,
  });

  final String label;
  final String expanded;
  final String flexible;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey.shade100),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Expanded',
                        style: TextStyle(
                          color: Colors.indigo.shade800,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(expanded),
                    ],
                  ),
                ),
              ),
              Container(width: 1, color: Colors.blueGrey.shade100),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Flexible',
                        style: TextStyle(
                          color: Colors.teal.shade800,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(flexible),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpandedPreview extends StatelessWidget {
  const _ExpandedPreview();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 72,
            decoration: BoxDecoration(
              color: Colors.indigo.shade400,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(18),
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.menu, color: Colors.white),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Expanded fills remaining width',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Container(
            width: 64,
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(18),
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.tune),
          ),
        ],
      ),
    );
  }
}

class _FlexiblePreview extends StatelessWidget {
  const _FlexiblePreview();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            const CircleAvatar(child: Text('A')),
            const SizedBox(width: 12),
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.teal.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Short label', textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              fit: FlexFit.loose,
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Flexible can stay smaller than the whole remaining area',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
