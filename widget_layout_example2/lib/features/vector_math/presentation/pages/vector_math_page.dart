import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.vectorMath)
class VectorMathPage extends StatelessWidget {
  const VectorMathPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('vector_math Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'vector_math',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'vector_math provides 2D/3D/4D vectors, matrices, quaternions '
              'and common linear-algebra operations. '
              'Import vector_math_64 for double precision (recommended).',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 24),

            // ── 1. Vector2 ─────────────────────────────────────────────────
            const _SectionHeader(title: '1. Vector2 — 2-D vectors'),
            const _VectorTwoDemo(),
            const SizedBox(height: 24),

            // ── 2. Vector3 ─────────────────────────────────────────────────
            const _SectionHeader(title: '2. Vector3 — 3-D vectors'),
            const _VectorThreeDemo(),
            const SizedBox(height: 24),

            // ── 3. Vector4 ─────────────────────────────────────────────────
            const _SectionHeader(title: '3. Vector4 — 4-D vectors'),
            const _VectorFourDemo(),
            const SizedBox(height: 24),

            // ── 4. Matrix4 ─────────────────────────────────────────────────
            const _SectionHeader(
              title: '4. Matrix4 — 4×4 transformation matrix',
            ),
            const _Matrix4Demo(),
            const SizedBox(height: 24),

            // ── 5. Quaternion ──────────────────────────────────────────────
            const _SectionHeader(title: '5. Quaternion — 3-D rotations'),
            const _QuaternionDemo(),
            const SizedBox(height: 24),

            // ── 6. Aabb3 / Ray ─────────────────────────────────────────────
            const _SectionHeader(title: '6. Aabb3 — Axis-Aligned Bounding Box'),
            const _AabbDemo(),
            const SizedBox(height: 24),

