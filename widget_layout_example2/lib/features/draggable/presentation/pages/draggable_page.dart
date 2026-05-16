import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.draggable)
class DraggableExamplePage extends StatefulWidget {
  const DraggableExamplePage({super.key});

  @override
  State<DraggableExamplePage> createState() => _DraggableExamplePageState();
}

class _DraggableExamplePageState extends State<DraggableExamplePage> {
  String _lastEvent = 'Nothing dragged yet.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draggable Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Draggable lets a widget carry data while the user drags it across the screen.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Basic Draggable',
              description:
                  'feedback shows what follows the finger, childWhenDragging replaces the original widget during the drag, and data carries the payload.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _buildTag(label: 'Bug', color: Colors.deepOrange, axis: null),
                  _buildTag(label: 'Feature', color: Colors.indigo, axis: null),
                  _buildTag(label: 'Docs', color: Colors.teal, axis: null),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Axis-Locked Drag',
              description:
                  'Set axis when the widget should only move horizontally or vertically.',
              child: Row(
                children: <Widget>[
                  _buildTag(
                    label: 'Horizontal only',
                    color: Colors.purple,
                    axis: Axis.horizontal,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'This draggable is limited to the horizontal axis.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Drag Callbacks',
              description:
                  'Use callbacks such as onDragStarted, onDraggableCanceled, and onDragEnd to track interaction state.',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_lastEvent),
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

  Widget _buildTag({
    required String label,
    required Color color,
    required Axis? axis,
  }) {
    return Draggable<String>(
      data: label,
      axis: axis,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () {
        setState(() {
          _lastEvent = 'Started dragging "$label".';
        });
      },
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        setState(() {
          _lastEvent =
              'Canceled "$label" at ${offset.dx.round()}, ${offset.dy.round()}.';
        });
      },
      onDragEnd: (DraggableDetails details) {
        setState(() {
          _lastEvent =
              'Finished "$label" with offset ${details.offset.dx.round()}, ${details.offset.dy.round()}.';
        });
      },
      feedback: Material(
        color: Colors.transparent,
        child: _TagChip(
          label: label,
          color: color.withValues(alpha: 0.92),
          icon: Icons.open_with,
        ),
      ),
      childWhenDragging: _TagChip(
        label: '$label (dragging)',
        color: color.withValues(alpha: 0.26),
        icon: Icons.hourglass_top,
      ),
      child: _TagChip(label: label, color: color, icon: Icons.drag_indicator),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
