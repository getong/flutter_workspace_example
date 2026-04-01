import 'package:flutter/material.dart';

class ProviderDemoSpec {
  const ProviderDemoSpec({
    required this.slug,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String slug;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
}

const List<ProviderDemoSpec> providerDemos = <ProviderDemoSpec>[
  ProviderDemoSpec(
    slug: 'counter-dashboard',
    title: 'Counter Dashboard',
    subtitle: 'context.watch + context.read',
    description: 'A small counter view where every widget is stateless and the '
        'ChangeNotifier owns all mutations.',
    icon: Icons.add_chart,
    color: Colors.teal,
  ),
  ProviderDemoSpec(
    slug: 'team-scoreboard',
    title: 'Team Scoreboard',
    subtitle: 'Selector for derived values',
    description:
        'Two score panels update live while a selector keeps the total '
        'points badge isolated.',
    icon: Icons.sports_basketball,
    color: Colors.orange,
  ),
  ProviderDemoSpec(
    slug: 'study-plan',
    title: 'Study Plan',
    subtitle: 'Consumer for focused rebuilds',
    description:
        'A lesson tracker with focus mode, progress, and stateless controls '
        'driven by provider.',
    icon: Icons.menu_book,
    color: Colors.indigo,
  ),
];

ProviderDemoSpec? findProviderDemo(String slug) {
  for (final ProviderDemoSpec demo in providerDemos) {
    if (demo.slug == slug) {
      return demo;
    }
  }
  return null;
}
