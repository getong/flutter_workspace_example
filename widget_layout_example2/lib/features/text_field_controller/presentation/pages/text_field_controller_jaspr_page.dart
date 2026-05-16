import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.textFieldControllerJaspr)
class TextFieldControllerJasprPage extends StatelessWidget {
  const TextFieldControllerJasprPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Jaspr Text Field State Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'This page translates the TextField + TextEditingController Flutter example into Jaspr using the same component and event patterns used in the local Jaspr repository.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'In Flutter, TextEditingController gives programmatic access to a TextField value. '
              'In Jaspr, the equivalent pattern is controlled inputs backed by component state and updated with typed onInput handlers.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _InfoCard(
              title: 'Mapping from Flutter to Jaspr',
              description:
                  'Live preview becomes state + onInput. Programmatic writes become setState updates. '
                  'Two fields sharing one controller become two inputs bound to one state variable. '
                  'Independent controllers become separate state variables.',
            ),
            const SizedBox(height: 16),
            const _InfoCard(
              title: 'Jaspr patterns used here',
              description:
                  'The example follows the local Jaspr repository patterns from the weather-api sample for input handling and the dart_quotes app for server-side entry setup. '
                  'That means package:jaspr/dom.dart for HTML primitives, package:jaspr/jaspr.dart for the component model, and package:jaspr/server.dart when wrapping the app in a Document.',
            ),
            const SizedBox(height: 16),
            const _InfoCard(
              title: 'Why this is a separate route',
              description:
                  'This repository is a Flutter app, so the Jaspr example is shown as code and usage notes inside a normal Flutter route. '
                  'The standalone runnable Jaspr sample lives alongside this feature as a separate Dart file.',
            ),
            const SizedBox(height: 24),
            const _CodeCard(
              title: 'main.server.dart Style Entry',
              code: _jasprServerEntryCode,
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'app.dart Style Component',
              code: _jasprAppCode,
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'Typed Input Handling',
              code: _jasprInputCode,
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'Shared and Separate State Bindings',
              code: _jasprBindingCode,
            ),
            const SizedBox(height: 24),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Standalone file',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SelectableText(
                      'lib/features/text_field_controller/presentation/pages/text_field_controller_jaspr_example.dart',
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'That file contains the runnable Jaspr sample with the same four behaviors as the Flutter page: live preview, programmatic message updates, shared state inputs, and independent state inputs.',
                    ),
                  ],
                ),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
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

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.45,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                code,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String _jasprServerEntryCode = r'''
import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';

void main() {
  Jaspr.initializeApp();

  runApp(
    Document(
      title: 'Jaspr Text Field Controller Example',
      body: const TextFieldControllerJasprApp(),
    ),
  );
}
''';

const String _jasprAppCode = r'''
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class TextFieldControllerJasprApp extends StatelessComponent {
  const TextFieldControllerJasprApp({super.key});

  @override
  Component build(BuildContext context) {
    return .fragment([
      h1([.text('Text Field State in Jaspr')]),
      p([
        .text(
          'Jaspr replaces TextEditingController with stateful components and '
          'typed input callbacks.',
        ),
      ]),
      const TextFieldControllerJasprDemo(),
    ]);
  }
}
''';

const String _jasprInputCode = r'''
class TextFieldControllerJasprDemo extends StatefulComponent {
  const TextFieldControllerJasprDemo({super.key});

  @override
  State<TextFieldControllerJasprDemo> createState() =>
      _TextFieldControllerJasprDemoState();
}

class _TextFieldControllerJasprDemoState
    extends State<TextFieldControllerJasprDemo> {
  String name = 'Flutter learner';
  String message = '';
  String submittedMessage = 'Nothing submitted yet.';

  @override
  Component build(BuildContext context) {
    return div([
      input<String>(
        type: InputType.text,
        value: name,
        attributes: const {'placeholder': 'Type your name'},
        onInput: (value) => setState(() => name = value),
      ),
      p([.text(
        'Live preview: ${name.isEmpty ? '(empty)' : name}',
      )]),
      textarea(
        [.text(message)],
        rows: 2,
        placeholder: 'Write a short message',
        onInput: (value) => setState(() => message = value),
      ),
      button(
        [.text('Prefill Message')],
        onClick: () => setState(
          () => message = 'Hello, ${name.isEmpty ? 'friend' : name}!',
        ),
      ),
      button(
        [.text('Submit Message')],
        onClick: () => setState(
          () => submittedMessage =
              message.isEmpty ? 'Nothing submitted yet.' : message,
        ),
      ),
      p([.text('Submitted message: $submittedMessage')]),
    ]);
  }
}
''';

const String _jasprBindingCode = r'''
String sharedValue = 'Shared controller text';
String firstSeparateValue = 'First separate value';
String secondSeparateValue = 'Second separate value';

input<String>(
  value: sharedValue,
  onInput: (value) => setState(() => sharedValue = value),
);

input<String>(
  value: sharedValue,
  onInput: (value) => setState(() => sharedValue = value),
);

input<String>(
  value: firstSeparateValue,
  onInput: (value) => setState(() => firstSeparateValue = value),
);

input<String>(
  value: secondSeparateValue,
  onInput: (value) => setState(() => secondSeparateValue = value),
);
''';
