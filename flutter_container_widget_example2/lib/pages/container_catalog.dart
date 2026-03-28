import 'package:flutter/material.dart';

class ContainerPageSpec {
  const ContainerPageSpec({
    required this.slug,
    required this.title,
    required this.color,
    required this.icon,
    required this.message,
  });

  final String slug;
  final String title;
  final Color color;
  final IconData icon;
  final String message;
}

const List<ContainerPageSpec> containerPages = <ContainerPageSpec>[
  ContainerPageSpec(
    slug: 'light-blue',
    title: 'Light Blue Container',
    color: Colors.lightBlue,
    icon: Icons.water_drop,
    message: 'Oh, it is cold outside...',
  ),
  ContainerPageSpec(
    slug: 'indigo',
    title: 'Indigo Container',
    color: Colors.indigo,
    icon: Icons.nightlight_round,
    message: 'Deep indigo theme selected.',
  ),
  ContainerPageSpec(
    slug: 'amber',
    title: 'Amber Container',
    color: Colors.amber,
    icon: Icons.wb_sunny,
    message: 'Warm amber page selected.',
  ),
];

ContainerPageSpec? findContainerPage(String slug) {
  for (final ContainerPageSpec page in containerPages) {
    if (page.slug == slug) {
      return page;
    }
  }
  return null;
}
