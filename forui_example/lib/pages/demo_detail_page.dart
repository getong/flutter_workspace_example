import 'package:flutter/material.dart';

import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../catalog/demo_catalog.dart';

class DemoDetailPage extends StatelessWidget {
  const DemoDetailPage({required this.demo, super.key});

  final DemoSpec demo;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return FScaffold(
      header: FHeader.nested(
        title: Text(demo.title),
        prefixes: <Widget>[
          FHeaderAction.back(onPress: () => context.go('/catalog')),
        ],
        suffixes: <Widget>[
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: () => context.go('/profile'),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: <Widget>[
          FCard(
            title: const Text('Dynamic Route'),
            subtitle: Text(demo.routeLabel),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(demo.description, style: textTheme.bodyLarge),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: demo.tags
                      .map((String tag) => FBadge(child: Text(tag)))
                      .toList(),
                ),
                const SizedBox(height: 16),
                FDeterminateProgress(value: demo.progress),
                const SizedBox(height: 12),
                const FProgress(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FTileGroup(
            label: const Text('Why this route exists'),
            description: const Text(
              'These bullets are driven by catalog data and rendered on a dedicated page.',
            ),
            children: demo.highlights
                .map(
                  (String line) => FTile(
                    prefix: Icon(demo.icon, color: demo.accent),
                    title: Text(line),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FButton(
                onPress: () => context.go('/catalog'),
                child: const Text('Back to Catalog'),
              ),
              FButton(
                variant: .secondary,
                onPress: () => context.go('/profile'),
                child: const Text('Open Profile Example'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
