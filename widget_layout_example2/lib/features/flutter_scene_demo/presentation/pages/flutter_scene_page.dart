import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_scene_demo/domain/entities/scene_shape.dart';
import 'package:widget_layout_example2/features/flutter_scene_demo/presentation/widgets/scene_viewport.dart';

const String _viewportSource = r'''
// A flutter_scene scene is a retained scene graph rendered with
// Flutter GPU (Impeller). Build it once, mutate nodes each frame,
// and draw it from any Canvas — here via a CustomPainter.

final Scene scene = Scene();

// Geometry + Material combine into a Mesh, carried by a Node.
scene.add(
  Node(
    localTransform: Matrix4.translation(Vector3(0, 0, 0)),
    mesh: Mesh(
      SphereGeometry(radius: 0.8),
      PhysicallyBasedMaterial()
        ..baseColorFactor = Vector4(0.9, 0.9, 0.9, 1)
        ..metallicFactor = 1.0
        ..roughnessFactor = 0.2,
    ),
  ),
);

// Optional analytic light on top of the default image-based lighting.
scene.directionalLight = DirectionalLight(
  direction: Vector3(-0.4, -1, -0.3),
  intensity: 4,
  castsShadow: true,
);

// Static shader/pipeline resources must be ready before the first frame.
await Scene.initializeStaticResources();

// Inside CustomPainter.paint:
scene.render(
  PerspectiveCamera(position: Vector3(0, 2, -6)),
  canvas,
  viewport: Offset.zero & size,
);
''';

@RoutePage(name: RouteName.flutterScene)
class FlutterScenePage extends StatefulWidget {
  const FlutterScenePage({super.key});

  @override
  State<FlutterScenePage> createState() => _FlutterScenePageState();
}

class _FlutterScenePageState extends State<FlutterScenePage> {
  final List<SceneShape> _shapes = demoSceneShapes;

  bool _orbitCamera = true;
  bool _lightEnabled = true;
  double _cameraDistance = 6;
  double _metallic = 1;
  double _roughness = 0.2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_scene Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const SelectableText(
            'flutter_scene is a realtime 3D rendering library built on Flutter '
            'GPU and Impeller. It gives Flutter a retained scene graph — '
            'nodes, meshes, PBR materials, lights, and cameras — that renders '
            'straight onto an ordinary Canvas, so 3D content composes with '
            'the rest of the widget tree like any other painting.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Live scene',
            description:
                'A Scene graph built from primitive geometry (CuboidGeometry, '
                'SphereGeometry, PlaneGeometry) with physically based '
                'materials, image-based lighting from the built-in studio '
                'environment, and a shadow-casting directional light. A '
                'Ticker orbits the camera and spins the cubes; every frame '
                'is drawn by Scene.render() inside a CustomPainter.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 320,
                  width: double.infinity,
                  child: SceneViewport(
                    shapes: _shapes,
                    orbitCamera: _orbitCamera,
                    cameraDistance: _cameraDistance,
                    lightEnabled: _lightEnabled,
                    metallic: _metallic,
                    roughness: _roughness,
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Orbit camera'),
                  subtitle: const Text(
                    'Moves PerspectiveCamera.position around the origin',
                  ),
                  value: _orbitCamera,
                  onChanged: (bool value) =>
                      setState(() => _orbitCamera = value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Directional light + shadows'),
                  subtitle: const Text(
                    'Toggles Scene.directionalLight; IBL stays on',
                  ),
                  value: _lightEnabled,
                  onChanged: (bool value) =>
                      setState(() => _lightEnabled = value),
                ),
                _LabeledSlider(
                  label: 'Camera distance',
                  value: _cameraDistance,
                  min: 3.5,
                  max: 12,
                  onChanged: (double value) =>
                      setState(() => _cameraDistance = value),
                ),
                _LabeledSlider(
                  label: 'Center sphere metallic',
                  value: _metallic,
                  onChanged: (double value) =>
                      setState(() => _metallic = value),
                ),
                _LabeledSlider(
                  label: 'Center sphere roughness',
                  value: _roughness,
                  onChanged: (double value) =>
                      setState(() => _roughness = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Scene contents',
            description:
                'Each object below is a domain entity (SceneShape) that the '
                'viewport maps onto a Node carrying a Mesh (geometry + '
                'material), mirroring how the other feature modules keep '
                'domain data separate from presentation.',
            child: Column(
              children: _shapes
                  .map((SceneShape shape) => _ShapeRow(shape))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          const _SectionCard(
            title: 'What flutter_scene is for',
            description: '',
            child: SelectableText(
              '• Scene / Node — a transform hierarchy: move a parent node and '
              'its children follow. Nodes optionally carry a Mesh.\n'
              '• Geometry — built-in primitives used here, plus glTF model '
              'loading (Node.fromAsset for preprocessed .model files, '
              'Node.fromGlbAsset for runtime .glb import) and skeletal '
              'animation playback.\n'
              '• Materials — PhysicallyBasedMaterial (metallic/roughness '
              'workflow, the glTF standard) and UnlitMaterial for flat '
              'shading.\n'
              '• Lighting — image-based lighting from an EnvironmentMap plus '
              'an optional shadow-casting DirectionalLight.\n'
              '• Rendering — Scene.render(camera, canvas) draws with Flutter '
              'GPU into the canvas, so it works inside CustomPaint, behind '
              'widgets, in lists, etc. Typical uses: product viewers, games, '
              'data visualization, and 3D flourishes inside regular UI.',
            ),
          ),
          const SizedBox(height: 16),
          const _CodeCard(title: 'Minimal usage', code: _viewportSource),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _LabeledSlider extends StatelessWidget {
  const _LabeledSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 190, child: Text(label)),
        Expanded(
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
        SizedBox(width: 40, child: Text(value.toStringAsFixed(1))),
      ],
    );
  }
}

class _ShapeRow extends StatelessWidget {
  const _ShapeRow(this.shape);

  final SceneShape shape;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: shape.color,
              shape: shape.kind == SceneShapeKind.sphere
                  ? BoxShape.circle
                  : BoxShape.rectangle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: SelectableText(shape.label)),
          SelectableText(
            'metallic ${shape.metallic.toStringAsFixed(1)} · '
            'roughness ${shape.roughness.toStringAsFixed(1)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (description.isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              SelectableText(description),
            ],
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                code.trim(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
