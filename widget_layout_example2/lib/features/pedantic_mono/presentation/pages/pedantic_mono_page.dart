import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.pedanticMono)
class PedanticMonoPage extends StatelessWidget {
  const PedanticMonoPage({super.key});

  static const List<String> _highlightRules = <String>[
    'strict-casts: true',
    'strict-inference: true',
    'always_declare_return_types',
    'prefer_final_locals',
    'type_annotate_public_apis',
    'unawaited_futures',
  ];

  static const String _analysisOptionsSnippet = '''
include: package:pedantic_mono/analysis_options.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
''';

  static const String _publicApiSnippet = '''
Future<String> loadGreeting() async {
  final String prefix = 'Hello';
  return '\$prefix, pedantic_mono';
}
''';

  static const String _asyncSnippet = '''
void refreshCache() {
  unawaited(_repository.preloadLatestPosts());
}
''';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('pedantic_mono Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'pedantic_mono is not a runtime widget package. It extends '
              '`flutter_lints` with stricter analyzer rules, so the most honest '
              'demo is a Flutter page that shows how to configure it and how it '
              'changes everyday Dart code.',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _PedanticCard(
              title: 'Lint Highlights',
              description:
                  'These rules noticeably change Flutter project code style '
                  'and static checking.',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _highlightRules
                    .map((String rule) => Chip(label: Text(rule)))
                    .toList(growable: false),
              ),
            ),
            const SizedBox(height: 16),
            const _PedanticCard(
              title: 'analysis_options.yaml',
              description:
                  'Point the project at `package:pedantic_mono/analysis_options.yaml` '
                  'to inherit the package defaults.',
              child: _CodeSnippetBox(code: _analysisOptionsSnippet),
            ),
            const SizedBox(height: 16),
            const _PedanticCard(
              title: 'Typed Public APIs',
              description:
                  'Rules like `always_declare_return_types` and '
                  '`type_annotate_public_apis` push public Flutter code toward '
                  'explicit contracts.',
              child: _CodeSnippetBox(code: _publicApiSnippet),
            ),
            const SizedBox(height: 16),
            const _PedanticCard(
              title: 'Explicit Async Intent',
              description:
                  'The lint set favors code that makes async fire-and-forget '
                  'work visible instead of accidental.',
              child: _CodeSnippetBox(code: _asyncSnippet),
            ),
            const SizedBox(height: 16),
            _PedanticCard(
              title: 'Why This Matters In Flutter',
              description:
                  'For UI modules like the ones in this app, stricter lints help '
                  'keep widget code predictable as pages grow.',
              child: Column(
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.rule_folder_outlined),
                    title: Text('Fewer implicit types in widget state'),
                  ),
                  ListTile(
                    leading: Icon(Icons.auto_fix_high_outlined),
                    title: Text('More final locals and clearer async intent'),
                  ),
                  ListTile(
                    leading: Icon(Icons.text_snippet_outlined),
                    title: Text(
                      'Public helpers stay readable during refactors',
                    ),
                  ),
                ],
              ),
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

class _PedanticCard extends StatelessWidget {
  const _PedanticCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

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
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _CodeSnippetBox extends StatelessWidget {
  const _CodeSnippetBox({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: SelectableText(
        code.trim(),
        style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
      ),
    );
  }
}
