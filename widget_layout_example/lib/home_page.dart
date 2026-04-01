import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Layout Modules')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => context.go('/center-box'),
              child: const Text('Center Box Module'),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/constrained-box'),
              child: const Text('Constrained Box Module'),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/row-expand-page'),
              child: const Text('Row Expanded Module'),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/gesturedector-page'),
              child: const Text('gesturedector Module'),
            ),
          ],
        ),
      ),
    );
  }
}
