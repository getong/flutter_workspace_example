import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StackInteractiveModulePage extends StatefulWidget {
  const StackInteractiveModulePage({super.key});

  @override
  State<StackInteractiveModulePage> createState() =>
      _StackInteractiveModulePageState();
}

class _StackInteractiveModulePageState
    extends State<StackInteractiveModulePage> {
  int _activeLayer = 2;

  void _setActiveLayer(int index) {
    setState(() {
      _activeLayer = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Activated layer $index'),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  Widget _layer({
    required int index,
    required Color color,
    required double inset,
  }) {
    final bool isActive = _activeLayer == index;
    return Positioned.fill(
      left: inset,
      right: inset,
      top: inset,
      bottom: inset,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _setActiveLayer(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: isActive ? color.withAlpha(220) : color.withAlpha(168),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? Colors.white : Colors.white54,
                width: isActive ? 2.5 : 1.0,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'Layer $index',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack Interactive Module')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Tap a layer to bring attention to it. Active: $_activeLayer'),
            const SizedBox(height: 14),
            SizedBox(
              width: 320,
              height: 220,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Colors.black87, Colors.black54],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  _layer(index: 0, color: Colors.blue, inset: 18),
                  _layer(index: 1, color: Colors.teal, inset: 38),
                  _layer(index: 2, color: Colors.purple, inset: 58),
                ],
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
