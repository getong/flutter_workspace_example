import 'package:flutter/material.dart';

enum LayoutKind {
  row,
  column,
}

class LayoutPageSpec {
  const LayoutPageSpec({
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
  final LayoutKind kind;
}

const List<LayoutPageSpec> layoutPages = <LayoutPageSpec>[
  LayoutPageSpec(
    slug: 'row-rainbow',
    title: 'Row Rainbow',
    color: Colors.orange,
    icon: Icons.palette,
    message: 'Even spacing keeps row content balanced.',
    kind: LayoutKind.row,
  ),
  LayoutPageSpec(
    slug: 'row-chips',
    title: 'Row Chips',
    color: Colors.lightBlue,
    icon: Icons.widgets,
    message: 'A Row can act like a compact command bar.',
    kind: LayoutKind.row,
  ),
  LayoutPageSpec(
    slug: 'column-cards',
    title: 'Column Cards',
    color: Colors.teal,
    icon: Icons.view_agenda,
    message: 'Columns are ideal for stacked content blocks.',
    kind: LayoutKind.column,
  ),
  LayoutPageSpec(
    slug: 'column-dashboard',
    title: 'Column Dashboard',
    color: Colors.purple,
    icon: Icons.dashboard_customize,
    message: 'Mix Expanded widgets to create dashboard sections.',
    kind: LayoutKind.column,
  ),
];

LayoutPageSpec? findLayoutPage(String slug) {
  for (final LayoutPageSpec page in layoutPages) {
    if (page.slug == slug) {
      return page;
    }
  }
  return null;
}
