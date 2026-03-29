import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/go_back_icon_button.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const GoBackIconButton(),
        title: const Text('Not Found'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.error_outline, size: 56),
              const SizedBox(height: 16),
              Text('Route not found: $path'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Back Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
