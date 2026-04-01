import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'provider_catalog.dart';

class ProviderHomePage extends StatelessWidget {
  const ProviderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider + StatelessWidget'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: providerDemos.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return const _IntroCard();
          }

          final ProviderDemoSpec demo = providerDemos[index - 1];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              leading: CircleAvatar(
                backgroundColor: demo.color.withAlpha(30),
                foregroundColor: demo.color,
                child: Icon(demo.icon),
              ),
              title: Text(demo.title),
              subtitle: Text(demo.subtitle),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.go('/examples/${demo.slug}'),
            ),
          );
        },
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'This sample keeps the UI stateless.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Each screen below reads data from provider and sends actions '
              'back through ChangeNotifier methods.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
