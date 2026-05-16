import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.advancedProgressIndicator)
class AdvancedProgressIndicatorPage extends StatefulWidget {
  const AdvancedProgressIndicatorPage({super.key});

  @override
  State<AdvancedProgressIndicatorPage> createState() =>
      _AdvancedProgressIndicatorPageState();
}

class _AdvancedProgressIndicatorPageState
    extends State<AdvancedProgressIndicatorPage> {
  double _progress = 0.42;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AdvancedProgressIndicator Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'AdvancedProgressIndicator combines progress, milestones, labels, and animated visual feedback in a reusable widget.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Interactive Upload Progress',
              description:
                  'Drive the indicator from page state to show determinate progress, labels, and milestone markers.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AdvancedProgressIndicator(
                    progress: _progress,
                    title: 'Artifact upload',
                    subtitle: 'Release bundle sync to cloud storage',
                    leading: const Icon(Icons.cloud_upload_outlined),
                    trailing: '${(_progress * 100).round()}%',
                    milestones: const <String>[
                      'Queued',
                      'Uploaded',
                      'Verified',
                      'Published',
                    ],
                    gradient: const LinearGradient(
                      colors: <Color>[Colors.blue, Colors.indigo],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: _progress,
                    onChanged: (double value) {
                      setState(() {
                        _progress = value;
                      });
                    },
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            _progress = (_progress + 0.2).clamp(0.0, 1.0);
                          });
                        },
                        child: const Text('Advance 20%'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _progress = 0.0;
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Compact Status List',
              description:
                  'The same widget can be reused in tighter vertical layouts with smaller height and simpler labels.',
              child: Column(
                children: const <Widget>[
                  AdvancedProgressIndicator(
                    progress: 0.18,
                    title: 'Design review',
                    subtitle: 'Initial draft shared',
                    trailing: '18%',
                    height: 10,
                    gradient: LinearGradient(
                      colors: <Color>[Colors.orange, Colors.deepOrange],
                    ),
                  ),
                  SizedBox(height: 16),
                  AdvancedProgressIndicator(
                    progress: 0.64,
                    title: 'API integration',
                    subtitle: 'Endpoints and auth complete',
                    trailing: '64%',
                    height: 10,
                    gradient: LinearGradient(
                      colors: <Color>[Colors.teal, Colors.green],
                    ),
                  ),
                  SizedBox(height: 16),
                  AdvancedProgressIndicator(
                    progress: 0.92,
                    title: 'QA checklist',
                    subtitle: 'Regression suite almost done',
                    trailing: '92%',
                    height: 10,
                    gradient: LinearGradient(
                      colors: <Color>[Colors.purple, Colors.blueAccent],
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
}

class AdvancedProgressIndicator extends StatelessWidget {
  const AdvancedProgressIndicator({
    super.key,
    required this.progress,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.milestones = const <String>[],
    this.height = 12,
    this.gradient,
    this.trackColor,
  });

  final double progress;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final String? trailing;
  final List<String> milestones;
  final double height;
  final Gradient? gradient;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double clampedProgress = progress.clamp(0.0, 1.0);
    final Color resolvedTrackColor =
        trackColor ?? theme.colorScheme.primary.withValues(alpha: 0.14);
    final Gradient resolvedGradient =
        gradient ??
        LinearGradient(
          colors: <Color>[
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (leading != null) ...<Widget>[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: theme.textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: resolvedTrackColor,
                    borderRadius: BorderRadius.circular(height),
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: clampedProgress),
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  builder:
                      (
                        BuildContext context,
                        double animatedValue,
                        Widget? child,
                      ) {
                        return Container(
                          height: height,
                          width: constraints.maxWidth * animatedValue,
                          decoration: BoxDecoration(
                            gradient: resolvedGradient,
                            borderRadius: BorderRadius.circular(height),
                          ),
                        );
                      },
                ),
                if (milestones.isNotEmpty)
                  ...List<Widget>.generate(milestones.length, (int index) {
                    final double fraction = milestones.length == 1
                        ? 1
                        : index / (milestones.length - 1);
                    final bool complete = clampedProgress >= fraction;
                    return Positioned(
                      left: (constraints.maxWidth - 10) * fraction,
                      top: -(10 - height) / 2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: complete
                              ? theme.colorScheme.surface
                              : resolvedTrackColor,
                          border: Border.all(
                            color: complete
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
              ],
            );
          },
        ),
        if (milestones.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          Row(
            children: milestones
                .map(
                  (String label) => Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
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
