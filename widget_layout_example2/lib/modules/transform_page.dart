import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'TransformExampleRoute')
class TransformExamplePage extends StatefulWidget {
  const TransformExamplePage({super.key});

  @override
  State<TransformExamplePage> createState() => _TransformExamplePageState();
}

class _TransformExamplePageState extends State<TransformExamplePage> {
  double _angle = 0.2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transform Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Transform changes how a widget is painted by translating, rotating, scaling, or skewing it.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Transform.rotate',
              description:
                  'This is useful for playful accents, diagrams, or temporary visual treatment during interactions.',
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    child: Center(
                      child: Transform.rotate(
                        angle: _angle,
                        child: _DemoTile(
                          color: Colors.deepOrange,
                          label: 'Rotated',
                        ),
                      ),
                    ),
                  ),
                  Slider(
                    min: -math.pi / 4,
                    max: math.pi / 4,
                    value: _angle,
                    onChanged: (double value) {
                      setState(() {
                        _angle = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Translate and Scale',
              description:
                  'Transform.translate and Transform.scale are common for hover states, badges, or layered effects.',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(0, -12),
                    child: _DemoTile(color: Colors.indigo, label: 'Translate'),
                  ),
                  Transform.scale(
                    scale: 1.15,
                    child: _DemoTile(color: Colors.teal, label: 'Scale'),
                  ),
                ],
              ),
            ),
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

class _DemoTile extends StatelessWidget {
  const _DemoTile({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 72,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
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
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
