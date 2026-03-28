import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GridInteractiveModulePage extends StatefulWidget {
  const GridInteractiveModulePage({super.key});

  @override
  State<GridInteractiveModulePage> createState() =>
      _GridInteractiveModulePageState();
}

class _GridInteractiveModulePageState extends State<GridInteractiveModulePage> {
  final Set<int> _selected = <int>{};
  int? _hoveredIndex;

  void _toggleSelected(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid Interactive Module')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              _hoveredIndex == null
                  ? 'Hover or tap tiles to interact.'
                  : 'Hovering tile ${_hoveredIndex! + 1}',
            ),
            const SizedBox(height: 12),
            Text('Selected: ${_selected.length}'),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: 20,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final bool selected = _selected.contains(index);
                  final Color color = selected
                      ? Colors.orange.shade400
                      : Colors.blue.shade300;

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) {
                      setState(() {
                        _hoveredIndex = index;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _hoveredIndex = null;
                      });
                    },
                    child: GestureDetector(
                      onTap: () => _toggleSelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        curve: Curves.easeOut,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: selected ? 3 : 1,
                            color: selected
                                ? Colors.deepOrange.shade900
                                : Colors.white70,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        TextButton.icon(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.home),
          label: const Text('Back Home'),
        ),
      ],
    );
  }
}
