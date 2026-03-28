import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'grid_catalog.dart';

class GridHomePage extends StatelessWidget {
  const GridHomePage({super.key});

  static const List<_RouteSpec> _demoRoutes = <_RouteSpec>[
    _RouteSpec(
      path: '/grid_basics',
      title: 'Grid Basics',
      icon: Icons.grid_4x4,
    ),
    _RouteSpec(
      path: '/grid_builder',
      title: 'Grid Builder',
      icon: Icons.grid_view,
    ),
    _RouteSpec(
      path: '/grid_extent',
      title: 'Grid Extent',
      icon: Icons.view_module,
    ),
    _RouteSpec(
      path: '/grid_interactive_module',
      title: 'Grid Interactive Module',
      icon: Icons.touch_app,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter GridView')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _demoRoutes.length + gridPages.length,
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

          final GridPageSpec page = gridPages[index - _demoRoutes.length];
          return Card(
            child: ListTile(
              leading: Icon(page.icon),
              title: Text(page.title),
              subtitle: Text('/grids/${page.slug}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.go('/grids/${page.slug}'),
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
