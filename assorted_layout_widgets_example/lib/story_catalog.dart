import 'package:flutter/material.dart';

class StorySpec {
  const StorySpec({
    required this.slug,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String slug;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

const List<StorySpec> storySpecs = <StorySpec>[
  StorySpec(
    slug: 'release-dashboard',
    title: 'Release Dashboard',
    subtitle: 'A compact command center mixing SideBySide, Box and RowSuper.',
    icon: Icons.dashboard_customize_outlined,
    color: Color(0xFF0F766E),
  ),
  StorySpec(
    slug: 'message-composer',
    title: 'Message Composer',
    subtitle: 'Responsive metadata rows and shrinking copy for tight spaces.',
    icon: Icons.chat_bubble_outline,
    color: Color(0xFFB45309),
  ),
  StorySpec(
    slug: 'delivery-timeline',
    title: 'Delivery Timeline',
    subtitle: 'Stacked milestone cards built with ColumnSuper overlaps.',
    icon: Icons.timeline,
    color: Color(0xFF7C3AED),
  ),
];

StorySpec? findStoryBySlug(String slug) {
  for (final StorySpec story in storySpecs) {
    if (story.slug == slug) {
      return story;
    }
  }

  return null;
}
