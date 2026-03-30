import 'package:flutter/material.dart';

import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../catalog/demo_catalog.dart';

class ComponentsPage extends StatelessWidget {
  const ComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: <Widget>[
        FCard(
          title: const Text('Catalog Pattern'),
          subtitle: const Text(
            'Like the reference app, this page combines a static list with a dynamic route per item.',
          ),
          child: Text(
            'Each tile navigates to `/catalog/:slug`, which keeps the router readable while still letting the page content come from a shared catalog.',
            style: textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 20),
        FTileGroup(
          label: const Text('Available Demo Pages'),
          description: const Text(
            'Tap any tile to push a detail page driven by a path parameter.',
          ),
          children: demoCatalog
              .map(
                (DemoSpec demo) => FTile(
                  prefix: Icon(demo.icon, color: demo.accent),
                  title: Text(demo.title),
                  subtitle: Text(demo.summary),
                  details: FBadge(
                    variant: .outline,
                    child: Text('${(demo.progress * 100).round()}%'),
                  ),
                  suffix: const Icon(Icons.chevron_right),
                  onPress: () => context.go('/catalog/${demo.slug}'),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
