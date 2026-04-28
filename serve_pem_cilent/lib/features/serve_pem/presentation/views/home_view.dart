import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/server_base_url.dart';
import '../../../../core/routing/app_router.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Serve PEM Client')),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerLowest,
              colorScheme.primaryContainer.withValues(alpha: 0.35),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Rust service playground',
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            Text(
              'This app talks to the local Axum demo from '
              '`serve_pem`: fetch the RSA public key, then encrypt a compact JSON registration payload and submit it back to `/register`.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _EndpointBanner(baseUrl: resolveServePemBaseUrl()),
            const SizedBox(height: 24),
            _ActionCard(
              title: 'Inspect /public-key',
              description:
                  'Load the PEM, DER base64, SHA-256 fingerprint, and plaintext size limit returned by the Rust service.',
              icon: Icons.key_outlined,
              onTap: () => context.pushRoute(const PublicKeyRoute()),
            ),
            const SizedBox(height: 16),
            _ActionCard(
              title: 'Submit /register',
              description:
                  'Build the plaintext JSON expected by the server, encrypt it with RSA-OAEP-SHA256, and POST the ciphertext.',
              icon: Icons.lock_outline,
              onTap: () => context.pushRoute(const RegisterRoute()),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Keep the payload short. The Rust server uses RSA-2048 OAEP-SHA256, so the plaintext limit is typically 190 bytes total.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EndpointBanner extends StatelessWidget {
  final String baseUrl;

  const _EndpointBanner({required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Active server endpoint', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            SelectableText(baseUrl, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 10),
            Text(
              'Android emulators use `10.0.2.2`; desktop and iOS simulators use `127.0.0.1`.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(radius: 24, child: Icon(icon)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(description, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}
