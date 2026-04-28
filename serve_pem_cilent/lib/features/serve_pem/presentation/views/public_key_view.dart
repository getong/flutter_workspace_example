import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../cubit/public_key_cubit.dart';

@RoutePage()
class PublicKeyView extends StatelessWidget {
  const PublicKeyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PublicKeyCubit>()..load(),
      child: const _PublicKeyScreen(),
    );
  }
}

class _PublicKeyScreen extends StatelessWidget {
  const _PublicKeyScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('/public-key')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<PublicKeyCubit, PublicKeyState>(
          builder: (context, state) {
            return switch (state) {
              PublicKeyLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              PublicKeyLoaded(:final publicKeyInfo) => ListView(
                children: [
                  _InfoTile(label: 'Transport', value: publicKeyInfo.transport),
                  _InfoTile(
                    label: 'Key encryption',
                    value: publicKeyInfo.keyEncryptionAlgorithm,
                  ),
                  _InfoTile(
                    label: 'Content encryption',
                    value: publicKeyInfo.contentEncryptionAlgorithm,
                  ),
                  _InfoTile(
                    label: 'Key format',
                    value: publicKeyInfo.keyFormat,
                  ),
                  _InfoTile(
                    label: 'Wrapped key bytes',
                    value: publicKeyInfo.wrappedKeyBytes.toString(),
                  ),
                  _InfoTile(
                    label: 'Nonce bytes',
                    value: publicKeyInfo.nonceBytes.toString(),
                  ),
                  _InfoTile(
                    label: 'Max wrapped key plaintext bytes',
                    value: publicKeyInfo.maxWrappedKeyPlaintextBytes.toString(),
                  ),
                  _InfoTile(
                    label: 'SHA-256 fingerprint',
                    value: publicKeyInfo.sha256Hash,
                  ),
                  const SizedBox(height: 20),
                  _LargeValueCard(
                    title: 'Public key PEM',
                    value: publicKeyInfo.publicKeyPem,
                  ),
                  const SizedBox(height: 16),
                  _LargeValueCard(
                    title: 'Public key DER (base64)',
                    value: publicKeyInfo.publicKeyDerBase64,
                  ),
                ],
              ),
              PublicKeyError(:final message) => _ErrorState(message: message),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<PublicKeyCubit>().load(),
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: SelectableText(value, style: theme.textTheme.bodyMedium),
      ),
    );
  }
}

class _LargeValueCard extends StatelessWidget {
  final String title;
  final String value;

  const _LargeValueCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              SelectableText(value, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 40),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
