import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:encrypter_plus/encrypter_plus.dart' as ep;
import 'package:flutter/material.dart';

@RoutePage(name: 'EncrypterPlusRoute')
class EncrypterPlusPage extends StatefulWidget {
  const EncrypterPlusPage({super.key});

  @override
  State<EncrypterPlusPage> createState() => _EncrypterPlusPageState();
}

class _EncrypterPlusPageState extends State<EncrypterPlusPage> {
  static final Uint8List _stretchSalt = Uint8List.fromList(
    utf8.encode('module-salt-demo'),
  );
  static final Uint8List _associatedData = Uint8List.fromList(
    utf8.encode('module:encrypter'),
  );
  static final ep.IV _derivedIv = ep.IV.fromUtf8('demo-init-vector');

  late final TextEditingController _messageController;
  late final TextEditingController _secretController;

  ep.Key _sessionKey = ep.Key.fromSecureRandom(32);
  ep.IV _sessionIv = ep.IV.fromSecureRandom(16);
  String _status =
      'Encrypt the sample message to inspect generated keys, IV values, and cipher text.';
  _EncryptionSnapshot? _derivedSnapshot;
  _EncryptionSnapshot? _sessionSnapshot;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(
      text: 'Flutter modules can demonstrate practical encryption flows.',
    );
    _secretController = TextEditingController(text: 'short');
    _runDerivedEncryption();
    _runSessionEncryption();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  ep.Key _derivedKey() {
    return ep.Key.fromUtf8(
      _secretController.text,
    ).stretch(32, salt: _stretchSalt);
  }

  void _runDerivedEncryption() {
    final ep.Key key = _derivedKey();
    final ep.Encrypter encrypter = ep.Encrypter(
      ep.AES(key, mode: ep.AESMode.gcm),
    );
    final String message = _messageController.text;

    try {
      final ep.Encrypted encrypted = encrypter.encrypt(
        message,
        iv: _derivedIv,
        associatedData: _associatedData,
      );
      final String decryptedFromBase64 = encrypter.decrypt64(
        encrypted.base64,
        iv: _derivedIv,
        associatedData: _associatedData,
      );
      final String decryptedFromBase16 = encrypter.decrypt(
        ep.Encrypted.fromBase16(encrypted.base16),
        iv: _derivedIv,
        associatedData: _associatedData,
      );
      final ep.Encrypted encryptedBytes = encrypter.encryptBytes(
        utf8.encode(message),
        iv: _derivedIv,
        associatedData: _associatedData,
      );
      final String decryptedBytes = utf8.decode(
        encrypter.decryptBytes(
          encryptedBytes,
          iv: _derivedIv,
          associatedData: _associatedData,
        ),
      );

      setState(() {
        _derivedSnapshot = _EncryptionSnapshot(
          modeLabel: 'AES-GCM with stretch()',
          keyBase64: key.base64,
          ivBase64: _derivedIv.base64,
          cipherBase64: encrypted.base64,
          cipherBase16: encrypted.base16,
          decryptedText: decryptedFromBase64,
          secondaryRoundTrip: decryptedFromBase16,
          bytesRoundTrip: decryptedBytes,
          encryptedByteLength: encryptedBytes.bytes.length,
        );
        _status = 'Derived-key AES/GCM encryption completed successfully.';
      });
    } catch (error) {
      setState(() {
        _status = 'Derived-key encryption failed: $error';
      });
    }
  }

  void _rotateSession() {
    setState(() {
      _sessionKey = ep.Key.fromSecureRandom(32);
      _sessionIv = ep.IV.fromSecureRandom(16);
      _status = 'Generated a new secure-random key and IV session.';
    });
    _runSessionEncryption();
  }

