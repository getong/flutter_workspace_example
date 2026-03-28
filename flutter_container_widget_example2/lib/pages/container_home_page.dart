import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'container_catalog.dart';

class ContainerHomePage extends StatelessWidget {
  const ContainerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter UI Container'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: containerPages.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) {
          final ContainerPageSpec page = containerPages[index];
          return Card(
            child: ListTile(
              leading: Icon(page.icon),
              title: Text(page.title),
              subtitle: Text('/containers/${page.slug}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.go('/containers/${page.slug}'),
            ),
          );
        },
      ),
    );
  }
}
