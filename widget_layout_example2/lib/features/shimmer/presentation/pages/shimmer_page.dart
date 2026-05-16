import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.shimmer)
class ShimmerPage extends StatefulWidget {
  const ShimmerPage({super.key});

  @override
  State<ShimmerPage> createState() => _ShimmerPageState();
}

class _ShimmerPageState extends State<ShimmerPage> {
  bool _enabled = true;
  ShimmerDirection _direction = ShimmerDirection.ltr;
  int _loopCount = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('shimmer Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'shimmer renders an animated highlight sweep across opaque placeholder widgets, which makes it useful for skeleton loading states, swipe prompts, and any area that should read as temporarily unavailable content.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `Shimmer.fromColors`, the base `Shimmer` constructor with a custom gradient, `ShimmerDirection`, `period`, `loop`, and `enabled` with several practical Flutter layouts.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Global Controls',
              description:
                  'These controls affect all shimmer examples on the page so you can compare how direction, looping, and pause behavior change the final effect.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilterChip(
                        label: const Text('Animation enabled'),
                        selected: _enabled,
                        onSelected: (bool value) {
                          setState(() {
                            _enabled = value;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Infinite loop'),
                        selected: _loopCount == 0,
                        onSelected: (bool selected) {
                          if (!selected) {
                            return;
                          }
                          setState(() {
                            _loopCount = 0;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Loop x3'),
                        selected: _loopCount == 3,
                        onSelected: (bool selected) {
                          if (!selected) {
                            return;
                          }
                          setState(() {
                            _loopCount = 3;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Direction',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      _DirectionChip(
                        label: 'Left to right',
                        selected: _direction == ShimmerDirection.ltr,
                        onTap: () {
                          setState(() {
                            _direction = ShimmerDirection.ltr;
                          });
                        },
                      ),
                      _DirectionChip(
                        label: 'Right to left',
                        selected: _direction == ShimmerDirection.rtl,
                        onTap: () {
                          setState(() {
                            _direction = ShimmerDirection.rtl;
                          });
                        },
                      ),
                      _DirectionChip(
                        label: 'Top to bottom',
                        selected: _direction == ShimmerDirection.ttb,
                        onTap: () {
                          setState(() {
                            _direction = ShimmerDirection.ttb;
                          });
                        },
                      ),
                      _DirectionChip(
                        label: 'Bottom to top',
                        selected: _direction == ShimmerDirection.btt,
                        onTap: () {
                          setState(() {
                            _direction = ShimmerDirection.btt;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Skeleton Loading Layout',
              description:
                  'A single `Shimmer.fromColors` can wrap a complete loading tree, which is usually better than applying many independent shimmer widgets.',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: _enabled,
                    direction: _direction,
                    loop: _loopCount,
                    period: const Duration(milliseconds: 1400),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _BannerPlaceholder(),
                        SizedBox(height: 18),
                        _LinePlaceholder(widthFactor: 0.66, height: 20),
                        SizedBox(height: 12),
                        _LinePlaceholder(widthFactor: 0.92),
                        SizedBox(height: 10),
                        _LinePlaceholder(widthFactor: 0.88),
                        SizedBox(height: 10),
                        _LinePlaceholder(widthFactor: 0.54),
                        SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Expanded(child: _SmallCardPlaceholder()),
                            SizedBox(width: 14),
                            Expanded(child: _SmallCardPlaceholder()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Slide Prompt Pattern',
              description:
                  'Shimmer also works well for directional cues, such as swipe handles or lock-screen style prompts.',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 26,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Opacity(
                    opacity: 0.92,
                    child: Shimmer.fromColors(
                      baseColor: Colors.white24,
                      highlightColor: Colors.white,
                      enabled: _enabled,
                      direction: _direction,
                      loop: _loopCount,
                      period: const Duration(milliseconds: 1200),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Slide to continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Custom Gradient Constructor',
              description:
                  'Use the base `Shimmer` constructor when you want a more stylized gradient than the convenience `fromColors` helper provides.',
              child: Shimmer(
                enabled: _enabled,
                direction: _direction,
                loop: _loopCount,
                period: const Duration(milliseconds: 1700),
                gradient: const LinearGradient(
                  colors: <Color>[
                    Color(0xFF0EA5E9),
                    Color(0xFF38BDF8),
                    Color(0xFFF8FAFC),
                    Color(0xFFF472B6),
                    Color(0xFF7C3AED),
                  ],
                  stops: <double>[0, 0.25, 0.5, 0.75, 1],
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const <Widget>[
                    _BadgePlaceholder(label: 'Loading analytics'),
                    _BadgePlaceholder(label: 'Preparing avatar'),
                    _BadgePlaceholder(label: 'Syncing feed'),
                    _BadgePlaceholder(label: 'Building cards'),
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

class _DirectionChip extends StatelessWidget {
  const _DirectionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (bool value) {
        if (value) {
          onTap();
        }
      },
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _LinePlaceholder extends StatelessWidget {
  const _LinePlaceholder({required this.widthFactor, this.height = 14});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _SmallCardPlaceholder extends StatelessWidget {
  const _SmallCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}

class _BadgePlaceholder extends StatelessWidget {
  const _BadgePlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
