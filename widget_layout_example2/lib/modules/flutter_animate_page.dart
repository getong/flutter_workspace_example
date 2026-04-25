import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.flutterAnimate)
class FlutterAnimatePage extends StatefulWidget {
  const FlutterAnimatePage({super.key});

  @override
  State<FlutterAnimatePage> createState() => _FlutterAnimatePageState();
}

class _FlutterAnimatePageState extends State<FlutterAnimatePage> {
  double _scrubValue = 0.35;
  bool _showDetails = false;

  late final List<_Metric> _metrics = const <_Metric>[
    _Metric(
      title: 'Hero cards',
      value: '12',
      caption: 'Staggered promos with readable timing.',
      icon: Icons.dashboard_customize_rounded,
      color: Color(0xFF2563EB),
    ),
    _Metric(
      title: 'CTA states',
      value: '4',
      caption: 'Drive emphasis with `target:` changes.',
      icon: Icons.touch_app_rounded,
      color: Color(0xFF7C3AED),
    ),
    _Metric(
      title: 'Adapters',
      value: '1',
      caption: 'Scrub animations from a slider or notifier.',
      icon: Icons.tune_rounded,
      color: Color(0xFF0F766E),
    ),
  ];

  late final List<Effect> _staggerEffects = EffectList()
      .fadeIn(duration: 320.ms, curve: Curves.easeOutCubic)
      .moveY(begin: 28, end: 0, duration: 420.ms, curve: Curves.easeOut)
      .scaleXY(begin: 0.96, end: 1, curve: Curves.easeOutBack);

