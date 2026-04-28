import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/auth_flow_result.dart';

class ServerResultCard extends StatelessWidget {
  final String title;
  final AuthFlowResult flow;

  const ServerResultCard({super.key, required this.title, required this.flow});

  @override
  Widget build(BuildContext context) {
    final resultPayload = jsonEncode(<String, Object>{
      'status': flow.serverResult.status,
      'user_id': flow.serverResult.userId,
      'client_public_key_sha256': flow.serverResult.clientPublicKeySha256,
    });

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$title status: ${flow.serverResult.status}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _copyToClipboard(
                      context,
                      label: '$title result JSON',
                      value: resultPayload,
                    ),
                    icon: const Icon(Icons.copy_all_outlined),
                    label: const Text('Copy JSON'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _CopyableResultField(
                label: 'user_id',
                value: '${flow.serverResult.userId}',
              ),
              const SizedBox(height: 12),
              _CopyableResultField(
                label: 'client_public_key_sha256',
                value: flow.serverResult.clientPublicKeySha256,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EncryptedRequestCard extends StatelessWidget {
  final String title;
  final AuthFlowResult flow;

  const EncryptedRequestCard({
    super.key,
    required this.title,
    required this.flow,
  });

  @override
  Widget build(BuildContext context) {
    final encryptedRequest = flow.encryptedRequest;
    final publicKeyInfo = flow.publicKeyInfo;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _copyToClipboard(
                      context,
                      label: 'Encrypted request JSON',
                      value: encryptedRequest.toPrettyJson(),
                    ),
                    icon: const Icon(Icons.copy_all_outlined),
                    label: const Text('Copy JSON'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'The client fetched the current RSA public key over HTTPS, wrapped a random 32-byte AES key, then encrypted the JSON payload with AES-256-GCM before submitting the request.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _CopyableResultField(
                label: 'public_key_sha256',
                value: publicKeyInfo.sha256Hash,
              ),
              const SizedBox(height: 12),
              _CopyableResultField(
                label: 'transport',
                value: publicKeyInfo.transport,
              ),
              const SizedBox(height: 12),
              _CopyableResultField(
                label: 'wrapped_key_bytes',
                value: '${encryptedRequest.wrappedKeyBytes}',
              ),
              const SizedBox(height: 12),
              _CopyableResultField(
                label: 'nonce_bytes',
                value: '${encryptedRequest.nonceBytes}',
              ),
              const SizedBox(height: 12),
              _CopyableResultField(
                label: 'ciphertext_bytes',
                value: '${encryptedRequest.ciphertextBytes}',
              ),
              const SizedBox(height: 12),
              _CopyableResultField(
                label: 'wrapped_key_base64',
                value: encryptedRequest.wrappedKeyBase64,
              ),
              const SizedBox(height: 12),
              _CopyableResultField(
                label: 'nonce_base64',
                value: encryptedRequest.nonceBase64,
              ),
              const SizedBox(height: 12),
              _CopyableResultField(
                label: 'ciphertext_base64',
                value: encryptedRequest.ciphertextBase64,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CopyableResultField extends StatelessWidget {
  final String label;
  final String value;

  const _CopyableResultField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SelectableText(value),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () =>
                    _copyToClipboard(context, label: label, value: value),
                icon: const Icon(Icons.copy),
                label: const Text('Copy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _copyToClipboard(
  BuildContext context, {
  required String label,
  required String value,
}) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('$label copied to clipboard.')));
}
