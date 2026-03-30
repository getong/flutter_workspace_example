import 'package:flutter/material.dart';

class DemoSpec {
  const DemoSpec({
    required this.slug,
    required this.title,
    required this.summary,
    required this.description,
    required this.routeLabel,
    required this.progress,
    required this.accent,
    required this.icon,
    required this.tags,
    required this.highlights,
  });

  final String slug;
  final String title;
  final String summary;
  final String description;
  final String routeLabel;
  final double progress;
  final Color accent;
  final IconData icon;
  final List<String> tags;
  final List<String> highlights;
}

const List<DemoSpec> demoCatalog = <DemoSpec>[
  DemoSpec(
    slug: 'launch-brief',
    title: 'Launch Brief',
    summary:
        'A compact landing page that routes from overview into a focused detail screen.',
    description:
        'This route demonstrates a high-signal hero card, quick actions, and a detail flow that stays readable on both mobile and desktop.',
    routeLabel: '/catalog/launch-brief',
    progress: 0.82,
    accent: Colors.orange,
    icon: Icons.rocket_launch_outlined,
    tags: <String>['Hero', 'CTA', 'Router'],
    highlights: <String>[
      'A clear entry point from the dashboard.',
      'Primary and secondary actions built with Forui buttons.',
      'A dynamic route that mirrors the reference project pattern.',
    ],
  ),
  DemoSpec(
    slug: 'analytics-stack',
    title: 'Analytics Stack',
    summary:
        'A data-focused screen with grouped actions, status badges, and progress states.',
    description:
        'Use this route as a template for internal tools, review dashboards, or any workflow that needs fast scanning and meaningful hierarchy.',
    routeLabel: '/catalog/analytics-stack',
    progress: 0.64,
    accent: Colors.teal,
    icon: Icons.stacked_bar_chart_outlined,
    tags: <String>['Cards', 'Status', 'Metrics'],
    highlights: <String>[
      'Cards provide density without looking cramped.',
      'Tiles create a route catalog that reads cleanly on touch devices.',
      'Progress widgets make asynchronous states easy to visualize.',
    ],
  ),
  DemoSpec(
    slug: 'workspace-profile',
    title: 'Workspace Profile',
    summary:
        'A simple settings-style page with text fields and preference controls.',
    description:
        'This route is designed for account pages, workspace preferences, and onboarding forms that need more polish than the default Material template.',
    routeLabel: '/catalog/workspace-profile',
    progress: 0.48,
    accent: Colors.indigo,
    icon: Icons.manage_accounts_outlined,
    tags: <String>['Forms', 'Preferences', 'Profile'],
    highlights: <String>[
      'Managed Forui text fields for common form use cases.',
      'Touch-friendly switches and checkboxes.',
      'Easy to extend into a full account or workspace setup flow.',
    ],
  ),
];

DemoSpec? findDemo(String slug) {
  for (final DemoSpec demo in demoCatalog) {
    if (demo.slug == slug) {
      return demo;
    }
  }

  return null;
}
