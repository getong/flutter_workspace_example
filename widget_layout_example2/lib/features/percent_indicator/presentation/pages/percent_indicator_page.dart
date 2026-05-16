import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/multi_segment_linear_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.percentIndicator)
class PercentIndicatorPage extends StatefulWidget {
  const PercentIndicatorPage({super.key});

  @override
  State<PercentIndicatorPage> createState() => _PercentIndicatorPageState();
}

class _PercentIndicatorPageState extends State<PercentIndicatorPage> {
  double _projectProgress = 0.68;
  double _radialProgress = 0.42;
  bool _animate = true;
  bool _rtl = false;
  bool _showIndicator = true;
  CircularStrokeCap _strokeCap = CircularStrokeCap.round;

  List<double> _segmentValues = <double>[0.22, 0.34, 0.18];

  void _advanceProject() {
    setState(() {
      _projectProgress = (_projectProgress + 0.08).clamp(0.0, 1.0);
    });
  }

  void _advanceRadial() {
    setState(() {
      _radialProgress = (_radialProgress + 0.11).clamp(0.0, 1.0);
    });
  }

  void _rotateSegments() {
    setState(() {
      _segmentValues = <double>[
        _segmentValues[1],
        _segmentValues[2],
        _segmentValues[0],
      ];
    });
  }

