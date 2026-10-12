import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/envied/data/config/envied_demo_env.dart';

@RoutePage(name: RouteName.envied)
class EnviedPage extends StatefulWidget {
  const EnviedPage({super.key});

  @override
  State<EnviedPage> createState() => _EnviedPageState();
}

class _EnviedPageState extends State<EnviedPage> {
  EnviedDemoFlavor _flavor = EnviedDemoFlavor.dev;
  bool _revealApiKey = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final EnviedDemoEnv env = EnviedDemoEnv(_flavor);

    final Map<String, Object?> typedValues = <String, Object?>{
      'apiHost (String)': env.apiHost,
      'apiPort (int)': env.apiPort,
      'useTls (bool)': env.useTls,
      'timeoutSeconds (double)': env.timeoutSeconds,
      'apiBaseUrl (Uri)': env.apiBaseUrl,
      'releaseDate (DateTime)': env.releaseDate.toIso8601String(),
      'logLevel (enum)': env.logLevel.name,
      'greeting (String)': env.greeting,
      'retryCount (defaultValue)': env.retryCount,
      'sentryDsn (optional)': env.sentryDsn,
      'buildLabel (static const)': EnviedDemoBuildInfo.buildLabel,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('envied Module')),
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
                      'Use `envied` to compile `.env` files into typed Dart fields.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'build_runner reads env/envied_demo.env and '
                      'env/envied_demo.staging.env at build time. Missing keys '
                      'and wrong types fail the build instead of crashing at '
                      'runtime, and no .env asset ships with the app.',
                      style: theme.textTheme.bodyLarge,
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
                      'Flavor',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<EnviedDemoFlavor>(
                      key: const Key('envied.flavor'),
                      segments: const <ButtonSegment<EnviedDemoFlavor>>[
                        ButtonSegment<EnviedDemoFlavor>(
                          value: EnviedDemoFlavor.dev,
                          label: Text('dev'),
                        ),
                        ButtonSegment<EnviedDemoFlavor>(
                          value: EnviedDemoFlavor.staging,
                          label: Text('staging'),
                        ),
                      ],
                      selected: <EnviedDemoFlavor>{_flavor},
                      onSelectionChanged: (Set<EnviedDemoFlavor> selection) {
                        setState(() {
                          _flavor = selection.single;
                          _revealApiKey = false;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _flavor == EnviedDemoFlavor.dev
                          ? 'Generated class: _EnviedDemoDevEnv'
                          : 'Generated class: _EnviedDemoStagingEnv '
                                '(inherits unset keys from the dev file)',
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
                      'Typed Fields',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: typedValues.entries
                          .map(
                            (MapEntry<String, Object?> entry) => Chip(
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Obfuscated Field',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '`@EnviedField(obfuscate: true)` stores the value as two '
                      'XOR\'d int lists, so it is not a plain string in the '
                      'binary. This only raises the bar: anything shipped in '
                      'a client can still be recovered, so keep real secrets '
                      'on a server.',
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      _revealApiKey
                          ? env.apiKey
                          : '${env.apiKey.substring(0, 8)}${'•' * 12}',
                      key: const Key('envied.apiKey'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () =>
                          setState(() => _revealApiKey = !_revealApiKey),
                      icon: Icon(
                        _revealApiKey
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      label: Text(
                        _revealApiKey ? 'Hide apiKey' : 'Show apiKey',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'env/envied_demo.staging.env',
              code: r'''
API_HOST=http://staging.widget.dev
API_PORT=8080
USE_TLS=false
API_BASE_URL=${API_HOST}/v1
LOG_LEVEL=debug
API_KEY=sk_staging_...
''',
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'Core envied Pattern',
              code: r'''
part 'envied_demo_env.g.dart';

@Envied(name: 'EnviedDemoDevEnv', path: 'env/envied_demo.env',
    requireEnvFile: true, useConstantCase: true)
@Envied(name: 'EnviedDemoStagingEnv', path: 'env/envied_demo.staging.env',
    inheritFrom: <String>['env/envied_demo.env'],
    requireEnvFile: true, useConstantCase: true)
abstract final class EnviedDemoEnv {
  factory EnviedDemoEnv(EnviedDemoFlavor flavor) => switch (flavor) {
    EnviedDemoFlavor.dev => _EnviedDemoDevEnv(),
    EnviedDemoFlavor.staging => _EnviedDemoStagingEnv(),
  };

  @EnviedField()
  abstract final int apiPort;            // API_PORT

  @EnviedField(defaultValue: 3)
  abstract final int retryCount;         // compiled-in fallback

  @EnviedField(optional: true)
  abstract final String? sentryDsn;      // null when missing

  @EnviedField(obfuscate: true)
  abstract final String apiKey;          // XOR-encrypted
}

// Regenerate after editing env files:
// flutter pub run build_runner build
''',
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'Migrating from flutter_dotenv',
              code: '''
flutter_dotenv                      envied
--------------------------------    ---------------------------------
await dotenv.load()  (runtime)      nothing to load (build time)
dotenv.getInt('API_PORT')           env.apiPort  (int field)
maybeGet(key, fallback: x)          @EnviedField(defaultValue: x)
isEveryDefined([...])               missing keys fail the build
mergeWith / overrideWith            inheritFrom + one file per flavor
.env bundled as a plain asset       values compiled, optionally obfuscated
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
