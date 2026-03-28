import 'package:flutter/material.dart';

import '../app_router.dart';
import 'listview_catalog.dart';

class ListViewHomePage extends StatelessWidget {
  const ListViewHomePage({super.key});

  static const List<_RouteSpec> _demoRoutes = <_RouteSpec>[
    _RouteSpec(
      path: AppRoutes.listViewBasics,
      title: 'ListView Basics',
      icon: Icons.format_list_bulleted,
    ),
    _RouteSpec(
      path: AppRoutes.listViewBuilder,
      title: 'ListView.builder',
      icon: Icons.dynamic_feed,
    ),
    _RouteSpec(
      path: AppRoutes.listViewSeparated,
      title: 'ListView.separated',
      icon: Icons.view_day_outlined,
    ),
    _RouteSpec(
      path: AppRoutes.listViewHorizontal,
      title: 'Horizontal ListView',
      icon: Icons.view_carousel_outlined,
    ),
    _RouteSpec(
      path: AppRoutes.listViewInteractive,
      title: 'Interactive ListView',
      icon: Icons.touch_app_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter ListView')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _demoRoutes.length + listViewPages.length,
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
                onTap: () => Navigator.of(context).pushNamed(route.path),
              ),
            );
          }

          final ListViewPageSpec page =
              listViewPages[index - _demoRoutes.length];
          final String path = '${AppRoutes.showcasePrefix}/${page.slug}';
          return Card(
            child: ListTile(
              leading: Icon(page.icon),
              title: Text(page.title),
              subtitle: Text(path),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.of(context).pushNamed(path),
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
