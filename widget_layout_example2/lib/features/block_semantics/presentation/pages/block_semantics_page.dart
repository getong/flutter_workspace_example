import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.blockSemantics)
class BlockSemanticsPage extends StatelessWidget {
  const BlockSemanticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BlockSemantics Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'BlockSemantics prevents earlier painted widgets from contributing semantics when a later widget should take over accessibility focus, such as a modal, loading overlay, or temporary sheet.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Text(
              'Tap, long press, or hover a demo to preview the active semantics label as a tooltip-style overlay.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey.shade700),
            ),
            const SizedBox(height: 20),
            _BlockSemanticsExampleCard(
              title: 'Modal Confirmation Overlay',
              description:
                  'The confirmation panel visually sits above the page and blocks the page content underneath from the semantics tree.',
              api: 'Uses: Stack + Positioned.fill + BlockSemantics',
              child: _BlockSemanticsTooltipPreview(
                label: 'Discard changes dialog',
                hint: 'Review the dialog actions instead of the page behind it',
                child: SizedBox(
                  height: 220,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Profile Details',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            const Text('Email notifications enabled'),
                            const Spacer(),
                            Row(
                              children: <Widget>[
                                OutlinedButton(
                                  onPressed: () {},
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 12),
                                FilledButton(
                                  onPressed: () {},
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: BlockSemantics(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.28),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: Semantics(
                                container: true,
                                label: 'Discard changes dialog',
                                hint:
                                    'Review the dialog actions instead of the page behind it',
                                child: Container(
                                  width: 240,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Discard changes?',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Your edits are not saved yet. The dialog should be the active accessible surface.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _BlockSemanticsExampleCard(
              title: 'Loading Shield',
              description:
                  'A temporary progress overlay can hide the form beneath it from assistive technologies while work is in progress.',
              api: 'Uses: BlockSemantics + Semantics(liveRegion, label, value)',
              child: _BlockSemanticsTooltipPreview(
                label: 'Uploading expense report',
                value: 'Step 2 of 3',
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green.shade100),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Expense Form',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 12),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Amount',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 12),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: BlockSemantics(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.82),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: Semantics(
                                container: true,
                                liveRegion: true,
                                label: 'Uploading expense report',
                                value: 'Step 2 of 3',
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text(
                                      'Uploading receipt...',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
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
              ),
            ),
            const SizedBox(height: 16),
            _BlockSemanticsExampleCard(
              title: 'Bottom Sheet Preview',
              description:
                  'A bottom sheet should usually become the active accessible region instead of leaving the page behind reachable.',
              api: 'Uses: BlockSemantics over a sheet-style overlay',
              child: _BlockSemanticsTooltipPreview(
                label: 'Seat upgrade offer',
                hint:
                    'Business class upgrade for \$120. The sheet should take priority in the semantics tree.',
                child: SizedBox(
                  height: 220,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Colors.orange.shade50,
                              Colors.deepOrange.shade50,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Travel Dashboard',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 8),
                            Text('Upcoming flight: Shanghai to Tokyo'),
                            SizedBox(height: 8),
                            Text('Seat: 12A'),
                            Spacer(),
                            Text(
                              'The page content remains visible underneath.',
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: BlockSemantics(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      blurRadius: 18,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Seat Upgrade Offer',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Business class upgrade for \$120. The sheet should take priority in the semantics tree.',
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
              ),
            ),
            const SizedBox(height: 16),
            _BlockSemanticsExampleCard(
              title: 'Decorative Overlay Opt-Out',
              description:
                  'When an overlay is only decorative, setting blocking to false avoids hiding useful semantics behind it.',
              api: 'Uses: BlockSemantics(blocking: false)',
              child: _BlockSemanticsTooltipPreview(
                label: 'Account summary',
                value: 'Balance \$3,240.50',
                hint:
                    'The decorative overlay does not block the content semantics',
                child: SizedBox(
                  height: 140,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.purple.shade100),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Account Summary',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 8),
                            Text('Balance: \$3,240.50'),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: BlockSemantics(
                            blocking: false,
                            child: const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.transparent,
                                    Colors.white70,
                                  ],
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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

class _BlockSemanticsTooltipPreview extends StatelessWidget {
  const _BlockSemanticsTooltipPreview({
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
        text: 'Active label: ',
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
          'Tap, long press, or hover to preview the active semantics output.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
        ),
      ],
    );
  }
}

class _BlockSemanticsExampleCard extends StatelessWidget {
  const _BlockSemanticsExampleCard({
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
