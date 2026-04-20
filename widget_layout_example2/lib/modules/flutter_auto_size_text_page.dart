import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';

@RoutePage()
class FlutterAutoSizeTextPage extends StatefulWidget {
  const FlutterAutoSizeTextPage({super.key});

  @override
  State<FlutterAutoSizeTextPage> createState() =>
      _FlutterAutoSizeTextPageState();
}

class _FlutterAutoSizeTextPageState extends State<FlutterAutoSizeTextPage> {
  final AutoSizeGroup _headlineGroup = AutoSizeGroup();
  final AutoSizeGroup _metricGroup = AutoSizeGroup();

  double _previewWidth = 220;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_auto_size_text Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Make text shrink intelligently when space is limited.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `AutoSizeText`, `AutoSizeText.rich`, '
              '`AutoSizeGroup`, `presetFontSizes`, `minFontSize`, '
              '`stepGranularity`, `overflowReplacement`, and `wrapWords`.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Interactive Width Preview',
              description:
                  'Resize the demo area to see how different AutoSizeText '
                  'settings adapt under tighter constraints.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Preview width: ${_previewWidth.round()} px',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Slider(
                    value: _previewWidth,
                    min: 140,
                    max: 340,
                    divisions: 20,
                    label: '${_previewWidth.round()} px',
                    onChanged: (double value) {
                      setState(() {
                        _previewWidth = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: _previewWidth,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.45,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            'Quarterly Product Revenue Overview',
                            maxLines: 2,
                            minFontSize: 16,
                            stepGranularity: 1,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          AutoSizeText(
                            'A concise supporting summary that keeps the '
                            'layout stable even on narrow cards.',
                            maxLines: 3,
                            minFontSize: 12,
                            maxFontSize:
                                theme.textTheme.bodyLarge?.fontSize ?? 16,
                            stepGranularity: 0.5,
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 12),
                          AutoSizeText(
                            'Enterprise analytics dashboard rollout in '
                            'progress',
                            maxLines: 1,
                            minFontSize: 11,
                            overflowReplacement: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Tap for full title',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
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
              title: 'AutoSizeGroup For Consistent Grids',
              description:
                  'Group related text so cards with different copy lengths '
                  'still render with aligned typography.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _FeatureStatCard(
                    title: 'Monthly Active Teams',
                    metric: '12,480',
                    accentColor: const Color(0xFF0F766E),
                    headlineGroup: _headlineGroup,
                    metricGroup: _metricGroup,
                  ),
                  _FeatureStatCard(
                    title: 'Conversion Rate Improvement',
                    metric: '18.6%',
                    accentColor: const Color(0xFFC2410C),
                    headlineGroup: _headlineGroup,
                    metricGroup: _metricGroup,
                  ),
                  _FeatureStatCard(
                    title: 'Support Tickets Resolved This Week',
                    metric: '842',
                    accentColor: const Color(0xFF7C3AED),
                    headlineGroup: _headlineGroup,
                    metricGroup: _metricGroup,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Preset Sizes And Rich Text',
              description:
                  'Preset size steps help preserve a type scale, while rich '
                  'text keeps emphasis and inline styling.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: <Widget>[
                      _AutoTextDemoTile(
                        title: 'presetFontSizes',
                        subtitle:
                            'Instead of shrinking one pixel at a time, use a '
                            'curated list of brand-approved sizes.',
                        child: Container(
                          width: 220,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111827),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const AutoSizeText(
                            'Design System Release Notes',
                            maxLines: 2,
                            presetFontSizes: <double>[28, 24, 20, 18, 16],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                      _AutoTextDemoTile(
                        title: 'AutoSizeText.rich',
                        subtitle:
                            'Rich spans can scale together while preserving '
                            'bold, color, and emphasis.',
                        child: Container(
                          width: 220,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: <Color>[
                                Color(0xFFFFF7ED),
                                Color(0xFFFFEDD5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: AutoSizeText.rich(
                            TextSpan(
                              style: theme.textTheme.titleLarge?.copyWith(
                                height: 1.15,
                              ),
                              children: <InlineSpan>[
                                const TextSpan(text: 'Ship '),
                                TextSpan(
                                  text: 'faster',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const TextSpan(text: ' with '),
                                const TextSpan(
                                  text: 'responsive',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                const TextSpan(text: ' typography.'),
                              ],
                            ),
                            maxLines: 3,
                            minFontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withValues(
                        alpha: 0.55,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Long tokens and codes',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.72),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const AutoSizeText(
                                  'SKU-ENTERPRISE-ANALYTICS-2026-PREMIUM',
                                  maxLines: 1,
                                  minFontSize: 9,
                                  wrapWords: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.72),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const AutoSizeText(
                                  'SKU ENTERPRISE ANALYTICS 2026 PREMIUM',
                                  maxLines: 2,
                                  minFontSize: 10,
                                  style: TextStyle(fontWeight: FontWeight.w700),
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            height: 1.5,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('AutoSizeText('),
              Text("  'Responsive title',"),
              Text('  maxLines: 2,'),
              Text('  minFontSize: 14,'),
              Text('  stepGranularity: 1,'),
              Text(')'),
              SizedBox(height: 8),
              Text('AutoSizeText.rich('),
              Text('  TextSpan(children: <InlineSpan>[...]),'),
              Text('  presetFontSizes: <double>[24, 20, 18, 16],'),
              Text(')'),
            ],
          ),
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

class _AutoTextDemoTile extends StatelessWidget {
  const _AutoTextDemoTile({
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
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
          const SizedBox(height: 16),
          Center(child: child),
        ],
      ),
    );
  }
}

class _FeatureStatCard extends StatelessWidget {
  const _FeatureStatCard({
    required this.title,
    required this.metric,
    required this.accentColor,
    required this.headlineGroup,
    required this.metricGroup,
  });

  final String title;
  final String metric;
  final Color accentColor;
  final AutoSizeGroup headlineGroup;
  final AutoSizeGroup metricGroup;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.insights_outlined, color: accentColor),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 48,
            child: AutoSizeText(
              title,
              group: headlineGroup,
              maxLines: 2,
              minFontSize: 13,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: AutoSizeText(
              metric,
              group: metricGroup,
              maxLines: 1,
              minFontSize: 20,
              presetFontSizes: const <double>[34, 30, 26, 22, 20],
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Grouped text stays visually aligned across cards.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
