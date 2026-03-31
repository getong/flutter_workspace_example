import 'package:flutter/material.dart';

import '../app_router.dart';
import 'listview_catalog.dart';

class ListViewHomePage extends StatelessWidget {
  const ListViewHomePage({super.key});

  static const List<_RouteSpec> _listViewRoutes = <_RouteSpec>[
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

  static const List<_RouteSpec> _keyRoutes = <_RouteSpec>[
    _RouteSpec(
      path: AppRoutes.uniqueKeyDemo,
      title: 'UniqueKey List',
      icon: Icons.fingerprint,
    ),
    _RouteSpec(
      path: AppRoutes.valueKeyDemo,
      title: 'ValueKey Todo List',
      icon: Icons.checklist_rtl,
    ),
    _RouteSpec(
      path: AppRoutes.objectKeyDemo,
      title: 'ObjectKey Product List',
      icon: Icons.inventory_2_outlined,
    ),
    _RouteSpec(
      path: AppRoutes.globalKeyDemo,
      title: 'GlobalKey Form',
      icon: Icons.assignment_turned_in_outlined,
    ),
    _RouteSpec(
      path: AppRoutes.pageStorageKeyDemo,
      title: 'PageStorageKey News List',
      icon: Icons.save_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter ListView')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _SectionHeader(
            title: 'ListView Demos',
            subtitle: 'Core scrolling and layout patterns.',
          ),
          const SizedBox(height: 12),
          ..._listViewRoutes.map(
            (_RouteSpec route) => _buildRouteCard(context, route),
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Key Demos',
            subtitle:
                'Examples using UniqueKey, ValueKey, ObjectKey, '
                'GlobalKey, and PageStorageKey.',
          ),
          const SizedBox(height: 12),
          ..._keyRoutes.map(
            (_RouteSpec route) => _buildRouteCard(context, route),
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Dynamic Showcase',
            subtitle: 'Sample pages opened through slug-based routes.',
          ),
          const SizedBox(height: 12),
          ...listViewPages.map(
            (ListViewPageSpec page) => _buildShowcaseCard(context, page),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context, _RouteSpec route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: Icon(route.icon),
          title: Text(route.title),
          subtitle: Text(route.path),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => Navigator.of(context).pushNamed(route.path),
        ),
      ),
    );
  }

  Widget _buildShowcaseCard(BuildContext context, ListViewPageSpec page) {
    final String path = '${AppRoutes.showcasePrefix}/${page.slug}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: Icon(page.icon),
          title: Text(page.title),
          subtitle: Text(path),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => Navigator.of(context).pushNamed(path),
        ),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
