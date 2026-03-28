import 'package:flutter/material.dart';

enum GridKind { fixedCount, extentBased }

class GridPageSpec {
  const GridPageSpec({
    required this.slug,
    required this.title,
    required this.color,
    required this.icon,
    required this.message,
    required this.kind,
  });

  final String slug;
  final String title;
  final Color color;
  final IconData icon;
  final String message;
  final GridKind kind;
}

const List<GridPageSpec> gridPages = <GridPageSpec>[
  GridPageSpec(
    slug: 'photo-board',
    title: 'Photo Board',
    color: Colors.orange,
    icon: Icons.photo_library_outlined,
    message: 'Fixed column count keeps a stable visual rhythm.',
    kind: GridKind.fixedCount,
  ),
  GridPageSpec(
    slug: 'shop-catalog',
    title: 'Shop Catalog',
    color: Colors.lightBlue,
    icon: Icons.shopping_bag_outlined,
    message: 'Grid cards help scan multiple products quickly.',
    kind: GridKind.fixedCount,
  ),
  GridPageSpec(
    slug: 'adaptive-tools',
    title: 'Adaptive Tools',
    color: Colors.teal,
    icon: Icons.build_outlined,
    message: 'Extent-based grids adapt tile count to available width.',
    kind: GridKind.extentBased,
  ),
  GridPageSpec(
    slug: 'analytics-overview',
    title: 'Analytics Overview',
    color: Colors.indigo,
    icon: Icons.analytics_outlined,
    message: 'Dense dashboards often start from extent grid layouts.',
    kind: GridKind.extentBased,
  ),
];

GridPageSpec? findGridPage(String slug) {
  for (final GridPageSpec page in gridPages) {
    if (page.slug == slug) {
      return page;
    }
  }
  return null;
}
