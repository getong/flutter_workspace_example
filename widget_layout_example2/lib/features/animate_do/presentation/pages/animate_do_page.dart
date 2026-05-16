import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.animateDo)
class AnimateDoPage extends StatefulWidget {
  const AnimateDoPage({super.key});

  @override
  State<AnimateDoPage> createState() => _AnimateDoPageState();
}

class _AnimateDoPageState extends State<AnimateDoPage> {
  AnimationController? _manualController;
  bool _animatePresets = true;
  bool _loopBadge = true;
  int _finishCount = 0;
  String _lastDirection = 'none';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('animate_do Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'animate_do wraps common entrance and attention animations into ready-to-use Flutter widgets so the page structure stays declarative instead of wiring a separate controller for every effect.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `FadeInUp`, `ZoomIn`, `SlideInUp`, `ElasticIn`, infinite playback, extension-method usage, and manual triggering through the controller callback.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Preset Animation Widgets',
              description:
                  'The package ships with many named effects, which makes it easy to stage reveals without writing a custom Tween tree for each card.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilterChip(
                        label: const Text('Animate preset cards'),
                        selected: _animatePresets,
                        onSelected: (bool value) {
                          setState(() {
                            _animatePresets = value;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text('Loop notification badge'),
                        selected: _loopBadge,
                        onSelected: (bool value) {
                          setState(() {
                            _loopBadge = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: <Widget>[
                      FadeInUp(
                        animate: _animatePresets,
                        duration: const Duration(milliseconds: 500),
                        from: 36,
                        child: _MotionTile(
                          color: const Color(0xFFDBEAFE),
                          title: 'FadeInUp',
                          subtitle:
                              'Good for loading metric cards and section headers.',
                          icon: Icons.stacked_line_chart_outlined,
                        ),
                      ),
                      ZoomIn(
                        animate: _animatePresets,
                        delay: const Duration(milliseconds: 120),
                        duration: const Duration(milliseconds: 480),
                        child: _MotionTile(
                          color: const Color(0xFFFCE7F3),
                          title: 'ZoomIn',
                          subtitle:
                              'Useful when you want a compact callout to pop in.',
                          icon: Icons.rocket_launch_outlined,
                        ),
                      ),
                      SlideInUp(
                        animate: _animatePresets,
                        delay: const Duration(milliseconds: 220),
                        duration: const Duration(milliseconds: 520),
                        from: 120,
                        child: _MotionTile(
                          color: const Color(0xFFDCFCE7),
                          title: 'SlideInUp',
                          subtitle:
                              'Reads well for banners, bottom sheets, or toasts.',
                          icon: Icons.subdirectory_arrow_right_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Manual Trigger Control',
              description:
                  'When `manualTrigger` is enabled, the widget exposes its internal `AnimationController` so you can drive the effect from buttons or other UI state.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: () => _manualController?.forward(from: 0),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play Forward'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _manualController?.reverse(from: 1),
                        icon: const Icon(Icons.replay),
                        label: const Text('Reverse'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _manualController?.reset(),
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: const Text('Reset'),
                      ),
                      Chip(
                        label: Text(
                          'Finished: $_finishCount • Last: $_lastDirection',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ElasticIn(
                    manualTrigger: true,
                    controller: (AnimationController controller) {
                      _manualController = controller;
                    },
                    onFinish: (AnimateDoDirection direction) {
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        _finishCount += 1;
                        _lastDirection = direction.name;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Manual ElasticIn Panel',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Use the buttons above to replay or reverse the animation on demand.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Extension Method and Infinite Playback',
              description:
                  'The package also exposes widget extensions, which keeps usage terse when you only need a one-off entrance effect.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(18),
                                child: Text(
                                  'This card uses the `.fadeInUp(...)` extension directly on a widget tree.',
                                ),
                              ),
                            ).fadeInUp(
                              animate: _animatePresets,
                              delay: const Duration(milliseconds: 180),
                              duration: const Duration(milliseconds: 520),
                              from: 28,
                            ),
                      ),
                      const SizedBox(width: 12),
                      Pulse(
                        infinite: _loopBadge,
                        duration: const Duration(milliseconds: 900),
                        loopDelay: const Duration(milliseconds: 280),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111827),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.notifications_active_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Infinite',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
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

class _MotionTile extends StatelessWidget {
  const _MotionTile({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final Color color;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 30),
          const SizedBox(height: 18),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle),
        ],
      ),
    );
  }
}
