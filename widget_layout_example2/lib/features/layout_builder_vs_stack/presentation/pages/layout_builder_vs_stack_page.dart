import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.layoutBuilderVsStack)
class LayoutBuilderVsStackPage extends StatelessWidget {
  const LayoutBuilderVsStackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LayoutBuilder vs Stack Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'LayoutBuilder and Stack are both layout widgets, but they solve different problems. LayoutBuilder reacts to parent constraints and can switch widget structure. Stack layers children on top of each other in the same visual area.',
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
                      'Use LayoutBuilder when you need to decide between different layouts based on available width or height.',
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Use Stack when you need children to overlap, float, or be anchored on top of the same area.',
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
                      'LayoutBuilder Focus',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This example changes between a vertical and horizontal arrangement depending on the width given by the parent.',
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 210, child: _LayoutBuilderPreview()),
                    const SizedBox(height: 16),
                    Text(
                      'Typical use cases: responsive cards, adaptive action rows, breakpoint-based panels, and reusable widgets that must respond to local constraints.',
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
                      'Stack Focus',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This example keeps one shared canvas and layers a background, label, action button, and badge on top of each other.',
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 210, child: _StackPreview()),
                    const SizedBox(height: 16),
                    Text(
                      'Typical use cases: hero banners, profile badges, floating controls, overlays, notification dots, and image cards with labels on top.',
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
                      label: 'Main question',
                      layoutBuilder: 'How much space did the parent give me?',
                      stack: 'Which children should overlap in the same area?',
                    ),
                    const SizedBox(height: 12),
                    const _DifferenceRow(
                      label: 'Core behavior',
                      layoutBuilder:
                          'Build different widget trees from BoxConstraints',
                      stack: 'Paint and position multiple children in layers',
                    ),
                    const SizedBox(height: 12),
                    const _DifferenceRow(
                      label: 'Best at',
                      layoutBuilder: 'Responsive or adaptive structure changes',
                      stack:
                          'Overlays, badges, floating actions, and layered visuals',
                    ),
                    const SizedBox(height: 12),
                    const _DifferenceRow(
                      label: 'Usually avoid when',
                      layoutBuilder:
                          'You only need simple overlap or absolute placement',
                      stack:
                          'You actually need breakpoint logic or constraint-based branching',
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
    required this.layoutBuilder,
    required this.stack,
  });

  final String label;
  final String layoutBuilder;
  final String stack;

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
                        'LayoutBuilder',
                        style: TextStyle(
                          color: Colors.teal.shade800,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(layoutBuilder),
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
                        'Stack',
                        style: TextStyle(
                          color: Colors.indigo.shade800,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(stack),
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

class _LayoutBuilderPreview extends StatelessWidget {
  const _LayoutBuilderPreview();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Expanded(child: _AdaptivePanel(width: 180)),
        SizedBox(width: 12),
        Expanded(child: _AdaptivePanel(width: 320)),
      ],
    );
  }
}

class _AdaptivePanel extends StatelessWidget {
  const _AdaptivePanel({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.teal.shade100),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool compact = constraints.maxWidth < 140;

            final Widget hero = Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.teal.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                compact ? 'Compact' : 'Wide',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );

            final Widget stats = Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                'maxWidth: ${constraints.maxWidth.toStringAsFixed(0)}',
              ),
            );

            final Widget footer = Container(
              height: 36,
              decoration: BoxDecoration(
                color: Colors.teal.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Text('Responsive branch'),
            );

            return Padding(
              padding: const EdgeInsets.all(14),
              child: compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        hero,
                        const SizedBox(height: 10),
                        stats,
                        const SizedBox(height: 10),
                        footer,
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        Expanded(child: hero),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              stats,
                              const SizedBox(height: 10),
                              footer,
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _StackPreview extends StatelessWidget {
  const _StackPreview();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFF0F172A), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.35),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'LAYER',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Text(
              'Stack is for overlap and visual layering.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            right: 18,
            top: 18,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.orange.shade300,
              child: const Icon(Icons.notifications, color: Colors.white),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: FilledButton.tonalIcon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new),
              label: const Text('Inspect'),
            ),
          ),
        ],
      ),
    );
  }
}