  void _runSessionEncryption() {
    final ep.Encrypter encrypter = ep.Encrypter(
      ep.AES(_sessionKey, mode: ep.AESMode.sic),
    );
    final String message = _messageController.text;

    try {
      final ep.Encrypted encrypted = encrypter.encrypt(message, iv: _sessionIv);
      final String decrypted = encrypter.decrypt(
        ep.Encrypted.fromBase64(encrypted.base64),
        iv: _sessionIv,
      );
      final ep.Encrypted encryptedBytes = encrypter.encryptBytes(
        utf8.encode(message),
        iv: _sessionIv,
      );
      final String decryptedBytes = utf8.decode(
        encrypter.decryptBytes(encryptedBytes, iv: _sessionIv),
      );

      setState(() {
        _sessionSnapshot = _EncryptionSnapshot(
          modeLabel: 'AES-SIC with secure random',
          keyBase64: _sessionKey.base64,
          ivBase64: _sessionIv.base64,
          cipherBase64: encrypted.base64,
          cipherBase16: encrypted.base16,
          decryptedText: decrypted,
          secondaryRoundTrip: decrypted,
          bytesRoundTrip: decryptedBytes,
          encryptedByteLength: encryptedBytes.bytes.length,
        );
        _status = 'Secure-random AES/SIC encryption completed successfully.';
      });
    } catch (error) {
      setState(() {
        _status = 'Secure-random encryption failed: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('encrypter_plus Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Use `encrypter_plus` to derive keys, encrypt text, and inspect byte-level round trips.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates `Key.fromUtf8`, `stretch`, '
                      '`Key.fromSecureRandom`, `IV.fromUtf8`, '
                      '`IV.fromSecureRandom`, `Encrypter`, `AES`, `AESMode.gcm`, '
                      '`AESMode.sic`, `encrypt`, `encryptBytes`, `decrypt`, '
                      '`decrypt64`, `decryptBytes`, and `Encrypted.fromBase16`.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(_status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Inputs',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _messageController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Plain text message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _secretController,
                      decoration: const InputDecoration(
                        labelText: 'Passphrase for stretch() demo',
                        helperText:
                            'Short values are expanded into a 32-byte key.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _runDerivedEncryption,
                          icon: const Icon(Icons.lock_outline),
                          label: const Text('Run AES-GCM'),
                        ),
                        FilledButton.icon(
                          onPressed: _runSessionEncryption,
                          icon: const Icon(Icons.enhanced_encryption_outlined),
                          label: const Text('Run AES-SIC'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _rotateSession,
                          icon: const Icon(Icons.casino_outlined),
                          label: const Text('Rotate Random Session'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_derivedSnapshot != null)
              _SnapshotCard(
                title: 'Derived Key Demo',
                subtitle:
                    'Stable IV + associated data makes this a clear AES/GCM example.',
                snapshot: _derivedSnapshot!,
              ),
            if (_derivedSnapshot != null) const SizedBox(height: 16),
            if (_sessionSnapshot != null)
              _SnapshotCard(
                title: 'Secure Random Demo',
                subtitle:
                    'This run uses `Key.fromSecureRandom` and `IV.fromSecureRandom` with AES/SIC.',
                snapshot: _sessionSnapshot!,
              ),
            if (_sessionSnapshot != null) const SizedBox(height: 16),
            _CodeCard(
              title: 'Core encrypter_plus Pattern',
              code: r'''
final key = Key.fromUtf8(secret).stretch(32, salt: salt);
final iv = IV.fromUtf8('demo-init-vector');
final aad = Uint8List.fromList(utf8.encode('module:encrypter'));
final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

final encrypted = encrypter.encrypt(
  plainText,
  iv: iv,
  associatedData: aad,
);

final decrypted = encrypter.decrypt64(
  encrypted.base64,
  iv: iv,
  associatedData: aad,
);
''',
            ),
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

class _EncryptionSnapshot {
  const _EncryptionSnapshot({
    required this.modeLabel,
    required this.keyBase64,
    required this.ivBase64,
    required this.cipherBase64,
    required this.cipherBase16,
    required this.decryptedText,
    required this.secondaryRoundTrip,
    required this.bytesRoundTrip,
    required this.encryptedByteLength,
  });

  final String modeLabel;
  final String keyBase64;
  final String ivBase64;
  final String cipherBase64;
  final String cipherBase16;
  final String decryptedText;
  final String secondaryRoundTrip;
  final String bytesRoundTrip;
  final int encryptedByteLength;
}

class _SnapshotCard extends StatelessWidget {
  const _SnapshotCard({
    required this.title,
    required this.subtitle,
    required this.snapshot,
  });

  final String title;
  final String subtitle;
  final _EncryptionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                Chip(label: Text(snapshot.modeLabel)),
                Chip(label: Text('bytes: ${snapshot.encryptedByteLength}')),
              ],
            ),
            const SizedBox(height: 12),
            _LabeledValue(label: 'Key (base64)', value: snapshot.keyBase64),
            _LabeledValue(label: 'IV (base64)', value: snapshot.ivBase64),
            _LabeledValue(
              label: 'Cipher text (base64)',
              value: snapshot.cipherBase64,
            ),
            _LabeledValue(
              label: 'Cipher text (base16)',
              value: snapshot.cipherBase16,
            ),
            _LabeledValue(
              label: 'decrypt64 result',
              value: snapshot.decryptedText,
            ),
            _LabeledValue(
              label: 'Encrypted.fromBase16 round trip',
              value: snapshot.secondaryRoundTrip,
            ),
            _LabeledValue(
              label: 'encryptBytes/decryptBytes round trip',
              value: snapshot.bytesRoundTrip,
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          SelectableText(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            SelectableText(
              code,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
