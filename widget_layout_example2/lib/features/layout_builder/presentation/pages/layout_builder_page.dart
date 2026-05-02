import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.layoutBuilder)
class LayoutBuilderExamplePage extends StatelessWidget {
  const LayoutBuilderExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LayoutBuilder Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'LayoutBuilder lets you build different widget trees based on the constraints from the parent. It is useful when a reusable widget needs to react to local width or height, not only the full screen size.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _ExampleCard(
              title: 'Responsive Dashboard Layout',
              description:
                  'This preview switches between stacked and split layouts depending on how much width the parent gives it.',
              api: 'Uses: LayoutBuilder + BoxConstraints.maxWidth',
              child: SizedBox(
                height: 260,
                child: _ResponsiveDashboardPreview(),
              ),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Constraint Breakpoints',
              description:
                  'A widget can define its own compact, cozy, and expanded breakpoints without depending on global MediaQuery values.',
              api: 'Uses: maxWidth thresholds inside a reusable child',
              child: SizedBox(
                height: 160,
                child: _ConstraintBreakpointPreview(),
              ),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Adaptive Action Row',
              description:
                  'Buttons can switch from a horizontal toolbar to a vertical stack when the parent becomes narrow.',
              api: 'Uses: local width to choose Row vs Column',
              child: SizedBox(height: 172, child: _AdaptiveActionRowPreview()),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Height-Aware Summary',
              description:
                  'LayoutBuilder can also react to available height when a panel is embedded in cards, sheets, or split views.',
              api: 'Uses: BoxConstraints.maxHeight',
              child: SizedBox(height: 180, child: _HeightAwareSummaryPreview()),
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

class _ResponsiveDashboardPreview extends StatelessWidget {
  const _ResponsiveDashboardPreview();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 420;
        final List<Widget> panels = <Widget>[
          const _DashboardPanel(color: Colors.indigo, label: 'Hero summary'),
          const _DashboardPanel(color: Colors.teal, label: 'Stats block'),
          const _DashboardPanel(color: Colors.orange, label: 'Action tray'),
        ];

        if (compact) {
          return Column(
            children: panels
                .asMap()
                .entries
                .map(
                  (MapEntry<int, Widget> entry) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: entry.key == panels.length - 1 ? 0 : 12,
                      ),
                      child: entry.value,
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: <Widget>[
            Expanded(flex: 2, child: panels[0]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(child: panels[1]),
                  const SizedBox(height: 12),
                  Expanded(child: panels[2]),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ConstraintBreakpointPreview extends StatelessWidget {
  const _ConstraintBreakpointPreview();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Expanded(child: _BreakpointCard(width: 180)),
        SizedBox(width: 12),
        Expanded(child: _BreakpointCard(width: 280)),
        SizedBox(width: 12),
        Expanded(child: _BreakpointCard(width: 420)),
      ],
    );
  }
}

class _BreakpointCard extends StatelessWidget {
  const _BreakpointCard({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final (String label, Color color) mode =
              switch (constraints.maxWidth) {
                < 120 => ('Compact', Colors.redAccent),
                < 180 => ('Cozy', Colors.deepOrange),
                _ => ('Expanded', Colors.green),
              };

          return Container(
            decoration: BoxDecoration(
              color: mode.$2.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: mode.$2.withValues(alpha: 0.35)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  mode.$1,
                  style: TextStyle(
                    color: mode.$2,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'maxWidth: ${constraints.maxWidth.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AdaptiveActionRowPreview extends StatelessWidget {
  const _AdaptiveActionRowPreview();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stacked = constraints.maxWidth < 430;

        final List<Widget> actions = <Widget>[
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined),
            label: const Text('Export'),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.schedule_outlined),
            label: const Text('Schedule'),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
            label: const Text('Share'),
          ),
        ];

        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: actions
                .map(
                  (Widget action) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: action,
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: actions
              .asMap()
              .entries
              .map(
                (MapEntry<int, Widget> entry) => Padding(
                  padding: EdgeInsets.only(right: entry.key == 2 ? 0 : 12),
                  child: entry.value,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _HeightAwareSummaryPreview extends StatelessWidget {
  const _HeightAwareSummaryPreview();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxHeight < 140;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[Colors.blueGrey.shade50, Colors.blue.shade50],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(16),
          child: compact
              ? const Row(
                  children: <Widget>[
                    Icon(Icons.insights_rounded, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Short mode: revenue up 12%, retention stable.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Icon(Icons.insights_rounded, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          'Performance Summary',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const <Widget>[
                        _MiniMetric(label: 'Revenue', value: '+12%'),
                        _MiniMetric(label: 'Retention', value: '94%'),
                        _MiniMetric(label: 'Tickets', value: '28'),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _DashboardPanel extends StatelessWidget {
  const _DashboardPanel({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
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