  void _normalizeSegments() {
    setState(() {
      _segmentValues = <double>[0.22, 0.34, 0.18];
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('percent_indicator Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'The `percent_indicator` package provides circular, linear, and multi-segment percent widgets with animation, gradients, labels, and embedded content.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `CircularPercentIndicator`, `LinearPercentIndicator`, and `MultiSegmentLinearIndicator` from the installed `percent_indicator` package.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const <Widget>[
                _KeywordChip(label: 'CircularPercentIndicator'),
                _KeywordChip(label: 'LinearPercentIndicator'),
                _KeywordChip(label: 'MultiSegmentLinearIndicator'),
                _KeywordChip(label: 'animation'),
                _KeywordChip(label: 'linearGradient'),
                _KeywordChip(label: 'widgetIndicator'),
              ],
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            _SectionCard(
              title: '1. Circular Percent Indicator',
              subtitle:
                  'Use circular indicators for compact KPIs, goals, or dashboard tiles. This section exercises center/footer/header content, stroke caps, gradients, arcs, and animation callbacks.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _advanceRadial,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Advance Circle'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _radialProgress = 0.15;
                          });
                        },
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Reset Circle'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: <Widget>[
                      _DemoTile(
                        title: 'KPI Ring',
                        subtitle: 'Gradient, footer, and rounded stroke cap.',
                        child: CircularPercentIndicator(
                          radius: 66,
                          lineWidth: 12,
                          percent: _radialProgress,
                          animation: _animate,
                          animationDuration: 900,
                          circularStrokeCap: _strokeCap,
                          center: Text(
                            '${(_radialProgress * 100).round()}%',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          footer: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'Weekly Goal',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          linearGradient: const LinearGradient(
                            colors: <Color>[
                              Color(0xFF26C6DA),
                              Color(0xFF1565C0),
                            ],
                          ),
                          backgroundColor: colorScheme.surfaceContainerHighest,
                        ),
                      ),
                      _DemoTile(
                        title: 'Arc Mode',
                        subtitle:
                            'Partial arc using startAngle and arcBackgroundColor.',
                        child: CircularPercentIndicator(
                          radius: 66,
                          lineWidth: 14,
                          percent: 0.76,
                          animation: _animate,
                          startAngle: 220,
                          arcType: ArcType.HALF,
                          arcBackgroundColor:
                              colorScheme.surfaceContainerHighest,
                          progressColor: Colors.deepOrange,
                          circularStrokeCap: CircularStrokeCap.square,
                          center: Icon(
                            Icons.speed_outlined,
                            color: Colors.deepOrange.shade700,
                            size: 30,
                          ),
                          header: Text(
                            'Build Health',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      _DemoTile(
                        title: 'Indicator Widget',
                        subtitle:
                            'Animated end-of-progress marker with reverse mode.',
                        child: CircularPercentIndicator(
                          radius: 58,
                          lineWidth: 10,
                          percent: 0.58,
                          animation: _animate,
                          reverse: true,
                          rotateLinearGradient: true,
                          progressColor: Colors.teal,
                          widgetIndicator: _showIndicator
                              ? const Icon(Icons.flag, color: Colors.teal)
                              : null,
                          center: Text(
                            '58%',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          onAnimationEnd: () {
                            if (!mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'CircularPercentIndicator animation finished.',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
                            'Circular Controls',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Animate'),
                            subtitle: const Text(
                              'Toggle package animation for both circular and linear examples.',
                            ),
                            value: _animate,
                            onChanged: (bool value) {
                              setState(() {
                                _animate = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Show widgetIndicator'),
                            subtitle: const Text(
                              'Adds a flag marker at the end of progress when the widget supports it.',
                            ),
                            value: _showIndicator,
                            onChanged: (bool value) {
                              setState(() {
                                _showIndicator = value;
                              });
                            },
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: CircularStrokeCap.values
                                .map(
                                  (CircularStrokeCap value) => ChoiceChip(
                                    label: Text(value.name),
                                    selected: _strokeCap == value,
                                    onSelected: (bool selected) {
                                      if (!selected) {
                                        return;
                                      }
                                      setState(() {
                                        _strokeCap = value;
                                      });
                                    },
                                  ),
                                )
                                .toList(),
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
              title: '2. Linear Percent Indicator',
              subtitle:
                  'Use linear indicators for uploads, quotas, and row-based dashboards. This section covers leading/trailing content, center labels, gradients, padding, radius, widgetIndicator, and RTL layout.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _advanceProject,
                        icon: const Icon(Icons.trending_up),
                        label: const Text('Advance Linear'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _projectProgress = 0.18;
                          });
                        },
                        icon: const Icon(Icons.undo),
                        label: const Text('Reset Linear'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _rtl = !_rtl;
                          });
                        },
                        icon: const Icon(Icons.compare_arrows),
                        label: Text(_rtl ? 'RTL On' : 'RTL Off'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _LinearExampleCard(
                    title: 'Progress With Content',
                    description:
                        'Leading, trailing, centered text, rounded radius, and optional indicator widget.',
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                            return LinearPercentIndicator(
                              lineHeight: 20,
                              percent: _projectProgress,
                              animation: _animate,
                              animationDuration: 850,
                              animateFromLastPercent: true,
                              isRTL: _rtl,
                              leading: const Icon(Icons.cloud_upload_outlined),
                              trailing: Text(
                                '${(_projectProgress * 100).round()}%',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              center: Text(
                                'Delivery Pipeline',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              barRadius: const Radius.circular(999),
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              progressColor: Colors.blue,
                              widgetIndicator: _showIndicator
                                  ? const Icon(
                                      Icons.circle,
                                      size: 14,
                                      color: Colors.blue,
                                    )
                                  : null,
                            );
                          },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LinearExampleCard(
                    title: 'Gradient Fill + Gradient Track',
                    description:
                        'The package can style both the progress segment and the background using gradients.',
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                            return LinearPercentIndicator(
                              width: constraints.maxWidth,
                              lineHeight: 18,
                              percent: 0.73,
                              animation: _animate,
                              linearGradient: const LinearGradient(
                                colors: <Color>[
                                  Color(0xFF66BB6A),
                                  Color(0xFF2E7D32),
                                ],
                              ),
                              linearGradientBackgroundColor:
                                  const LinearGradient(
                                    colors: <Color>[
                                      Color(0xFFE8F5E9),
                                      Color(0xFFC8E6C9),
                                    ],
                                  ),
                              center: Text(
                                '73% covered',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              barRadius: const Radius.circular(10),
                              clipLinearGradient: true,
                            );
                          },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LinearExampleCard(
                    title: 'Compact Metric Rows',
                    description:
                        'Short bars work well in dashboards, cards, or list rows with custom padding removed.',
                    child: Column(
                      children: const <Widget>[
                        _MetricRow(
                          label: 'API quota',
                          percent: 0.28,
                          color: Colors.indigo,
                        ),
                        SizedBox(height: 12),
                        _MetricRow(
                          label: 'Sync jobs',
                          percent: 0.51,
                          color: Colors.orange,
                        ),
                        SizedBox(height: 12),
                        _MetricRow(
                          label: 'Release QA',
                          percent: 0.93,
                          color: Colors.teal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '3. Multi-segment Linear Indicator',
              subtitle:
                  'The package also includes a separate multi-segment bar for stacked distribution views. It is useful for capacity breakdowns, budget splits, or status composition.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _rotateSegments,
                        icon: const Icon(Icons.swap_horiz),
                        label: const Text('Rotate Segments'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _normalizeSegments,
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Reset Segments'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _LinearExampleCard(
                    title: 'Stacked Capacity',
                    description:
                        'Each segment has its own percent and color, and can optionally draw stripes.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        LayoutBuilder(
                          builder:
                              (
                                BuildContext context,
                                BoxConstraints constraints,
                              ) {
                                return MultiSegmentLinearIndicator(
                                  width: constraints.maxWidth,
                                  lineHeight: 18,
                                  barRadius: const Radius.circular(999),
                                  animation: _animate,
                                  animationDuration: 900,
                                  segments: <SegmentLinearIndicator>[
                                    SegmentLinearIndicator(
                                      percent: _segmentValues[0],
                                      color: Colors.red,
                                      enableStripes: true,
                                    ),
                                    SegmentLinearIndicator(
                                      percent: _segmentValues[1],
                                      color: Colors.amber,
                                    ),
                                    SegmentLinearIndicator(
                                      percent: _segmentValues[2],
                                      color: Colors.green,
                                      enableStripes: true,
                                    ),
                                  ],
                                );
                              },
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: <Widget>[
                            _LegendChip(
                              color: Colors.red,
                              label:
                                  'Blocked ${(_segmentValues[0] * 100).round()}%',
                            ),
                            _LegendChip(
                              color: Colors.amber,
                              label:
                                  'In review ${(_segmentValues[1] * 100).round()}%',
                            ),
                            _LegendChip(
                              color: Colors.green,
                              label:
                                  'Complete ${(_segmentValues[2] * 100).round()}%',
                            ),
                          ],
                        ),
                      ],
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

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard();

  @override
  Widget build(BuildContext context) {
    return const _SectionCard(
      title: 'Core API Shape',
      subtitle:
          'These snippets mirror the installed package API in this project.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SnippetBlock(
            code:
                'CircularPercentIndicator(\n'
                '  radius: 60,\n'
                '  lineWidth: 8,\n'
                '  percent: 0.72,\n'
                '  center: Text("72%"),\n'
                '  progressColor: Colors.blue,\n'
                ')',
          ),
          SizedBox(height: 12),
          _SnippetBlock(
            code:
                'LinearPercentIndicator(\n'
                '  width: 220,\n'
                '  lineHeight: 18,\n'
                '  percent: 0.55,\n'
                '  center: Text("55%"),\n'
                '  barRadius: Radius.circular(999),\n'
                '  linearGradient: LinearGradient(colors: [...]),\n'
                ')',
          ),
          SizedBox(height: 12),
          _SnippetBlock(
            code:
                'MultiSegmentLinearIndicator(\n'
                '  segments: <SegmentLinearIndicator>[\n'
                '    SegmentLinearIndicator(percent: 0.2, color: Colors.red),\n'
                '    SegmentLinearIndicator(percent: 0.5, color: Colors.orange),\n'
                '    SegmentLinearIndicator(percent: 0.2, color: Colors.green),\n'
                '  ],\n'
                ')',
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
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
            Text(subtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  const _DemoTile({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 6),
          Align(alignment: Alignment.centerLeft, child: Text(subtitle)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _LinearExampleCard extends StatelessWidget {
  const _LinearExampleCard({
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

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.percent,
    required this.color,
  });

  final String label;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 92, child: Text(label)),
        Expanded(
          child: LinearPercentIndicator(
            percent: percent,
            lineHeight: 12,
            padding: EdgeInsets.zero,
            barRadius: const Radius.circular(999),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            progressColor: color,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${(percent * 100).round()}%',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _KeywordChip extends StatelessWidget {
  const _KeywordChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.pie_chart_outline, size: 18),
      label: Text(label),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 8),
      label: Text(label),
    );
  }
}

class _SnippetBlock extends StatelessWidget {
  const _SnippetBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        code,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace', height: 1.45),
      ),
    );
  }
}
