import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'stack_catalog.dart';

class StackHomePage extends StatelessWidget {
  const StackHomePage({super.key});

  static const List<_RouteSpec> _demoRoutes = <_RouteSpec>[
    _RouteSpec(
      path: '/stack_basics',
      title: 'Stack Basics',
      icon: Icons.layers_outlined,
    ),
    _RouteSpec(
      path: '/stack_alignment',
      title: 'Stack Alignment',
      icon: Icons.center_focus_strong,
    ),
    _RouteSpec(
      path: '/stack_positioned',
      title: 'Stack Positioned',
      icon: Icons.filter_center_focus,
    ),
    _RouteSpec(
      path: '/stack_layers_module',
      title: 'Stack Layers Module',
      icon: Icons.layers,
    ),
    _RouteSpec(
      path: '/stack_badge_module',
      title: 'Stack Badge Module',
      icon: Icons.notifications_active,
    ),
    _RouteSpec(
      path: '/stack_interactive_module',
      title: 'Stack Interactive Module',
      icon: Icons.touch_app,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Stack Examples')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _demoRoutes.length + stackPages.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) {
          if (index < _demoRoutes.length) {
            final _RouteSpec route = _demoRoutes[index];
            return Card(
              child: ListTile(
                leading: Icon(route.icon),
                title: Text(route.title),
                subtitle: Text(route.path),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.go(route.path),
              ),
            );
          }

          final StackPageSpec page = stackPages[index - _demoRoutes.length];
          return Card(
            child: ListTile(
              leading: Icon(page.icon),
              title: Text(page.title),
              subtitle: Text('/layouts/${page.slug}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.go('/layouts/${page.slug}'),
            ),
          );
        },
      ),
    );
  }
}

class _RouteSpec {
  const _RouteSpec({
    required this.path,
    required this.title,
    required this.icon,
  });

  final String path;
  final String title;
  final IconData icon;
}