  late final List<Effect> _reusableEffects = EffectList()
      .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
      .slideY(begin: 0.18, end: 0, duration: 380.ms, curve: Curves.easeOut)
      .scaleXY(begin: 0.97, end: 1, curve: Curves.easeOutBack);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_animate Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'flutter_animate adds expressive motion without forcing you to '
              'rewrite your widget tree. You can animate a single widget inline, '
              'stagger a list, reuse effect chains, or drive progress from state.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates `Animate`, the `.animate()` extension, '
              '`AnimateList`, `EffectList`, looping playback, and `ValueAdapter` '
              'with practical Flutter widgets instead of isolated one-off snippets.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Extension API on regular widgets',
              description:
                  'Start from any widget and chain effects in place. This keeps the animation close to the widget it styles.',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: <Color>[
                      const Color(0xFF0F172A),
                      colorScheme.primary.withValues(alpha: 0.82),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                          'Launch motion with intent',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 350.ms)
                        .slideY(
                          begin: 0.35,
                          end: 0,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: 12),
                    Text(
                          'Inline chains work well for headlines, badges, CTAs, and '
                          'small supporting details that should appear together.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.88),
                          ),
                        )
                        .animate(delay: 120.ms)
                        .fadeIn(duration: 350.ms)
                        .moveY(begin: 18, end: 0, duration: 420.ms),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _metrics
                          .map((_Metric metric) => _MetricPill(metric: metric))
                          .toList(growable: false)
                          .animate(interval: 100.ms)
                          .fadeIn(duration: 260.ms)
                          .scaleXY(
                            begin: 0.88,
                            end: 1,
                            curve: Curves.easeOutBack,
                          ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0F172A),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                          ),
                          icon: const Icon(Icons.auto_awesome_rounded),
                          label: const Text('Chain effects on a CTA'),
                        )
                        .animate(delay: 320.ms)
                        .fadeIn(duration: 260.ms)
                        .slideX(
                          begin: -0.08,
                          end: 0,
                          duration: 420.ms,
                          curve: Curves.easeOutCubic,
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Animate widget with target-driven state',
              description:
                  'Use `Animate(target: ...)` when the same widget should move between start and end states as local UI state changes.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SwitchListTile(
                    value: _showDetails,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Reveal implementation notes'),
                    subtitle: const Text(
                      'Toggling this switch animates the panel instead of replacing it with a separate widget tree.',
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        _showDetails = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Animate(
                    target: _showDetails ? 1 : 0,
                    effects: <Effect>[
                      FadeEffect(
                        begin: 0,
                        end: 1,
                        duration: 260.ms,
                        curve: Curves.easeOutCubic,
                      ),
                      SlideEffect(
                        begin: const Offset(0, 0.08),
                        end: Offset.zero,
                        duration: 360.ms,
                        curve: Curves.easeOutCubic,
                      ),
                      ScaleEffect(
                        begin: const Offset(0.98, 0.98),
                        end: const Offset(1, 1),
                        duration: 360.ms,
                        curve: Curves.easeOutBack,
                      ),
                    ],
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.route_rounded,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Shipping checklist',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const _ChecklistLine(
                            title: 'Use `target:` for state-driven emphasis',
                            subtitle:
                                'A hover, toggle, or expanded state can animate between 0 and 1 without manually managing a controller.',
                          ),
                          const SizedBox(height: 12),
                          const _ChecklistLine(
                            title: 'Keep durations short for utility surfaces',
                            subtitle:
                                'Panels, cards, and secondary actions should reinforce interaction, not slow it down.',
                          ),
                          const SizedBox(height: 12),
                          const _ChecklistLine(
                            title:
                                'Compose motion with ordinary Flutter widgets',
                            subtitle:
                                'The child here is just a decorated `Container` with rows and text inside it.',
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
              title: 'AnimateList for staggered cards',
              description:
                  'When you already have a list of widgets, `AnimateList` applies the same effect chain while offsetting the start time for each item.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: AnimateList(
                      interval: 120.ms,
                      effects: _staggerEffects,
                      children: _metrics
                          .map(
                            (_Metric metric) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _MetricDetailCard(metric: metric),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is useful for dashboards, onboarding steps, launchers, or search results where related widgets should appear with a deliberate cadence.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'ValueAdapter for manual scrubbing',
              description:
                  'Adapters let external state drive animation progress. A slider is the simplest way to see the pattern clearly.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Progress: ${(_scrubValue * 100).round()}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Slider(
                    value: _scrubValue,
                    onChanged: (double value) {
                      setState(() {
                        _scrubValue = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: const Color(0xFF111827),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                                  backgroundColor: const Color(0xFF38BDF8),
                                  child: Icon(
                                    Icons.waves_rounded,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                                .animate(adapter: ValueAdapter(_scrubValue))
                                .scaleXY(begin: 0.6, end: 1)
                                .fadeIn(),
                            const SizedBox(width: 16),
                            Expanded(
                              child:
                                  Text(
                                        'Bind animation progress to user input',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                      )
                                      .animate(
                                        adapter: ValueAdapter(_scrubValue),
                                      )
                                      .fadeIn(duration: 220.ms)
                                      .slideX(begin: -0.18, end: 0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                              'This pattern also works with scroll position, page state, or any other notifier that can be converted into a 0-1 value.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withValues(alpha: 0.84),
                              ),
                            )
                            .animate(adapter: ValueAdapter(_scrubValue))
                            .fadeIn()
                            .moveY(begin: 18, end: 0),
                        const SizedBox(height: 20),
                        LinearProgressIndicator(
                              value: _scrubValue,
                              minHeight: 12,
                              borderRadius: BorderRadius.circular(999),
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.12,
                              ),
                            )
                            .animate(adapter: ValueAdapter(_scrubValue))
                            .scaleX(
                              begin: 0.45,
                              end: 1,
                              alignment: Alignment.centerLeft,
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Reusable EffectList across widget types',
              description:
                  'Build one effect list once, then apply it to different widgets so motion stays consistent across a feature.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  Animate(
                    effects: _reusableEffects,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.campaign_rounded),
                      label: const Text('Publish update'),
                    ),
                  ),
                  Animate(
                    delay: 100.ms,
                    effects: _reusableEffects,
                    child: Chip(
                      avatar: Icon(
                        Icons.offline_bolt_rounded,
                        color: colorScheme.primary,
                        size: 18,
                      ),
                      label: const Text('Shared motion preset'),
                    ),
                  ),
                  Animate(
                    delay: 200.ms,
                    effects: _reusableEffects,
                    child: Container(
                      width: 220,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Status card',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const LinearProgressIndicator(value: 0.72),
                          const SizedBox(height: 10),
                          Text(
                            'Apply the same entry motion to buttons, chips, cards, or tiles.',
                            style: theme.textTheme.bodySmall,
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
              title: 'Looping effect gallery',
              description:
                  'The upstream `flutter_animate` example includes a broad effect catalog. This smaller gallery keeps that spirit but applies the effects to common app widgets.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  _LoopingEffectTile(
                    label: 'fade + slide',
                    demo:
                        Icon(
                              Icons.send_rounded,
                              size: 34,
                              color: colorScheme.primary,
                            )
                            .animate(
                              onPlay: (AnimationController controller) {
                                controller.repeat(reverse: true);
                              },
                            )
                            .fadeIn(duration: 420.ms)
                            .slideY(
                              begin: 0.35,
                              end: -0.12,
                              duration: 1200.ms,
                              curve: Curves.easeInOutCubic,
                            ),
                  ),
                  _LoopingEffectTile(
                    label: 'scale + tint',
                    demo:
                        Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBEAFE),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(Icons.bolt_rounded),
                            )
                            .animate(
                              onPlay: (AnimationController controller) {
                                controller.repeat(reverse: true);
                              },
                            )
                            .scaleXY(
                              begin: 0.82,
                              end: 1.12,
                              duration: 1100.ms,
                              curve: Curves.easeInOutBack,
                            )
                            .tint(color: const Color(0xFF2563EB), end: 0.35),
                  ),
                  _LoopingEffectTile(
                    label: 'rotate',
                    demo:
                        CircleAvatar(
                              radius: 26,
                              backgroundColor: const Color(0xFFEDE9FE),
                              child: Icon(
                                Icons.refresh_rounded,
                                color: colorScheme.secondary,
                              ),
                            )
                            .animate(
                              onPlay: (AnimationController controller) {
                                controller.repeat(reverse: true);
                              },
                            )
                            .rotate(
                              begin: -0.08,
                              end: 0.08,
                              duration: 1000.ms,
                              curve: Curves.easeInOutCubic,
                            ),
                  ),
                  _LoopingEffectTile(
                    label: 'shimmer',
                    demo:
                        Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Loading copy',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                            .animate(
                              onPlay: (AnimationController controller) {
                                controller.repeat();
                              },
                            )
                            .shimmer(duration: 1400.ms),
                  ),
                  _LoopingEffectTile(
                    label: 'shake',
                    demo:
                        Chip(
                              avatar: const Icon(
                                Icons.notification_important_rounded,
                              ),
                              label: const Text('Attention'),
                            )
                            .animate(
                              onPlay: (AnimationController controller) {
                                controller.repeat();
                              },
                            )
                            .shake(
                              hz: 2,
                              duration: 1100.ms,
                              curve: Curves.easeInOutCubic,
                            ),
                  ),
                  _LoopingEffectTile(
                    label: 'blur + fade',
                    demo:
                        Text(
                              'Focus',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            )
                            .animate(
                              onPlay: (AnimationController controller) {
                                controller.repeat(reverse: true);
                              },
                            )
                            .fadeIn(duration: 400.ms)
                            .blurXY(
                              begin: 10,
                              end: 0,
                              duration: 1000.ms,
                              curve: Curves.easeOutCubic,
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
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class _Metric {
  const _Metric({
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String caption;
  final IconData icon;
  final Color color;
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.metric});

  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(metric.icon, size: 18, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            metric.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            metric.value,
            style: TextStyle(
              color: metric.color.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricDetailCard extends StatelessWidget {
  const _MetricDetailCard({required this.metric});

  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: metric.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: metric.color.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: metric.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(metric.icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        metric.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      metric.value,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: metric.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(metric.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistLine extends StatelessWidget {
  const _ChecklistLine({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoopingEffectTile extends StatelessWidget {
  const _LoopingEffectTile({required this.label, required this.demo});

  final String label;
  final Widget demo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 170,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 72, child: Center(child: demo)),
            const SizedBox(height: 10),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
