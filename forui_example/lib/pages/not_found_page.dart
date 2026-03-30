import 'package:flutter/material.dart';

import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Route Not Found'),
        prefixes: <Widget>[
          FHeaderAction.back(onPress: () => context.go('/overview')),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: FCard(
            title: const Text('No page matches this path'),
            subtitle: Text(path),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'The router is configured for `/overview`, `/catalog`, `/profile`, and `/catalog/:slug`.',
                ),
                const SizedBox(height: 20),
                FButton(
                  onPress: () => context.go('/overview'),
                  child: const Text('Go to Overview'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
