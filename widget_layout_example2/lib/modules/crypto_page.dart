import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'CryptoRoute')
class CryptoPage extends StatelessWidget {
  const CryptoPage({super.key});

  static const String _message =
      'Flutter makes UI fast. crypto makes digests easy.';
  static const String _secretKey = 'widget-layout-example2-secret';

  List<_CryptoExample> _examples() {
    return <_CryptoExample>[
      _CryptoExample(
        title: 'MD5',
        description:
            'MD5 is fast and common in legacy systems, but it is not suitable for security-sensitive hashing.',
        inputText: _message,
        code: '''
final bytes = utf8.encode(message);
final digest = md5.convert(bytes);
print(digest.toString());
''',
        computeResult: () => md5.convert(utf8.encode(_message)).toString(),
        color: Colors.blue,
      ),
      _CryptoExample(
        title: 'SHA-1',
        description:
            'SHA-1 is stronger than MD5 historically, but it is also no longer recommended for security use.',
        inputText: _message,
        code: '''
final digest = sha1.convert(utf8.encode(message));
print(digest.toString());
''',
        computeResult: () => sha1.convert(utf8.encode(_message)).toString(),
        color: Colors.teal,
      ),
      _CryptoExample(
        title: 'SHA-256',
        description:
            'SHA-256 is a good default when you need a modern fixed-size digest for files, tokens, or cache keys.',
        inputText: _message,
        code: '''
final digest = sha256.convert(utf8.encode(message));
print(digest.toString());
''',
        computeResult: () => sha256.convert(utf8.encode(_message)).toString(),
        color: Colors.green,
      ),
      _CryptoExample(
        title: 'SHA-512',
        description:
            'SHA-512 produces a longer digest and is useful when you want a wider hash output from the same input.',
        inputText: _message,
        code: '''
final digest = sha512.convert(utf8.encode(message));
print(digest.toString());
''',
        computeResult: () => sha512.convert(utf8.encode(_message)).toString(),
        color: Colors.deepPurple,
      ),
      _CryptoExample(
        title: 'HMAC SHA-256',
        description:
            'HMAC combines a digest algorithm with a secret key so the output can be verified but not forged without the key.',
        inputText: _message,
        secondaryText: 'Secret key: $_secretKey',
        code: '''
final hmac = Hmac(sha256, utf8.encode(secretKey));
final digest = hmac.convert(utf8.encode(message));
print(digest.toString());
''',
        computeResult: () => Hmac(
          sha256,
          utf8.encode(_secretKey),
        ).convert(utf8.encode(_message)).toString(),
        color: Colors.orange,
      ),
      _CryptoExample(
        title: 'Chunked Conversion',
        description:
            'For large streams or files, you can feed the hash incrementally instead of building one huge byte list first.',
        inputText: _message,
        secondaryText:
            'Chunks: "Flutter makes UI fast. " + "crypto makes digests easy."',
        code: '''
final sink = AccumulatorSink<Digest>();
final input = sha256.startChunkedConversion(sink);

input.add(utf8.encode('Flutter makes UI fast. '));
input.add(utf8.encode('crypto makes digests easy.'));
input.close();

final digest = sink.events.single;
print(digest.toString());
''',
        computeResult: () => _chunkedSha256(_message).toString(),
        color: Colors.redAccent,
      ),
    ];
  }

  Digest _chunkedSha256(String message) {
    final _SingleDigestSink digestSink = _SingleDigestSink();
    final ByteConversionSink byteSink = sha256.startChunkedConversion(
      digestSink,
    );
    final List<String> parts = <String>[
      message.substring(0, 23),
      message.substring(23),
    ];

    for (final String part in parts) {
      byteSink.add(utf8.encode(part));
    }
    byteSink.close();

    return digestSink.value!;
  }

  @override
  Widget build(BuildContext context) {
    final List<_CryptoExample> examples = _examples();

    return Scaffold(
      appBar: AppBar(title: const Text('crypto Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'The crypto package provides hashing and message-authentication tools such as MD5, SHA-family digests, and HMAC.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _CryptoInfoCard(
              title: 'Sample Input',
              description:
                  'Message: "Flutter makes UI fast. crypto makes digests easy."\nSecret key: "widget-layout-example2-secret"',
            ),
            const SizedBox(height: 16),
            const _CryptoInfoCard(
              title: 'Common Usage',
              description:
                  'Use crypto when you need deterministic digests for file verification, cache keys, signatures, API request authentication, or tamper detection. Prefer SHA-256 or HMAC over MD5/SHA-1 for modern security-sensitive work.',
            ),
            const SizedBox(height: 16),
            ...examples.map((_CryptoExample example) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _CryptoExampleCard(example: example),
              );
            }),
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

class _CryptoExample {
  const _CryptoExample({
    required this.title,
    required this.description,
    required this.inputText,
    required this.code,
    required this.computeResult,
    required this.color,
    this.secondaryText,
  });

  final String title;
  final String description;
  final String inputText;
  final String code;
  final String Function() computeResult;
  final Color color;
  final String? secondaryText;
}

class _CryptoInfoCard extends StatelessWidget {
  const _CryptoInfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class _CryptoExampleCard extends StatefulWidget {
  const _CryptoExampleCard({required this.example});

  final _CryptoExample example;

  @override
  State<_CryptoExampleCard> createState() => _CryptoExampleCardState();
}

class _CryptoExampleCardState extends State<_CryptoExampleCard> {
  String? _result;

  @override
  Widget build(BuildContext context) {
    final _CryptoExample example = widget.example;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              example.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(example.description),
            const SizedBox(height: 16),
            _CryptoTextPanel(
              title: 'Input Text',
              value: example.inputText,
              color: example.color,
            ),
            if (example.secondaryText
                case final String secondaryText) ...<Widget>[
              const SizedBox(height: 12),
              _CryptoTextPanel(
                title: 'Additional Input',
                value: secondaryText,
                color: example.color,
              ),
            ],
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: example.color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: example.color.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                example.code.trim(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _result = example.computeResult();
                });
              },
              icon: const Icon(Icons.play_arrow_outlined),
              label: Text('Show ${example.title} Result'),
            ),
            if (_result != null) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                'Digest Output',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              SelectableText(
                _result!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CryptoTextPanel extends StatelessWidget {
  const _CryptoTextPanel({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          SelectableText(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}

class _SingleDigestSink implements Sink<Digest> {
  Digest? value;

  @override
  void add(Digest data) {
    value = data;
  }

  @override
  void close() {}
}
