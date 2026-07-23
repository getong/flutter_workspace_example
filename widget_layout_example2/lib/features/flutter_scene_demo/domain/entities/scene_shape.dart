import 'dart:ui' show Color;

/// The primitive geometry a [SceneShape] is built from.
enum SceneShapeKind { cube, sphere }

/// Describes one object in the flutter_scene demo scene.
///
/// This entity stays free of flutter_scene types; the presentation layer
/// maps it onto a Node/Mesh/Material graph.
class SceneShape {
  const SceneShape({
    required this.label,
    required this.kind,
    required this.color,
    required this.size,
    required this.x,
    required this.y,
    required this.z,
    this.metallic = 0.1,
    this.roughness = 0.8,
    this.spinSpeed = 0,
    this.adjustable = false,
  });

  final String label;
  final SceneShapeKind kind;
  final Color color;

  /// Edge length for cubes, diameter for spheres, in world units.
  final double size;

  /// World-space position of the shape's center.
  final double x;
  final double y;
  final double z;

  /// PBR metallic factor in `[0, 1]`.
  final double metallic;

  /// PBR roughness factor in `[0, 1]`.
  final double roughness;

  /// Self-rotation speed around the Y axis, in radians per second.
  final double spinSpeed;

  /// Whether the demo's metallic/roughness sliders override this shape.
  final bool adjustable;
}

/// The default composition rendered by the flutter_scene demo page.
List<SceneShape> get demoSceneShapes => const <SceneShape>[
  SceneShape(
    label: 'Adjustable PBR sphere',
    kind: SceneShapeKind.sphere,
    color: Color(0xFFE0E0E0),
    size: 1.6,
    x: 0,
    y: 0,
    z: 0,
    metallic: 1,
    roughness: 0.2,
    adjustable: true,
  ),
  SceneShape(
    label: 'Spinning red cube',
    kind: SceneShapeKind.cube,
    color: Color(0xFFE53935),
    size: 1.1,
    x: -2.2,
    y: 0.1,
    z: 0.4,
    metallic: 0.2,
    roughness: 0.6,
    spinSpeed: 0.9,
  ),
  SceneShape(
    label: 'Gold sphere',
    kind: SceneShapeKind.sphere,
    color: Color(0xFFFFC107),
    size: 1,
    x: 2.1,
    y: -0.1,
    z: -0.3,
    metallic: 1,
    roughness: 0.35,
  ),
  SceneShape(
    label: 'Spinning teal cube',
    kind: SceneShapeKind.cube,
    color: Color(0xFF26A69A),
    size: 0.8,
    x: 0.9,
    y: 1,
    z: 1.4,
    metallic: 0,
    roughness: 0.9,
    spinSpeed: -1.4,
  ),
];
