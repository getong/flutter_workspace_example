import 'package:flutter/material.dart';

enum TransformKind { rotate, scale, translate, skew, matrix }

class TransformPageSpec {
  const TransformPageSpec({
    required this.slug,
    required this.title,
    required this.icon,
    required this.color,
    required this.message,
    required this.kind,
  });

  final String slug;
  final String title;
  final IconData icon;
  final Color color;
  final String message;
  final TransformKind kind;
}

const List<TransformPageSpec> transformPages = <TransformPageSpec>[
  TransformPageSpec(
    slug: 'rotate',
    title: 'Transform.rotate',
    icon: Icons.rotate_right,
    color: Colors.deepOrange,
    message: 'Rotate widgets around an alignment point.',
    kind: TransformKind.rotate,
  ),
  TransformPageSpec(
    slug: 'scale',
    title: 'Transform.scale',
    icon: Icons.zoom_out_map,
    color: Colors.green,
    message: 'Scale up and down while preserving layout constraints.',
    kind: TransformKind.scale,
  ),
  TransformPageSpec(
    slug: 'translate',
    title: 'Transform.translate',
    icon: Icons.open_with,
    color: Colors.blue,
    message: 'Move painted content without changing original layout size.',
    kind: TransformKind.translate,
  ),
  TransformPageSpec(
    slug: 'skew',
    title: 'Transform (Skew)',
    icon: Icons.panorama_horizontal_select,
    color: Colors.purple,
    message: 'Use Matrix4 skew transforms for slanted UI effects.',
    kind: TransformKind.skew,
  ),
  TransformPageSpec(
    slug: 'matrix4',
    title: 'Transform with Matrix4',
    icon: Icons.view_in_ar,
    color: Colors.teal,
    message: 'Combine perspective, rotation, and translation in one matrix.',
    kind: TransformKind.matrix,
  ),
];

TransformPageSpec? findTransformPage(String slug) {
  for (final TransformPageSpec page in transformPages) {
    if (page.slug == slug) {
      return page;
    }
  }
  return null;
}
