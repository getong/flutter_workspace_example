import 'package:flutter/material.dart';

class DemoRecipe {
  const DemoRecipe({
    required this.slug,
    required this.title,
    required this.summary,
    required this.routeLabel,
    required this.icon,
    required this.accent,
    required this.highlights,
    required this.message,
  });

  final String slug;
  final String title;
  final String summary;
  final String routeLabel;
  final IconData icon;
  final Color accent;
  final List<String> highlights;
  final String message;
}

const List<DemoRecipe> demoRecipes = <DemoRecipe>[
  DemoRecipe(
    slug: 'starter-kit',
    title: 'Starter Kit',
    summary: 'Home dashboard, quick actions, and compact info cards.',
    routeLabel: '/recipes/starter-kit',
    icon: Icons.rocket_launch_outlined,
    accent: Color(0xFF0F766E),
    highlights: <String>['Hero section', 'Quick stats', 'Action row'],
    message: 'Starter Kit combines a polished landing page with fast actions.',
  ),
  DemoRecipe(
    slug: 'team-handoff',
    title: 'Team Handoff',
    summary: 'Useful for PM or ops flows with tasks, owners, and states.',
    routeLabel: '/recipes/team-handoff',
    icon: Icons.groups_2_outlined,
    accent: Color(0xFF1D4ED8),
    highlights: <String>['Owner list', 'Status chips', 'Shared notes'],
    message: 'Team Handoff is suited to shared operational screens.',
  ),
  DemoRecipe(
    slug: 'launch-plan',
    title: 'Launch Plan',
    summary: 'A release checklist page with milestones and routing shortcuts.',
    routeLabel: '/recipes/launch-plan',
    icon: Icons.event_available_outlined,
    accent: Color(0xFFB45309),
    highlights: <String>['Timeline', 'Checklist', 'CTA footer'],
    message: 'Launch Plan keeps milestone content readable across pages.',
  ),
];

DemoRecipe? findDemoRecipe(String slug) {
  for (final DemoRecipe recipe in demoRecipes) {
    if (recipe.slug == slug) {
      return recipe;
    }
  }

  return null;
}
