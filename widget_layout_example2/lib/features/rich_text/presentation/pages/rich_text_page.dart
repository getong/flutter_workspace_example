import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.richText)
class RichTextPage extends StatefulWidget {
  const RichTextPage({super.key});

  @override
  State<RichTextPage> createState() => _RichTextPageState();
}

class _RichTextPageState extends State<RichTextPage> {
  late final TapGestureRecognizer _docsTapRecognizer;
  late final TapGestureRecognizer _highlightTapRecognizer;

  bool _docsOpened = false;
  bool _highlightActive = false;

  @override
  void initState() {
    super.initState();
    _docsTapRecognizer = TapGestureRecognizer()..onTap = _handleDocsTap;
    _highlightTapRecognizer = TapGestureRecognizer()
      ..onTap = _handleHighlightTap;
  }

  @override
  void dispose() {
    _docsTapRecognizer.dispose();
    _highlightTapRecognizer.dispose();
    super.dispose();
  }

  void _handleDocsTap() {
    setState(() {
      _docsOpened = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('RichText inline tap handled.')),
    );
  }

  void _handleHighlightTap() {
    setState(() {
      _highlightActive = !_highlightActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('RichText Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'RichText gives you direct control over styled text trees built from TextSpan and WidgetSpan.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'Unlike Text.rich, RichText exposes more of the underlying paragraph configuration such as textAlign, maxLines, overflow, and direct span composition.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _RichTextInfoCard(
              title: 'Why use RichText directly?',
              description:
                  'Use RichText when you want lower-level control over span trees, inline widgets, gesture recognizers, or paragraph behavior instead of relying on a simpler text helper.',
            ),
            const SizedBox(height: 16),
            const _RichTextInfoCard(
              title: 'Common building blocks',
              description:
                  'TextSpan styles text, WidgetSpan inserts widgets inline, and gesture recognizers make individual spans interactive.',
            ),
            const SizedBox(height: 24),
            _RichTextExampleCard(
              title: '1. Mixed styling with TextSpan',
              description:
                  'Build a sentence with multiple weights, colors, and decorations from one RichText widget.',
              child: RichText(
                text: TextSpan(
                  style: textTheme.bodyLarge,
                  children: <InlineSpan>[
                    const TextSpan(text: 'Compose '),
                    TextSpan(
                      text: 'headlines',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ', '),
                    const TextSpan(
                      text: 'notes',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    const TextSpan(text: ', and '),
                    TextSpan(
                      text: 'status labels',
                      style: TextStyle(
                        color: Colors.deepOrange.shade700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' in one paragraph.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _RichTextExampleCard(
              title: '2. Inline widgets with WidgetSpan',
              description:
                  'WidgetSpan lets you insert badges, icons, or chips inside flowing text.',
              child: RichText(
                text: TextSpan(
                  style: textTheme.bodyLarge,
                  children: <InlineSpan>[
                    const TextSpan(text: 'Release status: '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'STABLE',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(text: ' with '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.verified_outlined,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const TextSpan(
                      text: ' verified docs and production-ready examples.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _RichTextExampleCard(
              title: '3. Interactive spans',
              description:
                  'A single paragraph can contain tappable inline actions without turning the entire block into one button.',
              child: RichText(
                text: TextSpan(
                  style: textTheme.bodyLarge,
                  children: <InlineSpan>[
                    const TextSpan(text: 'Open the '),
                    TextSpan(
                      text: _docsOpened
                          ? 'documentation (opened)'
                          : 'documentation',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: _docsTapRecognizer,
                    ),
                    const TextSpan(text: ' or tap '),
                    TextSpan(
                      text: _highlightActive
                          ? 'disable emphasis'
                          : 'highlight this phrase',
                      style: TextStyle(
                        color: _highlightActive
                            ? Colors.deepOrange
                            : colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: _highlightTapRecognizer,
                    ),
                    TextSpan(
                      text: _highlightActive
                          ? ' to toggle the active state.'
                          : ' to toggle a visual state inside the page.',
                      style: TextStyle(
                        backgroundColor: _highlightActive
                            ? Colors.amber.withValues(alpha: 0.35)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _RichTextExampleCard(
              title: '4. Paragraph layout controls',
              description:
                  'RichText exposes alignment, line limits, and overflow behavior directly.',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 260,
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: textTheme.bodyMedium,
                          children: const <InlineSpan>[
                            TextSpan(
                              text:
                                  'This paragraph is intentionally long so you can see how RichText handles maxLines and ellipsis when the available width is limited inside a layout card.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: textTheme.bodyMedium,
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Centered subheading',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const TextSpan(
                            text:
                                '\nThe paragraph alignment is part of the RichText widget, not just the span styles.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _RichTextExampleCard(
              title: '5. RichText for editorial callouts',
              description:
                  'This pattern is useful for release notes, changelogs, and descriptive UI copy with inline emphasis.',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyLarge?.copyWith(height: 1.5),
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Version 2.4.0\n',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                      ),
                      const TextSpan(text: 'Added '),
                      const TextSpan(
                        text: 'offline drafts',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: ', improved '),
                      TextSpan(
                        text: 'accessibility labels',
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text: ', and reduced initial load time by ',
                      ),
                      TextSpan(
                        text: '34%',
                        style: TextStyle(
                          color: Colors.deepOrange.shade700,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const TextSpan(text: ' across the dashboard shell.'),
                    ],
                  ),
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

class _RichTextExampleCard extends StatelessWidget {
  const _RichTextExampleCard({
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

class _RichTextInfoCard extends StatelessWidget {
  const _RichTextInfoCard({required this.title, required this.description});

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
