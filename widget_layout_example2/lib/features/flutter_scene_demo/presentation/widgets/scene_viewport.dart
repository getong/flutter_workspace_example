import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_scene/scene.dart' as fs;
import 'package:vector_math/vector_math.dart' as vm;

import 'package:widget_layout_example2/features/flutter_scene_demo/domain/entities/scene_shape.dart';

/// Renders a flutter_scene [fs.Scene] built from [SceneShape] entities.
///
/// The scene graph is created once; a ticker drives the orbiting camera and
/// the per-shape spin, and a [CustomPainter] calls [fs.Scene.render] every
/// frame.
class SceneViewport extends StatefulWidget {
  const SceneViewport({
    super.key,
    required this.shapes,
    this.orbitCamera = true,
    this.cameraDistance = 6,
    this.lightEnabled = true,
    this.metallic = 1,
    this.roughness = 0.2,
  });

  final List<SceneShape> shapes;

  /// Whether the camera slowly circles the scene.
  final bool orbitCamera;

  /// Distance from the camera to the scene origin, in world units.
  final double cameraDistance;

  /// Whether the shadow-casting directional light is active (image-based
  /// lighting from the built-in studio environment stays on either way).
  final bool lightEnabled;

  /// Metallic factor applied to shapes marked [SceneShape.adjustable].
  final double metallic;

  /// Roughness factor applied to shapes marked [SceneShape.adjustable].
  final double roughness;

  @override
  State<SceneViewport> createState() => _SceneViewportState();
}

class _ShapeNode {
  _ShapeNode(this.shape, this.node, this.material);

  final SceneShape shape;
  final fs.Node node;
  final fs.PhysicallyBasedMaterial material;
}

class _SceneViewportState extends State<SceneViewport>
    with SingleTickerProviderStateMixin {
  final fs.Scene _scene = fs.Scene();
  final List<_ShapeNode> _shapeNodes = <_ShapeNode>[];
  late final fs.PerspectiveCamera _camera;
  late final Ticker _ticker;
  final fs.DirectionalLight _sun = fs.DirectionalLight(
    direction: vm.Vector3(-0.4, -1, -0.3),
    intensity: 4,
    castsShadow: true,
  );

  bool _ready = false;
  double _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _camera = fs.PerspectiveCamera(
      position: vm.Vector3(0, 2, -widget.cameraDistance),
      target: vm.Vector3(0, 0, 0),
    );
    _buildSceneGraph();
    _applySettings();
    _ticker = createTicker(_onTick);
    fs.Scene.initializeStaticResources().then((_) {
      if (!mounted) {
        return;
      }
      setState(() => _ready = true);
      _ticker.start();
    });
  }

  @override
  void didUpdateWidget(SceneViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    _applySettings();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _buildSceneGraph() {
    // Ground plane that catches the directional light's shadows.
    final fs.PhysicallyBasedMaterial groundMaterial =
        fs.PhysicallyBasedMaterial()
          ..baseColorFactor = vm.Vector4(0.82, 0.84, 0.88, 1)
          ..metallicFactor = 0
          ..roughnessFactor = 1;
    _scene.add(
      fs.Node(
        name: 'ground',
        localTransform: vm.Matrix4.translation(vm.Vector3(0, -1.3, 0)),
        mesh: fs.Mesh(fs.PlaneGeometry(width: 14, depth: 14), groundMaterial),
      ),
    );

    for (final SceneShape shape in widget.shapes) {
      final fs.Geometry geometry = switch (shape.kind) {
        SceneShapeKind.cube => fs.CuboidGeometry(
          vm.Vector3(shape.size, shape.size, shape.size),
        ),
        SceneShapeKind.sphere => fs.SphereGeometry(radius: shape.size / 2),
      };
      final fs.PhysicallyBasedMaterial material = fs.PhysicallyBasedMaterial()
        ..baseColorFactor = vm.Vector4(
          shape.color.r,
          shape.color.g,
          shape.color.b,
          1,
        )
        ..metallicFactor = shape.metallic
        ..roughnessFactor = shape.roughness;
      final fs.Node node = fs.Node(
        name: shape.label,
        localTransform: vm.Matrix4.translation(
          vm.Vector3(shape.x, shape.y, shape.z),
        ),
        mesh: fs.Mesh(geometry, material),
      );
      _scene.add(node);
      _shapeNodes.add(_ShapeNode(shape, node, material));
    }
  }

  void _applySettings() {
    _scene.directionalLight = widget.lightEnabled ? _sun : null;
    for (final _ShapeNode entry in _shapeNodes) {
      if (entry.shape.adjustable) {
        entry.material
          ..metallicFactor = widget.metallic
          ..roughnessFactor = widget.roughness;
      }
    }
  }

  void _onTick(Duration elapsed) {
    setState(() {
      _elapsedSeconds = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
    });
  }

  void _advanceScene() {
    final double cameraAngle = widget.orbitCamera
        ? _elapsedSeconds * 0.4
        : math.pi;
    _camera.position = vm.Vector3(
      math.sin(cameraAngle) * widget.cameraDistance,
      2.2,
      math.cos(cameraAngle) * widget.cameraDistance,
    );

    for (final _ShapeNode entry in _shapeNodes) {
      final SceneShape shape = entry.shape;
      if (shape.spinSpeed == 0) {
        continue;
      }
      entry.node.localTransform = vm.Matrix4.compose(
        vm.Vector3(shape.x, shape.y, shape.z),
        vm.Quaternion.axisAngle(
          vm.Vector3(0, 1, 0),
          _elapsedSeconds * shape.spinSpeed,
        ),
        vm.Vector3.all(1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const ColoredBox(
        color: Color(0xFF1A1C20),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    _advanceScene();
    return ClipRect(
      child: CustomPaint(
        painter: _ScenePainter(_scene, _camera),
        size: Size.infinite,
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.scene, this.camera);

  final fs.Scene scene;
  final fs.Camera camera;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF1A1C20),
    );
    scene.render(camera, canvas, viewport: Offset.zero & size);
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) => true;
}