            // ── 7. Visual: Matrix4 Transform applied to a Flutter widget ───
            const _SectionHeader(
              title: '7. Matrix4 applied to Flutter Transform',
            ),
            const _TransformDemo(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vector2 demo
// ─────────────────────────────────────────────────────────────────────────────
class _VectorTwoDemo extends StatelessWidget {
  const _VectorTwoDemo();

  @override
  Widget build(BuildContext context) {
    final vm.Vector2 a = vm.Vector2(3.0, 4.0);
    final vm.Vector2 b = vm.Vector2(1.0, 2.0);
    final vm.Vector2 sum = a + b;
    final vm.Vector2 diff = a - b;
    final double dot = a.dot(b);
    final double length = a.length;
    final vm.Vector2 normalized = a.normalized();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ResultRow(label: 'a', value: 'Vector2(3, 4)'),
        _ResultRow(label: 'b', value: 'Vector2(1, 2)'),
        _ResultRow(label: 'a + b', value: sum.toString()),
        _ResultRow(label: 'a − b', value: diff.toString()),
        _ResultRow(label: 'a · b (dot)', value: dot.toStringAsFixed(2)),
        _ResultRow(label: '|a| (length)', value: length.toStringAsFixed(4)),
        _ResultRow(label: 'a.normalized()', value: normalized.toString()),
        _CodeBlock(
          code:
              "import 'package:vector_math/vector_math_64.dart';\n\n"
              'final a = Vector2(3.0, 4.0);\n'
              'final b = Vector2(1.0, 2.0);\n'
              'final sum = a + b;           // Vector2(4, 6)\n'
              'final dot = a.dot(b);        // 11.0\n'
              'final len = a.length;        // 5.0\n'
              'final n   = a.normalized();  // (0.6, 0.8)',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vector3 demo
// ─────────────────────────────────────────────────────────────────────────────
class _VectorThreeDemo extends StatelessWidget {
  const _VectorThreeDemo();

  @override
  Widget build(BuildContext context) {
    final vm.Vector3 a = vm.Vector3(1.0, 0.0, 0.0); // unit X
    final vm.Vector3 b = vm.Vector3(0.0, 1.0, 0.0); // unit Y
    final vm.Vector3 cross = a.cross(b); // should be Z axis
    final double dot = a.dot(b); // orthogonal → 0
    final vm.Vector3 scaled = a.scaled(5.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ResultRow(label: 'X axis', value: a.toString()),
        _ResultRow(label: 'Y axis', value: b.toString()),
        _ResultRow(label: 'X × Y (cross)', value: cross.toString()),
        _ResultRow(label: 'X · Y (dot)', value: dot.toStringAsFixed(2)),
        _ResultRow(label: 'X scaled(5)', value: scaled.toString()),
        _CodeBlock(
          code:
              'final x = Vector3(1, 0, 0);\n'
              'final y = Vector3(0, 1, 0);\n'
              'final z = x.cross(y);   // Vector3(0, 0, 1)\n'
              'final d = x.dot(y);     // 0.0\n'
              'final s = x.scaled(5);  // Vector3(5, 0, 0)',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vector4 demo
// ─────────────────────────────────────────────────────────────────────────────
class _VectorFourDemo extends StatelessWidget {
  const _VectorFourDemo();

  @override
  Widget build(BuildContext context) {
    final vm.Vector4 v = vm.Vector4(1.0, 2.0, 3.0, 1.0); // homogeneous point
    final vm.Vector4 w = vm.Vector4(4.0, 5.0, 6.0, 1.0);
    final double dot = v.dot(w);
    final double len = v.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ResultRow(label: 'v', value: v.toString()),
        _ResultRow(label: 'w', value: w.toString()),
        _ResultRow(label: 'v · w (dot)', value: dot.toStringAsFixed(2)),
        _ResultRow(label: '|v| (length)', value: len.toStringAsFixed(4)),
        _ResultRow(label: 'v.xyz (xyz swizzle)', value: v.xyz.toString()),
        _CodeBlock(
          code:
              '// Homogeneous 3-D point\n'
              'final v = Vector4(1, 2, 3, 1);\n'
              'final dot = v.dot(w);   // 1*4 + 2*5 + 3*6 + 1*1 = 33\n'
              'final xyz = v.xyz;      // Vector3(1, 2, 3)',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Matrix4 demo
// ─────────────────────────────────────────────────────────────────────────────
class _Matrix4Demo extends StatelessWidget {
  const _Matrix4Demo();

  @override
  Widget build(BuildContext context) {
    final vm.Matrix4 identity = vm.Matrix4.identity();
    final vm.Matrix4 translation = vm.Matrix4.translation(
      vm.Vector3(10.0, 20.0, 0.0),
    );
    final vm.Matrix4 rotZ = vm.Matrix4.rotationZ(math.pi / 4); // 45°
    final vm.Matrix4 scale = vm.Matrix4.diagonal3Values(2.0, 2.0, 1.0);
    final vm.Vector3 point = vm.Vector3(1.0, 0.0, 0.0);
    final vm.Vector3 transformed = translation.transform3(
      vm.Vector3.copy(point),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ResultRow(label: 'identity row 0', value: identity.row0.toString()),
        _ResultRow(
          label: 'translate(10,20,0)\nrow 3',
          value: translation.row3.toString(),
        ),
        _ResultRow(label: 'rotZ(45°) row 0', value: rotZ.row0.toString()),
        _ResultRow(label: 'scale(2,2,1) row 0', value: scale.row0.toString()),
        _ResultRow(
          label: 'translate · Vector3(1,0,0)',
          value: transformed.toString(),
        ),
        _CodeBlock(
          code:
              'final t = Matrix4.translation(Vector3(10, 20, 0));\n'
              'final r = Matrix4.rotationZ(pi / 4); // 45°\n'
              'final s = Matrix4.diagonal3Values(2, 2, 1);\n\n'
              '// Chain transforms: scale → rotate → translate\n'
              'final m = t * r * s;\n\n'
              '// Transform a point\n'
              'final p = t.transform3(Vector3(1, 0, 0));\n'
              '// → Vector3(11, 20, 0)',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quaternion demo
// ─────────────────────────────────────────────────────────────────────────────
class _QuaternionDemo extends StatelessWidget {
  const _QuaternionDemo();

  @override
  Widget build(BuildContext context) {
    // Rotation of 90° around the Z axis
    final vm.Quaternion q = vm.Quaternion.axisAngle(
      vm.Vector3(0.0, 0.0, 1.0),
      math.pi / 2,
    );
    final vm.Quaternion qNorm = q..normalize();
    final vm.Matrix3 mat = qNorm.asRotationMatrix();
    final vm.Vector3 rotated = mat.transform(vm.Vector3(1.0, 0.0, 0.0));

    // Manual slerp at t = 0.5 between identity and 90° rotation.
    // For a single-axis rotation slerp(id, q, t) == q at angle * t.
    final vm.Quaternion half = vm.Quaternion.axisAngle(
      vm.Vector3(0.0, 0.0, 1.0),
      math.pi / 4, // pi/2 * 0.5 = 45°
    );
    final double halfAngle = half.radians; // ≈ pi/4

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ResultRow(label: 'q (90° around Z)', value: qNorm.toString()),
        _ResultRow(label: 'rotate (1,0,0) by q', value: rotated.toString()),
        _ResultRow(
          label: 'slerp(identity, q, 0.5)\nangle (rad)',
          value: halfAngle.toStringAsFixed(4),
        ),
        _CodeBlock(
          code:
              '// 90° rotation around Z axis\n'
              'final q = Quaternion.axisAngle(\n'
              '  Vector3(0, 0, 1), pi / 2,\n'
              ');\n\n'
              '// Rotate the X-axis → expect (0, 1, 0)\n'
              'final mat = q.normalized().asRotationMatrix();\n'
              'final v = mat.transform(Vector3(1, 0, 0));\n\n'
              '// Halfway rotation (t = 0.5) via scaled angle:\n'
              '// slerp(id, q, t) ≡ axisAngle(axis, angle * t)\n'
              'final half = Quaternion.axisAngle(\n'
              '  Vector3(0, 0, 1), pi / 2 * 0.5,\n'
              ');\n'
              'print(half.radians); // ≈ π/4',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Aabb3 demo
// ─────────────────────────────────────────────────────────────────────────────
class _AabbDemo extends StatelessWidget {
  const _AabbDemo();

  @override
  Widget build(BuildContext context) {
    final vm.Aabb3 box = vm.Aabb3.minMax(
      vm.Vector3(0.0, 0.0, 0.0),
      vm.Vector3(4.0, 3.0, 2.0),
    );
    final vm.Vector3 center = box.center;
    final bool containsPoint = box.containsVector3(vm.Vector3(2.0, 1.5, 1.0));
    final bool outsidePoint = box.containsVector3(vm.Vector3(5.0, 5.0, 5.0));

    // Expand the bounding box by 1 unit on each side
    final vm.Aabb3 expanded = vm.Aabb3.copy(box)
      ..min.sub(vm.Vector3(1.0, 1.0, 1.0))
      ..max.add(vm.Vector3(1.0, 1.0, 1.0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ResultRow(label: 'min', value: box.min.toString()),
        _ResultRow(label: 'max', value: box.max.toString()),
        _ResultRow(label: 'center', value: center.toString()),
        _ResultRow(
          label: 'contains (2,1.5,1)?',
          value: containsPoint.toString(),
        ),
        _ResultRow(label: 'contains (5,5,5)?', value: outsidePoint.toString()),
        _ResultRow(label: 'expanded min', value: expanded.min.toString()),
        _ResultRow(label: 'expanded max', value: expanded.max.toString()),
        _CodeBlock(
          code:
              'final box = Aabb3.minMax(\n'
              '  Vector3(0, 0, 0), Vector3(4, 3, 2),\n'
              ');\n'
              'print(box.center);                     // (2, 1.5, 1)\n'
              'print(box.containsVector3(point));     // true / false',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Visual: Matrix4 → Flutter Transform widget
// ─────────────────────────────────────────────────────────────────────────────
class _TransformDemo extends StatelessWidget {
  const _TransformDemo();

  @override
  Widget build(BuildContext context) {
    // Build a 3D perspective transform using vector_math Matrix4
    final vm.Matrix4 perspective = vm.makePerspectiveMatrix(
      vm.degrees2Radians * 60, // fov
      1.0, // aspect ratio
      0.1, // near
      100.0, // far
    );

    // Rotate around Y axis for a "3D card tilt" feel
    final vm.Matrix4 rotY = vm.Matrix4.rotationY(math.pi / 8);
    final vm.Matrix4 combined = perspective * rotY;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Matrix4 built with vector_math, then passed directly to '
          'Transform.transform for a 3D perspective tilt:',
        ),
        const SizedBox(height: 12),
        Center(
          child: Transform(
            transform: combined.storage.isEmpty
                ? Matrix4.identity()
                : _vmToFlutter(combined),
            alignment: Alignment.center,
            child: Container(
              width: 200,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[Colors.indigo, Colors.cyan],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black26,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                '3D Tilt\n(vector_math)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _CodeBlock(
          code:
              "import 'package:vector_math/vector_math_64.dart' as vm;\n\n"
              'final perspective = vm.makePerspectiveMatrix(\n'
              '  vm.degrees2Radians * 60, 1.0, 0.1, 100.0,\n'
              ');\n'
              'final rotY = vm.Matrix4.rotationY(pi / 8);\n'
              'final combined = perspective * rotY;\n\n'
              'Transform(\n'
              '  transform: Matrix4.fromFloat64List(\n'
              '    combined.storage,\n'
              '  ),\n'
              '  child: myWidget,\n'
              ')',
        ),
      ],
    );
  }

  /// Convert a vector_math Matrix4 to Flutter's Matrix4 (dart:ui/dart:typed_data).
  Matrix4 _vmToFlutter(vm.Matrix4 m) {
    return Matrix4.fromFloat64List(m.storage);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.teal),
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
