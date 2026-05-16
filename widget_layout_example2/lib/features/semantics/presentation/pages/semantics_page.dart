import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.semantics)
class SemanticsPage extends StatelessWidget {
  const SemanticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semantics Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Semantics adds accessibility information for screen readers and assistive technologies. It helps describe purpose, state, and actions more clearly.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Text(
              'Tap, long press, or hover a demo to preview its semantics label as a tooltip-style overlay.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey.shade700),
            ),
            const SizedBox(height: 20),
            _SemanticsExampleCard(
              title: 'Labeled Icon',
              description:
                  'A visual icon can expose a clearer spoken label through Semantics.',
              api: 'Uses: label, hint, image',
              child: _SemanticsTooltipPreview(
                label: 'Favorite item',
                hint: 'Marks this item as a favorite',
                child: Center(
                  child: Semantics(
                    label: 'Favorite item',
                    hint: 'Marks this item as a favorite',
                    image: true,
                    child: const Icon(
                      Icons.favorite,
                      size: 48,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SemanticsExampleCard(
              title: 'Button Role',
              description:
                  'Semantics can describe custom UI as a button even when the visual is not a Material button.',
              api: 'Uses: button, enabled, label, hint',
              child: _SemanticsTooltipPreview(
                label: 'Custom checkout button',
                hint: 'Double tap to continue to checkout',
                child: Semantics(
                  button: true,
                  enabled: true,
                  label: 'Custom checkout button',
                  hint: 'Double tap to continue to checkout',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Continue To Checkout',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SemanticsExampleCard(
              title: 'Value And State',
              description:
                  'You can expose current values and dynamic state for richer accessibility feedback.',
              api:
                  'Uses: label, value, increasedValue, decreasedValue, liveRegion',
              child: _SemanticsTooltipPreview(
                label: 'Volume control',
                value: '75 percent',
                hint: 'Increases to 80 percent or decreases to 70 percent',
                child: Semantics(
                  label: 'Volume control',
                  value: '75 percent',
                  increasedValue: '80 percent',
                  decreasedValue: '70 percent',
                  liveRegion: true,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.volume_up, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.75,
                          minHeight: 12,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '75%',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SemanticsExampleCard(
              title: 'Toggleable Setting',
              description:
                  'A custom setting row can communicate a toggled state even when the visual layout is not a stock ListTile.',
              api: 'Uses: container, toggled, enabled, label, hint',
              child: _SemanticsTooltipPreview(
                label: 'Airplane mode',
                value: 'On',
                hint: 'Double tap to turn airplane mode off',
                child: Semantics(
                  container: true,
                  toggled: true,
                  enabled: true,
                  label: 'Airplane mode',
                  hint: 'Double tap to turn airplane mode off',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.indigo.shade100),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.flight_takeoff, color: Colors.indigo),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Airplane Mode',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Switch.adaptive(value: true, onChanged: (_) {}),
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

class _SemanticsTooltipPreview extends StatelessWidget {
  const _SemanticsTooltipPreview({
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
          'Tap, long press, or hover to preview the semantics label.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
        ),
      ],
    );
  }
}

class _SemanticsExampleCard extends StatelessWidget {
  const _SemanticsExampleCard({
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
