import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.flutterMarkdownPlus)
class FlutterMarkdownPlusPage extends StatelessWidget {
  const FlutterMarkdownPlusPage({super.key});

  static const String _markdownSource = '''
# flutter_markdown_plus Demo

This package renders **Markdown** into Flutter widgets.

## What It Supports

- Headings
- Lists
- `inline code`
- fenced code blocks
- block quotes
- tables
- links like [Flutter](https://flutter.dev)

> Flutter is not an HTML renderer, so inline HTML support is intentionally limited.

## Code Block

```dart
Markdown(
  data: source,
  selectable: true,
)
```

## Table

| Widget | Typical use |
| --- | --- |
| `Markdown` | Scrollable markdown page |
| `MarkdownBody` | Embed markdown inside existing scroll layouts |

## Emoji

Direct emoji works: 😀 🎉 👍
''';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_markdown_plus Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'flutter_markdown_plus renders Markdown into rich Flutter text and layout widgets. It is best for docs screens, release notes, article readers, local help pages, and server-driven formatted content.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _SectionCard(
              title: 'Markdown vs MarkdownBody',
              description:
                  '`Markdown` gives you built-in scrolling and padding. `MarkdownBody` is better when the parent already scrolls and you only want the rendered content widget.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'const Markdown(data: source);\n'
                      'const MarkdownBody(data: source);',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Rule of thumb: use `Markdown` for full-page content, use `MarkdownBody` inside cards, list items, bottom sheets, or other existing scroll containers.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Rendered Example',
              description:
                  'This sample shows headings, bold, code, block quotes, tables, links, and emoji using one Markdown string.',
              child: Container(
                constraints: const BoxConstraints(maxHeight: 420),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Markdown(
                  data: _markdownSource,
                  selectable: true,
                  onTapLink: (String text, String? href, String title) =>
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped link: ${href ?? text}')),
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Embedding With MarkdownBody',
              description:
                  'When your page already uses `ListView` or `SingleChildScrollView`, `MarkdownBody` avoids nested scroll behavior and makes layout control easier.',
              child: Card(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownBody(
                    data:
                        '### Embedded MarkdownBody\n'
                        'Use this inside cards or dashboard sections.\n\n'
                        '- No internal scroll view\n'
                        '- Easier parent layout control\n'
                        '- Good for small rich text fragments',
                    selectable: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Styling and Behavior',
              description:
                  'The package follows the current Material theme by default, but you can override typography, spacing, blockquote decoration, code styling, and interaction behavior.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text('Common customization points:'),
                  SizedBox(height: 8),
                  Text('• `styleSheet:` to override text and block styles'),
                  Text('• `selectable: true` to allow text selection'),
                  Text('• `onTapLink:` to handle link navigation yourself'),
                  Text(
                    '• `extensionSet:` when you want custom markdown syntax behavior',
                  ),
                  Text(
                    '• `imageBuilder:` or asset/resource paths when rendering markdown images',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Practical Notes',
              description:
                  'This package supports GitHub-flavored markdown by default and is good for tables and fenced code blocks, but it is not a full HTML engine.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text('Important usage guidance:'),
                  SizedBox(height: 8),
                  Text(
                    '• Prefer markdown content from trusted or sanitized sources.',
                  ),
                  Text(
                    '• Do not expect arbitrary inline HTML to render the way a browser does.',
                  ),
                  Text(
                    '• Use `resource:assets/...` paths for bundled asset images in markdown.',
                  ),
                  Text(
                    '• For app help pages, keep markdown in local constants or asset files for maintainability.',
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
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
