import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class TextRichPage extends StatelessWidget {
  const TextRichPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text.rich Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Text.rich lets you combine multiple TextSpan styles and inline widgets inside a single block of text.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _TextRichExampleCard(
              title: 'Mixed Styling',
              description:
                  'Use different weights, colors, and emphasis within one sentence.',
              child: Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: <InlineSpan>[
                    const TextSpan(text: 'Build '),
                    TextSpan(
                      text: 'clear',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ', '),
                    const TextSpan(
                      text: 'readable',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    const TextSpan(text: ', and '),
                    TextSpan(
                      text: 'expressive',
                      style: TextStyle(
                        color: Colors.deepOrange.shade600,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' UI copy with one Text widget.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _TextRichExampleCard(
              title: 'Inline Icon And Action',
              description:
                  'TextSpan and WidgetSpan can be combined to add icons and tappable segments.',
              child: Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: <InlineSpan>[
                    const TextSpan(text: 'Review the '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.description_outlined,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const TextSpan(text: 'documentation and tap '),
                    TextSpan(
                      text: 'here',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Inline TextSpan tap handled.'),
                            ),
                          );
                        },
                    ),
                    const TextSpan(text: ' to trigger an inline action.'),
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

class _TextRichExampleCard extends StatelessWidget {
  const _TextRichExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

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
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
