import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'stack_catalog.dart';

class StackDetailPage extends StatelessWidget {
  const StackDetailPage({required this.page, super.key});

  final StackPageSpec page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(page.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              'Dynamic route: /layouts/${page.slug}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: page.color.withAlpha(31),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: page.color, width: 2),
                ),
                child: _buildStackPreview(page.kind),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(page.message)));
        },
        child: Icon(page.icon),
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

  Widget _buildStackPreview(StackLayoutKind kind) {
    if (kind == StackLayoutKind.heroCard) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(color: Colors.orange.shade200),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0x22000000), Color(0xAA000000)],
                ),
              ),
            ),
            const Positioned(
              top: 14,
              left: 14,
              child: Chip(
                avatar: Icon(Icons.play_arrow, size: 16),
                label: Text('Live'),
              ),
            ),
            const Positioned(
              left: 14,
              bottom: 18,
              child: Text(
                'Morning Product Brief',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (kind == StackLayoutKind.mapPins) {
      return Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          _pin(0.20, 0.30, 'A'),
          _pin(0.58, 0.20, 'B'),
          _pin(0.64, 0.58, 'C'),
          _pin(0.34, 0.68, 'D'),
        ],
      );
    }

    if (kind == StackLayoutKind.avatars) {
      return Center(
        child: SizedBox(
          width: 240,
          height: 120,
          child: Stack(
            children: <Widget>[
              _avatar(0, Colors.indigo.shade200, 'A'),
              _avatar(44, Colors.indigo.shade300, 'B'),
              _avatar(88, Colors.indigo.shade400, 'C'),
              _avatar(132, Colors.indigo.shade500, 'D'),
              Positioned(
                left: 176,
                top: 20,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '+8',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.teal, Colors.cyan],
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(220),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text('Healthy'),
          ),
        ),
        const Align(
          alignment: Alignment.center,
          child: Icon(Icons.check_circle, color: Colors.white, size: 68),
        ),
        const Positioned(
          left: 16,
          bottom: 16,
          child: Text(
            'Background + Status + CTA',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _pin(double dx, double dy, String label) {
    return Positioned.fill(
      child: FractionalTranslation(
        translation: Offset(dx, dy),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _avatar(double left, Color color, String label) {
    return Positioned(
      left: left,
      top: 20,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 3),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
