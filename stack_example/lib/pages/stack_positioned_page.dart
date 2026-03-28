import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StackPositionedPage extends StatelessWidget {
  const StackPositionedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack Positioned')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Example 1: Pin children to corners'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 180,
              color: Colors.orange.shade50,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.all(18),
                      color: Colors.orange.shade200,
                    ),
                  ),
                  _cornerBadge('TL', top: 8, left: 8),
                  _cornerBadge('TR', top: 8, right: 8),
                  _cornerBadge('BL', bottom: 8, left: 8),
                  _cornerBadge('BR', bottom: 8, right: 8),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Example 2: Build a simple profile header'),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 190,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned.fill(
                    bottom: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.wb_sunny, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'San Francisco 21C',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 0,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'G',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _cornerBadge(
    String label, {
    double? top,
    double? left,
    double? right,
    double? bottom,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.deepOrange.shade400,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
