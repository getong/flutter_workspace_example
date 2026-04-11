import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@RoutePage(name: 'FlutterDotenvRoute')
class FlutterDotenvPage extends StatefulWidget {
  const FlutterDotenvPage({super.key});

  @override
  State<FlutterDotenvPage> createState() => _FlutterDotenvPageState();
}

class _FlutterDotenvPageState extends State<FlutterDotenvPage> {
  final DotEnv _dotEnv = DotEnv();
  late final TextEditingController _baseController;
  late final TextEditingController _overrideController;

  String _status =
      'Load and parse environment variables to inspect typed accessors and overrides.';
  String _prettyEnv = '{}';
  Map<String, Object> _typedValues = <String, Object>{};

  @override
  void initState() {
    super.initState();
    _baseController = TextEditingController(
      text:
          'API_HOST=https://api.widget.dev\n'
          'API_PORT=443\n'
          'USE_TLS=true\n'
          'TIMEOUT_SECONDS=2.5\n'
          'API_URL=\$API_HOST/v1\n'
          'GREETING=hello widget world',
    );
    _overrideController = TextEditingController(
      text: 'USE_TLS=false\nAPI_PORT=8080',
    );
    _loadPreview();
  }

  @override
  void dispose() {
    _baseController.dispose();
    _overrideController.dispose();
    super.dispose();
  }

  void _loadPreview() {
    try {
      _dotEnv.loadFromString(
        envString: _baseController.text,
        overrideWith: <String>[_overrideController.text],
        mergeWith: <String, String>{
          'MODULE_NAME': 'flutter_dotenv',
          'BUILD_TARGET': 'demo',
        },
      );

      final Map<String, Object> typedValues = <String, Object>{
        'host': _dotEnv.get('API_HOST'),
        'port': _dotEnv.getInt('API_PORT'),
        'useTls': _dotEnv.getBool('USE_TLS'),
        'timeout': _dotEnv.getDouble('TIMEOUT_SECONDS'),
        'apiUrl': _dotEnv.maybeGet('API_URL', fallback: 'missing') ?? 'missing',
        'missingFallback':
            _dotEnv.maybeGet('UNSET_VALUE', fallback: 'fallback') ?? 'fallback',
        'requiredKeysOk': _dotEnv.isEveryDefined(<String>[
          'API_HOST',
          'API_PORT',
          'USE_TLS',
        ]),
      };

      setState(() {
        _typedValues = typedValues;
        _prettyEnv = const JsonEncoder.withIndent('  ').convert(_dotEnv.env);
        _status =
            'Parsed env strings successfully with overrides and merged values.';
      });
    } catch (error) {
      setState(() {
        _status = 'Failed to parse env values: $error';
        _typedValues = <String, Object>{};
        _prettyEnv = '{}';
      });
    }
  }

  void _clearEnv() {
    _dotEnv.clean();
    setState(() {
      _typedValues = <String, Object>{};
      _prettyEnv = '{}';
      _status = 'Called clean() on the DotEnv instance.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_dotenv Module')),
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
                      'Use `flutter_dotenv` to parse env strings and read typed configuration values.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates `DotEnv`, `loadFromString`, '
                      '`overrideWith`, `mergeWith`, `env`, `get`, `maybeGet`, '
                      '`getInt`, `getDouble`, `getBool`, `isEveryDefined`, and `clean`.',
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
                      'Source Strings',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _baseController,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: 'Base envString',
                        border: OutlineInputBorder(),
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _overrideController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'overrideWith entry',
                        helperText: 'Later values override earlier ones.',
                        border: OutlineInputBorder(),
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _loadPreview,
                          icon: const Icon(Icons.play_arrow_outlined),
                          label: const Text('Parse Env'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _clearEnv,
                          icon: const Icon(Icons.cleaning_services_outlined),
                          label: const Text('Clean Env'),
                        ),
                      ],
                    ),
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
                      'Typed Accessors',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _typedValues.entries
                          .map(
                            (MapEntry<String, Object> entry) => Chip(
                              label: Text('${entry.key}: ${entry.value}'),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CodeCard(title: 'Resolved env Map', code: _prettyEnv),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Core flutter_dotenv Pattern',
              code: r'''
final DotEnv dotEnv = DotEnv();

dotEnv.loadFromString(
  envString: baseEnv,
  overrideWith: <String>[overrideEnv],
  mergeWith: <String, String>{'MODULE_NAME': 'flutter_dotenv'},
);

final String host = dotEnv.get('API_HOST');
final int port = dotEnv.getInt('API_PORT');
final bool useTls = dotEnv.getBool('USE_TLS');
final double timeout = dotEnv.getDouble('TIMEOUT_SECONDS');
final String? missing = dotEnv.maybeGet('UNSET_VALUE', fallback: 'fallback');
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
