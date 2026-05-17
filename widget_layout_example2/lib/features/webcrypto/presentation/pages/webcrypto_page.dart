import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/webcrypto/data/repositories/webcrypto_demo_repository_impl.dart';
import 'package:widget_layout_example2/features/webcrypto/domain/entities/webcrypto_demo_result.dart';
import 'package:widget_layout_example2/features/webcrypto/domain/repositories/webcrypto_demo_repository.dart';

@RoutePage(name: RouteName.webcrypto)
class WebcryptoPage extends StatefulWidget {
  const WebcryptoPage({super.key});

  @override
  State<WebcryptoPage> createState() => _WebcryptoPageState();
}

class _WebcryptoPageState extends State<WebcryptoPage> {
  _WebcryptoPageState({WebcryptoDemoRepository? repository})
    : _repository = repository ?? WebcryptoDemoRepositoryImpl();

  final WebcryptoDemoRepository _repository;
  final TextEditingController _plaintextController = TextEditingController(
    text: 'webcrypto protects data across Flutter mobile, desktop, and web.',
  );
  final TextEditingController _additionalDataController = TextEditingController(
    text: 'x-demo-context:widget-layout-example2',
  );

  WebcryptoDemoResult? _result;
  bool _isRunning = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _runDemo();
  }

  @override
  void dispose() {
    _plaintextController.dispose();
    _additionalDataController.dispose();
    super.dispose();
  }

  Future<void> _runDemo() async {
    setState(() {
      _isRunning = true;
      _error = null;
    });

    try {
      final WebcryptoDemoResult result = await _repository.runDemo(
        plaintext: _plaintextController.text,
        additionalData: _additionalDataController.text,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _result = result;
        _isRunning = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = '$error';
        _isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('webcrypto Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'webcrypto provides cross-platform cryptographic primitives with one Dart API for Android, iOS, Web, Windows, Linux, and macOS.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates what it is useful for: secure random bytes, SHA-256 digests, HMAC signing and verification, and AES-GCM authenticated encryption/decryption.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Interactive input',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Edit the plaintext and associated data, then run the demo again to see new digest, signature, key material, IV, and ciphertext values.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _plaintextController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Plaintext',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _additionalDataController,
                      minLines: 1,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'AES-GCM additional authenticated data',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _isRunning ? null : _runDemo,
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(_isRunning ? 'Running...' : 'Run Demo'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _isRunning
                              ? null
                              : () {
                                  _plaintextController.text =
                                      'webcrypto protects data across Flutter mobile, desktop, and web.';
                                  _additionalDataController.text =
                                      'x-demo-context:widget-layout-example2';
                                  _runDemo();
                                },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset Sample'),
                        ),
                      ],
                    ),
                    if (_error != null) ...<Widget>[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _UseCasesCard(),
            const SizedBox(height: 16),
            if (_result != null) ...<Widget>[
              _OutputCard(
                title: 'Secure random bytes',
                description:
                    'Use `fillRandomBytes` for IVs, nonces, tokens, or temporary secrets. This is for cryptographic randomness, not UI randomness.',
                rows: <_OutputRow>[
                  _OutputRow(
                    label: 'base64',
                    value: _result!.randomBytesBase64,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _OutputCard(
                title: 'SHA-256 digest',
                description:
                    'A digest is useful for integrity checks, fingerprints, cache keys, or deduplication. It is one-way and not reversible.',
                rows: <_OutputRow>[
                  _OutputRow(label: 'plaintext', value: _result!.plaintext),
                  _OutputRow(
                    label: 'sha256(base64)',
                    value: _result!.sha256Base64,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _OutputCard(
                title: 'HMAC sign + verify',
                description:
                    'HMAC proves that the message came from someone holding the shared secret key and that the content was not modified.',
                rows: <_OutputRow>[
                  _OutputRow(
                    label: 'secret key',
                    value: _result!.hmacKeyBase64,
                  ),
                  _OutputRow(
                    label: 'signature',
                    value: _result!.hmacSignatureBase64,
                  ),
                  _OutputRow(
                    label: 'verified',
                    value: _result!.hmacVerified ? 'true' : 'false',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _OutputCard(
                title: 'AES-GCM encrypt + decrypt',
                description:
                    'AES-GCM gives confidentiality and integrity together. The same key and IV decrypt the ciphertext, and tampering breaks verification.',
                rows: <_OutputRow>[
                  _OutputRow(label: 'aes key', value: _result!.aesKeyBase64),
                  _OutputRow(label: 'iv', value: _result!.ivBase64),
                  _OutputRow(
                    label: 'additional data',
                    value: _result!.additionalData,
                  ),
                  _OutputRow(
                    label: 'ciphertext',
                    value: _result!.ciphertextBase64,
                  ),
                  _OutputRow(label: 'decrypted', value: _result!.decryptedText),
                ],
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _UseCasesCard extends StatelessWidget {
  const _UseCasesCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'What webcrypto is for',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const <Widget>[
                _UseCaseChip(
                  icon: Icons.security_outlined,
                  label: 'Cross-platform crypto API',
                ),
                _UseCaseChip(
                  icon: Icons.vpn_key_outlined,
                  label: 'Generate keys and IVs',
                ),
                _UseCaseChip(
                  icon: Icons.verified_outlined,
                  label: 'Integrity verification',
                ),
                _UseCaseChip(
                  icon: Icons.draw_outlined,
                  label: 'Message signing',
                ),
                _UseCaseChip(
                  icon: Icons.lock_outline,
                  label: 'Authenticated encryption',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Compared with the `crypto` package, `webcrypto` goes beyond digests and HMAC. It also covers secure random generation, key handling, and modern encryption/signature primitives with a consistent API on Flutter mobile, desktop, and web.',
            ),
          ],
        ),
      ),
    );
  }
}

class _UseCaseChip extends StatelessWidget {
  const _UseCaseChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }
}

class _OutputCard extends StatelessWidget {
  const _OutputCard({
    required this.title,
    required this.description,
    required this.rows,
  });

  final String title;
  final String description;
  final List<_OutputRow> rows;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            ...rows.map((_OutputRow row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      row.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      row.value,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _OutputRow {
  const _OutputRow({required this.label, required this.value});

  final String label;
  final String value;
}
