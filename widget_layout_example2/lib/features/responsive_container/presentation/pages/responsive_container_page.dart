import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.responsiveContainer)
class ResponsiveContainerPage extends StatefulWidget {
  const ResponsiveContainerPage({super.key});

  @override
  State<ResponsiveContainerPage> createState() =>
      _ResponsiveContainerPageState();
}

class _ResponsiveContainerPageState extends State<ResponsiveContainerPage> {
  double _previewWidth = 420;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ResponsiveContainer Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'ResponsiveContainer adapts its internal layout based on the space its parent gives it, which makes it useful for cards, panels, and adaptive dashboard blocks.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Fixed-Width Previews',
              description:
                  'Constrain the same widget to different widths to verify how it reorganizes content in compact and expanded states.',
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 320,
                      child: _buildReleasePanel(context, 'Compact preview'),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 720,
                      child: _buildReleasePanel(context, 'Wide preview'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Interactive Width Test',
              description:
                  'Use a slider to simulate breakpoints and confirm that the widget responds to parent constraints instead of screen size alone.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Slider(
                    min: 260,
                    max: 820,
                    value: _previewWidth,
                    onChanged: (double value) {
                      setState(() {
                        _previewWidth = value;
                      });
                    },
                  ),
                  Text('Preview width: ${_previewWidth.round()} px'),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: _previewWidth,
                      child: _buildReleasePanel(context, 'Resizable preview'),
                    ),
                  ),
                ],
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

  Widget _buildReleasePanel(BuildContext context, String title) {
    return ResponsiveContainer(
      breakpoint: 520,
      builder: (BuildContext context, bool compact) {
        final Widget statusBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              compact
                  ? 'Compact layout stacks metadata vertically.'
                  : 'Expanded layout shows metadata and progress side by side.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const <Widget>[
                Chip(label: Text('Release 2.6')),
                Chip(label: Text('QA ready')),
                Chip(label: Text('3 reviewers')),
              ],
            ),
          ],
        );

        final Widget progressBlock = Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Progress', style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 10),
              LinearProgressIndicator(value: 0.72),
              SizedBox(height: 8),
              Text('72% complete'),
            ],
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              statusBlock,
              const SizedBox(height: 16),
              progressBlock,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 3, child: statusBlock),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: progressBlock),
          ],
        );
      },
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.builder,
    this.breakpoint = 600,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget Function(BuildContext context, bool compact) builder;
  final double breakpoint;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < breakpoint;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: padding,
          decoration: BoxDecoration(
            color: compact
                ? theme.colorScheme.surface
                : theme.colorScheme.secondary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: builder(context, compact),
        );
      },
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
