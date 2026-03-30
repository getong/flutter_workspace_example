import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../demo_catalog.dart';
import '../widgets/demo_page_scaffold.dart';

class ShowcaseListPage extends StatelessWidget {
  const ShowcaseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);
    return DemoPageScaffold(
      eyebrow: 'Catalog',
      title: 'Layout Example Pages',
      description:
          'Each detail page is resolved from a local spec list, similar to the '
          'slug-driven layout routes in flutter_row_example. The difference here '
          'is the app shell and the shadcn_ui presentation layer.',
      actions: <Widget>[
        ShadButton(
          onPressed: () => context.go('/layouts/${showcaseSpecs.first.slug}'),
          child: const Text('Open First Slug'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ShadCard(
            title: const Text('Route pattern'),
            description: const Text(
              'The list page stays static, while the detail page is resolved from '
              'a slug in the URL.',
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text('Home route: /'),
                  SizedBox(height: 8),
                  Text('Catalog route: /examples'),
                  SizedBox(height: 8),
                  Text('Detail route: /layouts/:slug'),
                  SizedBox(height: 8),
                  Text('Settings route: /settings'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          for (final ShowcaseKind kind in ShowcaseKind.values) ...<Widget>[
            Text('${kind.label} pages', style: theme.textTheme.h3),
            const SizedBox(height: 12),
            _ShowcaseSection(specs: showcasesByKind(kind)),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}

class _ShowcaseSection extends StatelessWidget {
  const _ShowcaseSection({required this.specs});

  final List<ShowcaseSpec> specs;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double cardWidth = constraints.maxWidth >= 960
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: specs
              .map(
                (ShowcaseSpec spec) => SizedBox(
                  width: cardWidth,
                  child: _ShowcaseCard(spec: spec),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _ShowcaseCard extends StatelessWidget {
  const _ShowcaseCard({required this.spec});

  final ShowcaseSpec spec;

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);
    return ShadCard(
      title: Text(spec.title),
      description: Text(spec.summary),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('/layouts/${spec.slug}', style: theme.textTheme.small),
          ShadButton.secondary(
            onPressed: () => context.go('/layouts/${spec.slug}'),
            child: const Text('View'),
          ),
        ],
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
                  .map((String tag) => ShadBadge.outline(child: Text(tag)))
                  .toList(growable: false),
            ),
            const SizedBox(height: 16),
            ...spec.highlights.map(
              (String line) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(spec.icon, size: 16, color: spec.accent),
                    const SizedBox(width: 8),
                    Expanded(child: Text(line, style: theme.textTheme.p)),
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
