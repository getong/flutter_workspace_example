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
        itemCount: containerPages.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return const Card(
              child: _ButtonContainerTile(),
            );
          }
          final ContainerPageSpec page = containerPages[index - 1];
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

class _ButtonContainerTile extends StatelessWidget {
  const _ButtonContainerTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.smart_button),
      title: const Text('Button Container'),
      subtitle: const Text('/button_container'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => context.go('/button_container'),
    );
  }
}
