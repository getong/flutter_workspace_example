import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'container_catalog.dart';

const CONTAINER_NUM = 8;

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
        itemCount: containerPages.length + CONTAINER_NUM,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return const Card(
              child: _ButtonContainerTile(),
            );
          }
          if (index == 1) {
            return const Card(
              child: _ButtonContainer2Tile(),
            );
          }
          if (index == 2) {
            return const Card(
              child: _ButtonContainer3Tile(),
            );
          }
          if (index == 3) {
            return const Card(
              child: _ButtonContainer4Tile(),
            );
          }
          if (index == 4) {
            return const Card(
              child: _ButtonContainer5Tile(),
            );
          }
          if (index == 5) {
            return const Card(
              child: _ButtonContainer6Tile(),
            );
          }
          if (index == 6) {
            return const Card(
              child: _ButtonContainer7Tile(),
            );
          }
          if (index == 7) {
            return const Card(
              child: _ButtonContainer8Tile(),
            );
          }
          if (index == 8) {
            return const Card(
              child: _ButtonContainer9Tile(),
            );
          }
          final ContainerPageSpec page = containerPages[index - CONTAINER_NUM];
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

class _ButtonContainer2Tile extends StatelessWidget {
  const _ButtonContainer2Tile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.smart_button_outlined),
      title: const Text('Button Container 2'),
      subtitle: const Text('/button_container2'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => context.go('/button_container2'),
    );
  }
}

class _ButtonContainer3Tile extends StatelessWidget {
  const _ButtonContainer3Tile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.smart_button_outlined),
      title: const Text('Button Container 3'),
      subtitle: const Text('/button_container3'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => context.go('/button_container3'),
    );
  }
}

class _ButtonContainer4Tile extends StatelessWidget {
  const _ButtonContainer4Tile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.smart_button_outlined),
      title: const Text('Button Container 4'),
      subtitle: const Text('/button_container4'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => context.go('/button_container4'),
    );
  }
}

class _ButtonContainer5Tile extends StatelessWidget {
  const _ButtonContainer5Tile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.smart_button_outlined),
      title: const Text('Button Container 5'),
      subtitle: const Text('/button_container5'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => context.go('/button_container5'),
    );
  }
}

class _ButtonContainer6Tile extends StatelessWidget {
  const _ButtonContainer6Tile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.smart_button_outlined),
      title: const Text('Button Container 6'),
      subtitle: const Text('/button_container6'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => context.go('/button_container6'),
    );
  }
}

class _ButtonContainer7Tile extends StatelessWidget {
  const _ButtonContainer7Tile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.smart_button_outlined),
      title: const Text('Button Container 7'),
      subtitle: const Text('/button_container7'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => context.go('/button_container7'),
    );
  }
}

class _ButtonContainer8Tile extends StatelessWidget {
  const _ButtonContainer8Tile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.smart_button_outlined),
      title: const Text('Button Container 8'),
      subtitle: const Text('/button_container8'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => context.go('/button_container8'),
    );
  }
}

class _ButtonContainer9Tile extends StatelessWidget {
  const _ButtonContainer9Tile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.smart_button_outlined),
      title: const Text('Button Container 9'),
      subtitle: const Text('/button_container9'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => context.go('/button_container9'),
    );
  }
}
