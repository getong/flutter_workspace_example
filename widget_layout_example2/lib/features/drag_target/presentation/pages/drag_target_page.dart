import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.dragTarget)
class DragTargetExamplePage extends StatefulWidget {
  const DragTargetExamplePage({super.key});

  @override
  State<DragTargetExamplePage> createState() => _DragTargetExamplePageState();
}

class _DragTargetExamplePageState extends State<DragTargetExamplePage> {
  final List<String> _backlog = <String>['Bug', 'Feature', 'Docs'];
  final List<String> _selected = <String>[];
  final List<String> _done = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DragTarget Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'DragTarget receives the data being dragged and decides whether to accept it.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const Text(
              'Drag the chips into different columns. This demonstrates onWillAcceptWithDetails, onAcceptWithDetails, and candidate highlighting.',
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _backlog.map(_buildDraggableChip).toList(),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool compact = constraints.maxWidth < 720;
                if (compact) {
                  return Column(
                    children: <Widget>[
                      _buildLane(
                        title: 'Selected',
                        color: Colors.indigo,
                        items: _selected,
                        onAccept: (String item) => _moveItem(item, _selected),
                      ),
                      const SizedBox(height: 16),
                      _buildLane(
                        title: 'Done',
                        color: Colors.teal,
                        items: _done,
                        onAccept: (String item) => _moveItem(item, _done),
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _buildLane(
                        title: 'Selected',
                        color: Colors.indigo,
                        items: _selected,
                        onAccept: (String item) => _moveItem(item, _selected),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildLane(
                        title: 'Done',
                        color: Colors.teal,
                        items: _done,
                        onAccept: (String item) => _moveItem(item, _done),
                      ),
                    ),
                  ],
                );
              },
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

  Widget _buildDraggableChip(String label) {
    return Draggable<String>(
      data: label,
      feedback: Material(
        color: Colors.transparent,
        child: _BoardChip(label: label, color: Colors.deepOrange),
      ),
      childWhenDragging: _BoardChip(
        label: '$label...',
        color: Colors.grey.withValues(alpha: 0.35),
      ),
      child: _BoardChip(label: label, color: Colors.deepOrange),
    );
  }

  Widget _buildLane({
    required String title,
    required Color color,
    required List<String> items,
    required ValueChanged<String> onAccept,
  }) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (DragTargetDetails<String> details) {
        return details.data.isNotEmpty;
      },
      onAcceptWithDetails: (DragTargetDetails<String> details) {
        onAccept(details.data);
      },
      builder:
          (
            BuildContext context,
            List<String?> candidateData,
            List<dynamic> rejectedData,
          ) {
            final bool active = candidateData.isNotEmpty;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: active
                    ? color.withValues(alpha: 0.16)
                    : color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active ? color : color.withValues(alpha: 0.35),
                  width: active ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    active
                        ? 'Release to drop ${candidateData.first}.'
                        : 'Drop an item here.',
                  ),
                  const SizedBox(height: 16),
                  if (items.isEmpty)
                    const Text('No items yet.')
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: items
                          .map(
                            (String item) =>
                                _BoardChip(label: item, color: color),
                          )
                          .toList(),
                    ),
                ],
              ),
            );
          },
    );
  }

  void _moveItem(String item, List<String> destination) {
    setState(() {
      _backlog.remove(item);
      _selected.remove(item);
      _done.remove(item);
      destination.add(item);
    });
  }
}

class _BoardChip extends StatelessWidget {
  const _BoardChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
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
