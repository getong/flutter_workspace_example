import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StackBasicsPage extends StatelessWidget {
  const StackBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack Basics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Example 1: layered boxes with alignment'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 180,
              color: Colors.blueGrey.shade50,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  _layerBox('Back', 260, 140, Colors.indigo.shade200),
                  _layerBox('Middle', 190, 100, Colors.indigo.shade400),
                  _layerBox('Front', 120, 60, Colors.indigo.shade600),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Example 2: StackFit.expand for background + content'),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(color: Colors.teal.shade200),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[Color(0x11000000), Color(0x77000000)],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 14,
                    bottom: 14,
                    child: Text(
                      'Stack lets overlays stay in one widget tree.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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

  Widget _layerBox(String label, double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      color: color,
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
