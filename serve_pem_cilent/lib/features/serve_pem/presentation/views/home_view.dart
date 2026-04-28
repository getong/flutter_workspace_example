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
              '`serve_pem` over HTTPS: fetch the RSA public key, wrap a random AES key with RSA-OAEP-SHA256, encrypt the JSON payload with AES-256-GCM, and submit the hybrid-encrypted request to `/register` or `/login`.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _EndpointBanner(baseUrl: resolveServePemBaseUrl()),
            const SizedBox(height: 24),
            _ActionCard(
              title: 'Inspect /public-key',
              description:
                  'Load the PEM, DER base64, SHA-256 fingerprint, and hybrid transport metadata returned by the Rust service.',
              icon: Icons.key_outlined,
              onTap: () => context.pushRoute(const PublicKeyRoute()),
            ),
            const SizedBox(height: 16),
            _ActionCard(
              title: 'Submit /register',
              description:
                  'Encrypt a registration payload with AES-256-GCM, wrap the AES key with RSA-OAEP-SHA256, and POST the full request body.',
              icon: Icons.lock_outline,
              onTap: () => context.pushRoute(const RegisterRoute()),
            ),
            const SizedBox(height: 16),
            _ActionCard(
              title: 'Submit /login',
              description:
                  'Send the same hybrid-encrypted request shape to authenticate a previously registered client.',
              icon: Icons.login,
              onTap: () => context.pushRoute(const LoginRoute()),
            ),
            const SizedBox(height: 16),
            _ActionCard(
              title: 'Join WSS chat',
              description:
                  'Open the room-scoped `/ws/{room}` websocket endpoint, watch `welcome` and `presence` events, and send `chat_message` payloads.',
              icon: Icons.forum_outlined,
              onTap: () => context.navigateTo(
                const AppTabsRoute(children: [ChatRoute()]),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'The Rust server now serves HTTPS with a self-signed local certificate. IO builds of this app accept that certificate for loopback and emulator hosts only, and the same local trust rule is reused for `wss`. Override the endpoint with `--dart-define=SERVE_PEM_BASE_URL=https://your-host:3030` when needed.',
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
              'Android emulators use `10.0.2.2`; desktop and iOS simulators use `127.0.0.1`. Both now use HTTPS on port `3030`.',
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
