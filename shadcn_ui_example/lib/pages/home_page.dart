import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../demo_catalog.dart';
import '../widgets/demo_page_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);
    return DemoPageScaffold(
      eyebrow: 'Read from flutter_row_example',
      title: 'GoRouter + shadcn_ui',
      description:
          'This sample keeps the catalog/detail idea from the source project, '
          'but rebuilds it as a multi-page shadcn_ui app with a shared shell, '
          'dynamic slug routes, and a small settings playground.',
      actions: <Widget>[
        ShadButton(
          onPressed: () => context.go('/examples'),
          child: const Text('Browse Examples'),
        ),
        ShadButton.secondary(
          onPressed: () => context.go('/settings'),
          child: const Text('Open Settings'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ShadCard(
            title: const Text('Source pattern, upgraded shell'),
            description: const Text(
              'The original project listed row and column demos plus a slug-based '
              'detail page. This version keeps that routing idea and adds a richer '
              'navigation shell around it.',
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const <Widget>[
                      ShadBadge(child: Text('/')),
                      ShadBadge.secondary(child: Text('/examples')),
                      ShadBadge.outline(child: Text('/layouts/:slug')),
                      ShadBadge.secondary(child: Text('/settings')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: theme.colorScheme.border),
                    ),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.spaceBetween,
                      children: <Widget>[
                        _HeroMetric(
                          label: 'Pages',
                          value: '4',
                          tone: theme.colorScheme.primary,
                        ),
                        _HeroMetric(
                          label: 'Dynamic Routes',
                          value: '4',
                          tone: theme.colorScheme.accent,
                        ),
                        _HeroMetric(
                          label: 'UI Toolkit',
                          value: 'shadcn_ui',
                          tone: theme.colorScheme.foreground,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Featured examples', style: theme.textTheme.h3),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double cardWidth = constraints.maxWidth >= 900
                  ? (constraints.maxWidth - 16) / 2
                  : constraints.maxWidth;
              final List<ShowcaseSpec> featured = <ShowcaseSpec>[
                showcaseSpecs.first,
                showcaseSpecs.last,
              ];
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: featured
                    .map(
                      (ShowcaseSpec spec) => SizedBox(
                        width: cardWidth,
                        child: _FeaturedCard(spec: spec),
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 180),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(150),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tone.withAlpha(70)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: theme.textTheme.small),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.h4),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.spec});

  final ShowcaseSpec spec;

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);
    return ShadCard(
      title: Text(spec.title),
      description: Text(spec.summary),
      footer: Align(
        alignment: Alignment.centerLeft,
        child: ShadButton.outline(
          onPressed: () => context.go('/layouts/${spec.slug}'),
          child: const Text('Open Detail'),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: spec.tags
                  .map((String tag) => ShadBadge.secondary(child: Text(tag)))
                  .toList(growable: false),
            ),
            const SizedBox(height: 16),
            Text(spec.message, style: theme.textTheme.p),
            const SizedBox(height: 16),
            ShadProgress(value: spec.readiness),
          ],
        ),
      ),
    );
  }
}
