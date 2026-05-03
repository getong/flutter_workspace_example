import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.customMultiChildLayoutVsLayoutBuilder)
class CustomMultiChildLayoutVsLayoutBuilderPage extends StatelessWidget {
  const CustomMultiChildLayoutVsLayoutBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomMultiChildLayout vs LayoutBuilder'),
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'LayoutBuilder and CustomMultiChildLayout both deal with layout, but they solve different problems. LayoutBuilder chooses a widget tree from parent constraints. CustomMultiChildLayout precisely measures and positions multiple named children inside one coordinated layout.',
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
                      'Use LayoutBuilder when you want to ask: "How much space did my parent give me?"',
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Use CustomMultiChildLayout when you want to ask: "How should these children be measured and positioned relative to each other?"',
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
                      'This preview changes its structure based on available width. The main idea is responsive branching, not exact child positioning.',
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      height: 220,
                      child: _LayoutBuilderComparisonPreview(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Typical use cases: compact vs expanded cards, responsive toolbars, sidebar vs stacked content, local breakpoints inside reusable widgets.',
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
                      'CustomMultiChildLayout Focus',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This preview keeps one deliberate composition. The key is that a delegate decides how several named children are measured and placed.',
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      height: 150,
                      child: _CustomMultiChildLayoutComparisonPreview(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Typical use cases: custom headers, ticket layouts, dashboards, media controls, and any layout where children depend on each other for final placement.',
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
                    _DifferenceRow(
                      label: 'Question',
                      layoutBuilder:
                          'How much width or height did my parent give me?',
                      customMultiChildLayout:
                          'How should multiple children be arranged together?',
                    ),
                    const SizedBox(height: 12),
                    _DifferenceRow(
                      label: 'Main tool',
                      layoutBuilder:
                          'Branch inside builder using BoxConstraints',
                      customMultiChildLayout:
                          'Use LayoutId and MultiChildLayoutDelegate',
                    ),
                    const SizedBox(height: 12),
                    _DifferenceRow(
                      label: 'Best at',
                      layoutBuilder:
                          'Responsive/adaptive widget tree decisions',
                      customMultiChildLayout:
                          'Precise measurement and positioning logic',
                    ),
                    const SizedBox(height: 12),
                    _DifferenceRow(
                      label: 'Usually avoid when',
                      layoutBuilder:
                          'You only need a normal Row, Column, or Wrap',
                      customMultiChildLayout:
                          'Simple layouts already work with standard widgets',
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
    required this.customMultiChildLayout,
  });

  final String label;
  final String layoutBuilder;
  final String customMultiChildLayout;

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
                        'CustomMultiChildLayout',
                        style: TextStyle(
                          color: Colors.indigo.shade800,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(customMultiChildLayout),
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

class _LayoutBuilderComparisonPreview extends StatelessWidget {
  const _LayoutBuilderComparisonPreview();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Expanded(child: _ResponsivePane(width: 190)),
        SizedBox(width: 12),
        Expanded(child: _ResponsivePane(width: 360)),
      ],
    );
  }
}

class _ResponsivePane extends StatelessWidget {
  const _ResponsivePane({required this.width});

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
                compact ? 'Compact' : 'Expanded',
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

            final Widget actions = Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text('A'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text('B'),
                  ),
                ),
              ],
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
                        actions,
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        Expanded(flex: 2, child: hero),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              stats,
                              const SizedBox(height: 10),
                              actions,
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

enum _ComparisonSlot { avatar, title, subtitle, badge, trailing }

class _CustomMultiChildLayoutComparisonPreview extends StatelessWidget {
  const _CustomMultiChildLayoutComparisonPreview();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: CustomMultiChildLayout(
        delegate: _ComparisonHeaderDelegate(),
        children: <Widget>[
          LayoutId(
            id: _ComparisonSlot.avatar,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.indigo.shade400,
              child: const Text(
                'CM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          LayoutId(
            id: _ComparisonSlot.title,
            child: Text(
              'Precise Composition',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          LayoutId(
            id: _ComparisonSlot.subtitle,
            child: Text(
              'Children are measured and placed by one delegate',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          LayoutId(
            id: _ComparisonSlot.badge,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Delegate',
                style: TextStyle(
                  color: Colors.indigo.shade900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          LayoutId(
            id: _ComparisonSlot.trailing,
            child: Icon(Icons.tune_rounded, color: Colors.indigo.shade700),
          ),
        ],
      ),
    );
  }
}

class _ComparisonHeaderDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    const double padding = 16;
    const double gap = 12;

    final Size avatarSize = layoutChild(
      _ComparisonSlot.avatar,
      const BoxConstraints.tightFor(width: 48, height: 48),
    );
    positionChild(_ComparisonSlot.avatar, const Offset(padding, 16));

    final Size trailingSize = layoutChild(
      _ComparisonSlot.trailing,
      BoxConstraints.loose(const Size(28, 28)),
    );
    positionChild(
      _ComparisonSlot.trailing,
      Offset(size.width - padding - trailingSize.width, 18),
    );

    final double textX = padding + avatarSize.width + gap;
    final double textWidth =
        size.width - textX - trailingSize.width - gap - padding;

    final Size titleSize = layoutChild(
      _ComparisonSlot.title,
      BoxConstraints.tightFor(width: textWidth),
    );
    positionChild(_ComparisonSlot.title, Offset(textX, 16));

    layoutChild(
      _ComparisonSlot.subtitle,
      BoxConstraints.tightFor(width: textWidth),
    );
    positionChild(
      _ComparisonSlot.subtitle,
      Offset(textX, 16 + titleSize.height + 4),
    );

    final Size badgeSize = layoutChild(
      _ComparisonSlot.badge,
      BoxConstraints.loose(const Size(120, 32)),
    );
    positionChild(
      _ComparisonSlot.badge,
      Offset(textX, size.height - padding - badgeSize.height),
    );
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => false;
}
