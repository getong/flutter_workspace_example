import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../widgets/demo_page_scaffold.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    return DemoPageScaffold(
      eyebrow: '404',
      title: 'Route not found',
      description:
          'The requested path does not match one of the example routes in this app.',
      actions: <Widget>[
        ShadButton(
          onPressed: () => context.go('/'),
          child: const Text('Go Home'),
        ),
      ],
      child: ShadCard(
        title: const Text('Missing path'),
        description: const Text(
          'This is the fallback page used by the router and invalid layout slugs.',
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ShadBadge.destructive(child: Text(path)),
        ),
      ),
    );
  }
}
