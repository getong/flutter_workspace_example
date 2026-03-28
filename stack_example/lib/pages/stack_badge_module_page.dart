import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StackBadgeModulePage extends StatelessWidget {
  const StackBadgeModulePage({super.key});

  Widget _iconBadge({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color.withAlpha(36),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 32),
        ),
        Positioned(
          right: -6,
          top: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade500,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack Badge Module')),
      body: Center(
        child: Container(
          width: 320,
          height: 220,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.grey.shade100, Colors.blueGrey.shade50],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _iconBadge(icon: Icons.email, value: '12', color: Colors.blue),
              _iconBadge(
                icon: Icons.shopping_cart,
                value: '3',
                color: Colors.teal,
              ),
              _iconBadge(
                icon: Icons.notifications,
                value: '8',
                color: Colors.orange,
              ),
            ],
          ),
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
