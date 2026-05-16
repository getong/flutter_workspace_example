import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.mergeSemantics)
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
            Text(
              'Tap, long press, or hover a demo to preview the merged announcement as a tooltip-style overlay.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey.shade700),
            ),
            const SizedBox(height: 20),
            _MergeSemanticsExampleCard(
              title: 'Checkbox Row',
              description:
                  'A checkbox and its label can be merged so assistive technology reads them as one control instead of separate elements.',
              api: 'Uses: MergeSemantics + Checkbox + Text',
              child: _MergedSemanticsTooltipPreview(
                message: 'Receive weekly product updates, checked',
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
            ),
            const SizedBox(height: 16),
            _MergeSemanticsExampleCard(
              title: 'Profile Summary',
              description:
                  'An avatar, title, and subtitle can be merged into one concise accessibility node for simpler navigation.',
              api: 'Uses: MergeSemantics + CircleAvatar + Column',
              child: _MergedSemanticsTooltipPreview(
                message: 'Alicia Lee, Operations Manager',
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
            ),
            const SizedBox(height: 16),
            _MergeSemanticsExampleCard(
              title: 'Setting Tile',
              description:
                  'Leading icons, labels, and state text can be merged so the whole tile reads like one setting row.',
              api: 'Uses: MergeSemantics + Row + state text',
              child: _MergedSemanticsTooltipPreview(
                message: 'Notifications, enabled',
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
            ),
            const SizedBox(height: 16),
            _MergeSemanticsExampleCard(
              title: 'Rating Summary',
              description:
                  'A star icon, score, and review count can be merged so the summary is announced as one compact item.',
              api: 'Uses: MergeSemantics + Icon + Rich summary text',
              child: _MergedSemanticsTooltipPreview(
                message: 'Rated 4.8 out of 5, 248 reviews',
                child: MergeSemantics(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: const Row(
                      children: <Widget>[
                        Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                        SizedBox(width: 10),
                        Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('(248 reviews)'),
                      ],
                    ),
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

class _MergedSemanticsTooltipPreview extends StatelessWidget {
  const _MergedSemanticsTooltipPreview({
    required this.message,
    required this.child,
  });

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Tooltip(
          richMessage: TextSpan(
            style: const TextStyle(color: Colors.white, height: 1.4),
            children: <InlineSpan>[
              const TextSpan(
                text: 'Merged announcement: ',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(text: message),
            ],
          ),
          triggerMode: TooltipTriggerMode.tap,
          waitDuration: Duration.zero,
          showDuration: const Duration(seconds: 3),
          preferBelow: false,
          verticalOffset: 20,
          excludeFromSemantics: true,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        ),
        const SizedBox(height: 8),
        Text(
          'Tap, long press, or hover to preview the merged semantics output.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
        ),
      ],
    );
  }
}

class _MergeSemanticsExampleCard extends StatelessWidget {
  const _MergeSemanticsExampleCard({
    required this.title,
    required this.description,
    required this.api,
    required this.child,
  });

  final String title;
  final String description;
  final String api;
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
            const SizedBox(height: 12),
            Text(
              api,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
