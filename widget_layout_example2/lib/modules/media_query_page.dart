import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage(name: 'MediaQueryRoute')
class MediaQueryPage extends StatelessWidget {
  const MediaQueryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size size = mediaQuery.size;
    final Orientation orientation = mediaQuery.orientation;

    return Scaffold(
      appBar: AppBar(title: const Text('MediaQuery Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'MediaQuery exposes information about the current screen and view.',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates common `MediaQuery` usage: reading '
              'screen size, reacting to orientation, inspecting safe-area '
              'padding, checking keyboard insets, and adapting layout when the '
              'available width changes.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _MediaSummaryCard(
              size: size,
              orientation: orientation,
              devicePixelRatio: mediaQuery.devicePixelRatio,
              padding: mediaQuery.padding,
              viewInsets: mediaQuery.viewInsets,
            ),
            const SizedBox(height: 16),
            const _BreakpointExampleCard(),
            const SizedBox(height: 16),
            const _OrientationExampleCard(),
            const SizedBox(height: 16),
            const _PaddingInsetsExampleCard(),
            const SizedBox(height: 16),
            const _RemovePaddingExampleCard(),
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

class _MediaSummaryCard extends StatelessWidget {
  const _MediaSummaryCard({
    required this.size,
    required this.orientation,
    required this.devicePixelRatio,
    required this.padding,
    required this.viewInsets,
  });

  final Size size;
  final Orientation orientation;
  final double devicePixelRatio;
  final EdgeInsets padding;
  final EdgeInsets viewInsets;

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
              'Current MediaQuery Data',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                _MetricChip(
                  label: 'width',
                  value: size.width.toStringAsFixed(1),
                ),
                _MetricChip(
                  label: 'height',
                  value: size.height.toStringAsFixed(1),
                ),
                _MetricChip(label: 'orientation', value: orientation.name),
                _MetricChip(
                  label: 'pixel ratio',
                  value: devicePixelRatio.toStringAsFixed(2),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('padding: $padding'),
            const SizedBox(height: 6),
            Text('viewInsets: $viewInsets'),
          ],
        ),
      ),
    );
  }
}

class _BreakpointExampleCard extends StatelessWidget {
  const _BreakpointExampleCard();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool useWideLayout = width >= 700;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Responsive Width Breakpoint',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'This section branches on `MediaQuery.of(context).size.width` '
              'to switch between a narrow stacked layout and a wider horizontal layout.',
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: useWideLayout
                  ? const _WideMediaLayout(key: ValueKey('wide'))
                  : const _NarrowMediaLayout(key: ValueKey('narrow')),
            ),
            const SizedBox(height: 12),
            Text(
              'Current rule: width ${useWideLayout ? '>=' : '<'} 700',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrientationExampleCard extends StatelessWidget {
  const _OrientationExampleCard();

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Orientation-Aware Layout',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'MediaQuery also exposes orientation so you can rebalance a layout '
              'when the device rotates.',
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.indigo.withValues(alpha: 0.10),
              ),
              child: Flex(
                direction: isPortrait ? Axis.vertical : Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    child: _OrientationPane(
                      color: Colors.indigo,
                      title: isPortrait ? 'Portrait stack' : 'Landscape row',
                    ),
                  ),
                  SizedBox(
                    width: isPortrait ? 0 : 12,
                    height: isPortrait ? 12 : 0,
                  ),
                  Expanded(
                    child: _OrientationPane(
                      color: Colors.deepPurple,
                      title: orientation.name,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaddingInsetsExampleCard extends StatelessWidget {
  const _PaddingInsetsExampleCard();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final bool keyboardVisible = mediaQuery.viewInsets.bottom > 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Safe Area Padding and Keyboard Insets',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Use `padding`, `viewPadding`, and `viewInsets` to understand notches, '
              'system UI, and keyboard overlap.',
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.teal.withValues(alpha: 0.10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'padding.top: ${mediaQuery.padding.top.toStringAsFixed(1)}',
                  ),
                  Text(
                    'viewPadding.bottom: ${mediaQuery.viewPadding.bottom.toStringAsFixed(1)}',
                  ),
                  Text(
                    'viewInsets.bottom: ${mediaQuery.viewInsets.bottom.toStringAsFixed(1)}',
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: keyboardVisible
                          ? Colors.orange.withValues(alpha: 0.18)
                          : Colors.green.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      keyboardVisible
                          ? 'Keyboard appears to be visible.'
                          : 'Keyboard appears to be hidden.',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemovePaddingExampleCard extends StatelessWidget {
  const _RemovePaddingExampleCard();

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
              'MediaQuery.removePadding',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'You can derive a modified MediaQuery subtree when a child should '
              'ignore inherited safe-area padding on one side.',
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  children: const <Widget>[
                    _ListRow(title: 'Top padding removed for this subtree'),
                    SizedBox(height: 8),
                    _ListRow(title: 'Useful for custom headers or overlays'),
                    SizedBox(height: 8),
                    _ListRow(title: 'Only the derived subtree is affected'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.60),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('$label: $value'),
    );
  }
}

class _WideMediaLayout extends StatelessWidget {
  const _WideMediaLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      key: key,
      children: const <Widget>[
        Expanded(
          child: _ColorPane(color: Colors.blue, label: 'Sidebar'),
        ),
        SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _ColorPane(color: Colors.orange, label: 'Content'),
        ),
      ],
    );
  }
}

class _NarrowMediaLayout extends StatelessWidget {
  const _NarrowMediaLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      children: const <Widget>[
        _ColorPane(color: Colors.blue, label: 'Header'),
        SizedBox(height: 12),
        _ColorPane(color: Colors.orange, label: 'Body'),
      ],
    );
  }
}

class _ColorPane extends StatelessWidget {
  const _ColorPane({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _OrientationPane extends StatelessWidget {
  const _OrientationPane({required this.color, required this.title});

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ListRow extends StatelessWidget {
  const _ListRow({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(title),
    );
  }
}
