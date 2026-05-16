import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.flexible)
class FlexiblePage extends StatelessWidget {
  const FlexiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Flexible Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Flexible lets a child participate in a Row, Column, or Flex without forcing it to fill all remaining space.',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Use Flexible when you want flex-based layout behavior, but still want the child to size itself naturally with FlexFit.loose or control space sharing with custom flex values.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            const _ExampleCard(
              title: '1. Flexible with FlexFit.loose',
              description:
                  'Loose fit allows the child to take up only the width it needs instead of stretching to the full remaining space.',
              child: _LooseRowExample(),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: '2. Flexible with flex ratios',
              description:
                  'Multiple Flexible widgets can divide the remaining width proportionally using their flex values.',
              child: _TightRowExample(),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: '3. Flexible text in a toolbar row',
              description:
                  'Flexible is common in rows with icons and buttons, especially to prevent long text from overflowing.',
              child: _ToolbarExample(),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: '4. Flexible inside a Column',
              description:
                  'Flexible also works vertically. Here the summary section keeps a natural height while the details area takes a larger share of the remaining space.',
              child: _ColumnExample(),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: '5. Nested Flexible widgets',
              description:
                  'Flexible can be combined across nested Rows and Columns to build dashboard-like layouts with mixed fixed and adaptive areas.',
              child: _NestedFlexibleExample(),
            ),
            const SizedBox(height: 20),
            const _ComparisonNote(),
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

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
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

class _LooseRowExample extends StatelessWidget {
  const _LooseRowExample();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
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
                width: 120,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Short tag', textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              fit: FlexFit.loose,
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 170,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'This card can stay smaller than the available width.',
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

class _TightRowExample extends StatelessWidget {
  const _TightRowExample();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        children: const <Widget>[
          Flexible(
            flex: 1,
            child: _ColorPanel(
              color: Colors.orange,
              label: 'flex: 1',
              subtitle: 'Sidebar',
            ),
          ),
          SizedBox(width: 12),
          Flexible(
            flex: 2,
            child: _ColorPanel(
              color: Colors.indigo,
              label: 'flex: 2',
              subtitle: 'Main content',
            ),
          ),
          SizedBox(width: 12),
          Flexible(
            flex: 1,
            child: _ColorPanel(
              color: Colors.green,
              label: 'flex: 1',
              subtitle: 'Actions',
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolbarExample extends StatelessWidget {
  const _ToolbarExample();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            const Icon(Icons.notifications_active_outlined),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Quarterly revenue summary is ready to review and can wrap without pushing the action button off-screen.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(onPressed: () {}, child: const Text('Review')),
          ],
        ),
      ),
    );
  }
}

class _ColumnExample extends StatelessWidget {
  const _ColumnExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.cyan.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[
          _ColorPanel(
            color: Colors.blueGrey,
            label: 'Fixed header',
            subtitle: 'Always 56px tall',
            height: 56,
          ),
          SizedBox(height: 12),
          Flexible(
            fit: FlexFit.loose,
            child: _ColorPanel(
              color: Colors.lightBlue,
              label: 'Flexible loose',
              subtitle: 'Keeps a natural height for summary content',
              height: 72,
            ),
          ),
          SizedBox(height: 12),
          Flexible(
            flex: 2,
            child: _ColorPanel(
              color: Colors.teal,
              label: 'Flexible flex: 2',
              subtitle: 'Takes a larger share for details',
            ),
          ),
          SizedBox(height: 12),
          Flexible(
            child: _ColorPanel(
              color: Colors.indigo,
              label: 'Flexible flex: 1',
              subtitle: 'Secondary panel',
            ),
          ),
        ],
      ),
    );
  }
}

class _NestedFlexibleExample extends StatelessWidget {
  const _NestedFlexibleExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.brown.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          const Flexible(
            child: _ColorPanel(
              color: Colors.deepOrange,
              label: 'Left rail',
              subtitle: 'Navigation',
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 2,
            child: Column(
              children: const <Widget>[
                Flexible(
                  child: _ColorPanel(
                    color: Colors.pink,
                    label: 'Top card',
                    subtitle: 'Overview',
                  ),
                ),
                SizedBox(height: 12),
                Flexible(
                  flex: 2,
                  child: _ColorPanel(
                    color: Colors.purple,
                    label: 'Bottom card',
                    subtitle: 'Chart / list / editor',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorPanel extends StatelessWidget {
  const _ColorPanel({
    required this.color,
    required this.label,
    required this.subtitle,
    this.height,
  });

  final Color color;
  final String label;
  final String subtitle;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact =
              constraints.maxHeight.isFinite && constraints.maxHeight < 72;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: compact ? 8 : 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 14 : 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (!compact) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ComparisonNote extends StatelessWidget {
  const _ComparisonNote();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Rule of thumb: use Expanded when the child must fill the remaining space. Use Flexible when the child should participate in flex layout but still be allowed to stay smaller than the space available.',
        ),
      ),
    );
  }
}
