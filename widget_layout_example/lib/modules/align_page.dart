import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlignPage extends StatelessWidget {
  const AlignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Align Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Align positions a single child inside itself.',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'This module shows common `Align` patterns: moving a child with '
              '`Alignment`, reacting to text direction with '
              '`AlignmentDirectional`, placing content with `FractionalOffset`, '
              'and shrinking the widget with `widthFactor` and `heightFactor`.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            const _AlignExampleCard(
              title: 'Alignment.topLeft',
              description:
                  'Place the child in the upper-left corner of the available space.',
              alignment: Alignment.topLeft,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const _AlignExampleCard(
              title: 'Alignment.centerRight',
              description:
                  'Keep the child vertically centered while pushing it to the right edge.',
              alignment: Alignment.centerRight,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const _AlignExampleCard(
              title: 'Alignment.bottomCenter',
              description:
                  'Useful when a badge or CTA should sit at the bottom center.',
              alignment: Alignment.bottomCenter,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const _AlignDirectionalExampleCard(),
            const SizedBox(height: 16),
            const _FractionalOffsetExampleCard(),
            const SizedBox(height: 16),
            const _WidthHeightFactorExampleCard(),
          ],
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

class _AlignExampleCard extends StatelessWidget {
  const _AlignExampleCard({
    required this.title,
    required this.description,
    required this.alignment,
    required this.color,
  });

  final String title;
  final String description;
  final Alignment alignment;
  final Color color;

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
            Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: color.withValues(alpha: 0.12),
              ),
              child: Align(
                alignment: alignment,
                child: Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Child',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'alignment: $alignment',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _AlignDirectionalExampleCard extends StatelessWidget {
  const _AlignDirectionalExampleCard();

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
              'AlignmentDirectional',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              '`AlignmentDirectional.centerStart` respects text direction, so '
              'it points to the leading edge in both LTR and RTL layouts.',
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.purple.withValues(alpha: 0.12),
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  width: 180,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.info_outline, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Leading aligned message',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'alignment: ${AlignmentDirectional.centerStart}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _FractionalOffsetExampleCard extends StatelessWidget {
  const _FractionalOffsetExampleCard();

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
              'FractionalOffset',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              '`FractionalOffset(0.2, 0.8)` positions the child at 20% from '
              'the left and 80% from the top of the parent.',
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.teal.withValues(alpha: 0.18),
                    Colors.cyan.withValues(alpha: 0.08),
                  ],
                ),
              ),
              child: Align(
                alignment: const FractionalOffset(0.2, 0.8),
                child: Container(
                  width: 110,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '20%, 80%',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'alignment: ${const FractionalOffset(0.2, 0.8)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _WidthHeightFactorExampleCard extends StatelessWidget {
  const _WidthHeightFactorExampleCard();

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
              'widthFactor and heightFactor',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'When factors are set, `Align` sizes itself relative to its '
              'child instead of expanding to fill all available space.',
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.red.withValues(alpha: 0.1),
              ),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.35)),
                ),
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    widthFactor: 2.4,
                    heightFactor: 1.8,
                    child: Container(
                      width: 72,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Box',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'widthFactor: 2.4, heightFactor: 1.8',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
