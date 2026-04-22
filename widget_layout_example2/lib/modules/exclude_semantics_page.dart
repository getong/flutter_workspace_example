import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.excludeSemantics)
class ExcludeSemanticsPage extends StatelessWidget {
  const ExcludeSemanticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ExcludeSemantics Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'ExcludeSemantics removes semantics information from its subtree. It is useful when visible text or icons would otherwise be announced redundantly by assistive technologies.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Text(
              'Tap, long press, or hover a demo to preview the parent semantics label as a tooltip-style overlay.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey.shade700),
            ),
            const SizedBox(height: 20),
            _ExcludeSemanticsExampleCard(
              title: 'Replace Repeated Labels',
              description:
                  'The visible icon and text stay on screen, but ExcludeSemantics lets a parent Semantics widget provide a single cleaner label.',
              api: 'Uses: Semantics(label, hint, button) + ExcludeSemantics',
              child: _ExcludeSemanticsTooltipPreview(
                label: 'Favorite button',
                hint: 'Double tap to mark this item as favorite',
                child: Semantics(
                  label: 'Favorite button',
                  hint: 'Double tap to mark this item as favorite',
                  button: true,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.pink.shade200),
                    ),
                    child: const ExcludeSemantics(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.favorite, color: Colors.pink),
                          SizedBox(width: 8),
                          Text(
                            'Favorite',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExcludeSemanticsExampleCard(
              title: 'Hide Decorative Icon',
              description:
                  'Decorative visuals often do not need to be announced, so ExcludeSemantics keeps the spoken output focused.',
              api: 'Uses: ExcludeSemantics for decorative-only content',
              child: _ExcludeSemanticsTooltipPreview(
                label: 'Verified account',
                child: Row(
                  children: <Widget>[
                    const ExcludeSemantics(
                      child: Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Semantics(
                        label: 'Verified account',
                        child: const Text(
                          'Verified account',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExcludeSemanticsExampleCard(
              title: 'Readable Summary',
              description:
                  'A parent Semantics node can provide a concise summary while the detailed visual row is excluded from accessibility output.',
              api: 'Uses: Semantics(label) wrapping an excluded visual row',
              child: _ExcludeSemanticsTooltipPreview(
                label: 'Order status shipped, expected Tuesday',
                child: Semantics(
                  label: 'Order status shipped, expected Tuesday',
                  child: const ExcludeSemantics(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.local_shipping, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Status: Shipped • Expected Tuesday',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExcludeSemanticsExampleCard(
              title: 'Unread Messages Badge',
              description:
                  'Badge counts are useful visually, but a single parent label can be easier for assistive technology to announce.',
              api: 'Uses: container, label, value + ExcludeSemantics',
              child: _ExcludeSemanticsTooltipPreview(
                label: 'Inbox',
                value: '3 unread messages',
                child: Semantics(
                  container: true,
                  label: 'Inbox',
                  value: '3 unread messages',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: const ExcludeSemantics(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.inbox_rounded, color: Colors.blue),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Inbox',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.blue,
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
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

class _ExcludeSemanticsTooltipPreview extends StatelessWidget {
  const _ExcludeSemanticsTooltipPreview({
    required this.label,
    required this.child,
    this.hint,
    this.value,
  });

  final String label;
  final String? hint;
  final String? value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> tooltipSpans = <InlineSpan>[
      const TextSpan(
        text: 'Label: ',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      TextSpan(text: label),
    ];

    if (value != null) {
      tooltipSpans.addAll(<InlineSpan>[
        const TextSpan(
          text: '\nValue: ',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        TextSpan(text: value),
      ]);
    }

    if (hint != null) {
      tooltipSpans.addAll(<InlineSpan>[
        const TextSpan(
          text: '\nHint: ',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        TextSpan(text: hint),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Tooltip(
          richMessage: TextSpan(
            style: const TextStyle(color: Colors.white, height: 1.4),
            children: tooltipSpans,
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
          'Tap, long press, or hover to preview the parent semantics label.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
        ),
      ],
    );
  }
}

class _ExcludeSemanticsExampleCard extends StatelessWidget {
  const _ExcludeSemanticsExampleCard({
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
