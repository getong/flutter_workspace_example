import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'row_column_catalog.dart';

class RowColumnHomePage extends StatelessWidget {
  const RowColumnHomePage({super.key});

  static const List<_RouteSpec> _demoRoutes = <_RouteSpec>[
    _RouteSpec(
      path: '/row_basics',
      title: 'Row Basics',
      icon: Icons.view_week,
    ),
    _RouteSpec(
      path: '/row_alignment',
      title: 'Row Alignment',
      icon: Icons.align_horizontal_center,
    ),
    _RouteSpec(
      path: '/row_expanded',
      title: 'Row Expanded/Flex',
      icon: Icons.space_bar,
    ),
    _RouteSpec(
      path: '/row_boxes_module',
      title: 'Row Boxes Module',
      icon: Icons.view_array,
    ),
    _RouteSpec(
      path: '/row_center_stretch_module',
      title: 'Row Center Stretch Module',
      icon: Icons.vertical_align_center,
    ),
    _RouteSpec(
      path: '/column_basics',
      title: 'Column Basics',
      icon: Icons.view_stream,
    ),
    _RouteSpec(
      path: '/column_alignment',
      title: 'Column Alignment',
      icon: Icons.align_vertical_center,
    ),
    _RouteSpec(
      path: '/column_nested',
      title: 'Column Nested Layout',
      icon: Icons.dashboard,
    ),
    _RouteSpec(
      path: '/column_boxes_module',
      title: 'Column Boxes Module',
      icon: Icons.gradient,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Row + Column'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _demoRoutes.length + layoutPages.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
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

          final LayoutPageSpec page = layoutPages[index - _demoRoutes.length];
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
