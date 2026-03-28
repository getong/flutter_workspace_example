import 'package:flutter/material.dart';

enum StackLayoutKind { heroCard, mapPins, avatars, statusLayers }

class StackPageSpec {
  const StackPageSpec({
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
  final StackLayoutKind kind;
}

const List<StackPageSpec> stackPages = <StackPageSpec>[
  StackPageSpec(
    slug: 'hero-card',
    title: 'Hero Card Overlay',
    color: Colors.deepOrange,
    icon: Icons.slideshow,
    message: 'Stack overlays labels and actions on top of media.',
    kind: StackLayoutKind.heroCard,
  ),
  StackPageSpec(
    slug: 'map-pins',
    title: 'Map Pins',
    color: Colors.red,
    icon: Icons.location_on,
    message: 'Positioned widgets place markers at exact coordinates.',
    kind: StackLayoutKind.mapPins,
  ),
  StackPageSpec(
    slug: 'avatars',
    title: 'Avatar Cluster',
    color: Colors.indigo,
    icon: Icons.groups,
    message: 'Small offsets create compact overlapping avatar groups.',
    kind: StackLayoutKind.avatars,
  ),
  StackPageSpec(
    slug: 'status-layers',
    title: 'Status Layers',
    color: Colors.teal,
    icon: Icons.layers,
    message: 'Use stacked gradients and highlights to signal state.',
    kind: StackLayoutKind.statusLayers,
  ),
];

StackPageSpec? findStackPage(String slug) {
  for (final StackPageSpec page in stackPages) {
    if (page.slug == slug) {
      return page;
    }
  }
  return null;
}
