import 'package:auto_route/auto_route.dart';
import 'package:bloc_drift_example/app/app_router.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Patterns Demo')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Examples', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF0F766E),
                foregroundColor: Colors.white,
                child: Icon(Icons.cloud_off),
              ),
              title: const Text('Bloc + Drift Offline Orders'),
              subtitle: const Text(
                'Open the article-inspired flow with NetworkInfo, repository checks, Drift persistence, and queued sync.',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.router.push(const OfflineOrdersRoute()),
            ),
          ),
        ],
      ),
    );
  }
}
