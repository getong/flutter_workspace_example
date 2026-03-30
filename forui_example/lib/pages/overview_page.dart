import 'package:flutter/material.dart';

import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../catalog/demo_catalog.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: <Widget>[
        FCard(
          title: const Text('Router-first Forui example'),
          subtitle: const Text(
            'This app mirrors the reference project structure, but swaps the default Flutter template for a routed Forui interface.',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  FBadge(child: const Text('go_router')),
                  FBadge(variant: .secondary, child: const Text('forui')),
                  FBadge(variant: .outline, child: const Text('Multi-page')),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Use the bottom navigation to switch between root pages, then open any catalog item to inspect a dynamic detail route.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FButton(
                    onPress: () => context.go('/catalog'),
                    child: const Text('Open Catalog'),
                  ),
                  FButton(
                    variant: .secondary,
                    onPress: () =>
                        context.go('/catalog/${demoCatalog.first.slug}'),
                    child: const Text('Open First Detail'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Featured Routes', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: demoCatalog
              .map(
                (DemoSpec demo) =>
                    SizedBox(width: 320, child: _OverviewCard(demo: demo)),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.demo});

  final DemoSpec demo;

  @override
  Widget build(BuildContext context) {
    return FCard(
      title: Text(demo.title),
      subtitle: Text(demo.summary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: demo.tags
                .map(
                  (String tag) => FBadge(variant: .secondary, child: Text(tag)),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(demo.routeLabel),
          const SizedBox(height: 12),
          FDeterminateProgress(value: demo.progress),
          const SizedBox(height: 12),
          Text(
            '${(demo.progress * 100).round()}% of the UI story is mocked out.',
          ),
          const SizedBox(height: 16),
          FButton(
            variant: .outline,
            onPress: () => context.go('/catalog/${demo.slug}'),
            child: const Text('Inspect Route'),
          ),
        ],
      ),
    );
  }
}
