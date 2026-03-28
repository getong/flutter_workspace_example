import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'container_catalog.dart';

class ContainerDetailPage extends StatelessWidget {
  const ContainerDetailPage({required this.page, super.key});

  final ContainerPageSpec page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(page.title),
      ),
      body: Container(
        color: page.color,
        alignment: Alignment.center,
        child: Text(
          'Hello! I am inside ${page.title}.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(page.message)),
          );
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
}
