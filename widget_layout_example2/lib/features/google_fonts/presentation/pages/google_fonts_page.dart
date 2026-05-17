import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.googleFonts)
class GoogleFontsPage extends StatelessWidget {
  const GoogleFontsPage({super.key});

  static const String _headlineSample =
      'Launch faster with typography that feels intentional.';
  static const String _bodySample =
      'google_fonts lets Flutter apply curated typefaces through TextStyle '
      'and TextTheme APIs. It is useful when you want stronger brand voice, '
      'clearer hierarchy, or a different reading tone without manually '
      'managing font files in every screen example.';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme previewTextTheme = GoogleFonts.latoTextTheme(textTheme)
        .copyWith(
          headlineSmall: GoogleFonts.playfairDisplay(
            textStyle: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          titleMedium: GoogleFonts.oswald(
            textStyle: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: colorScheme.primary,
            ),
          ),
          bodyLarge: GoogleFonts.lora(
            textStyle: textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: colorScheme.onSurface,
            ),
          ),
          labelLarge: GoogleFonts.robotoMono(
            textStyle: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('google_fonts Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'google_fonts changes the voice of your UI, not just the size of text.',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Use `GoogleFonts.someFont(...)` for one widget, or '
              '`GoogleFonts.someFontTextTheme(...)` to restyle a whole subtree.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            _SectionCard(
              title: '1. Same sentence, different tone',
              child: Column(
                children: <Widget>[
                  _TypographyPreviewTile(
                    title: 'Default Material typography',
                    caption: 'Useful as a baseline from the current app theme.',
                    text: _headlineSample,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TypographyPreviewTile(
                    title: 'Playfair Display headline',
                    caption:
                        'A serif display font makes the same headline feel more editorial and premium.',
                    text: _headlineSample,
                    style: GoogleFonts.playfairDisplay(
                      textStyle: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6B2F1A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TypographyPreviewTile(
                    title: 'Oswald product label',
                    caption:
                        'A condensed sans-serif font creates sharper utility labels and section headers.',
                    text: 'BUILD STATUS / TYPOGRAPHY PREVIEW',
                    style: GoogleFonts.oswald(
                      textStyle: textTheme.titleLarge?.copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '2. Local TextStyle usage',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'The most direct use is styling one Text widget without changing the rest of the page.',
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Readable body copy with Lora',
                            style: GoogleFonts.lora(
                              textStyle: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _bodySample,
                            style: GoogleFonts.lora(
                              textStyle: textTheme.bodyLarge?.copyWith(
                                height: 1.7,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'final style = GoogleFonts.robotoMono(fontSize: 13);',
                            style: GoogleFonts.robotoMono(
                              textStyle: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '3. Theme a whole subtree',
              child: Theme(
                data: theme.copyWith(textTheme: previewTextTheme),
                child: Builder(
                  builder: (BuildContext context) {
                    final ColorScheme previewScheme = Theme.of(
                      context,
                    ).colorScheme;

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: previewScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Release Notes',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'A text theme override can change headings, body copy, and labels together.',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'This is the common pattern for landing pages, article readers, or branded surfaces where multiple text roles need a consistent type system.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: <Widget>[
                                FilledButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Apply Theme',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'v1.0.0 typography preview',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '4. What google_fonts is good for',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const <Widget>[
                  _UseCaseChip(
                    title: 'Brand tone',
                    subtitle:
                        'Make headlines feel editorial, playful, technical, or premium.',
                  ),
                  _UseCaseChip(
                    title: 'Hierarchy',
                    subtitle:
                        'Use different families for headings, body copy, and utility labels.',
                  ),
                  _UseCaseChip(
                    title: 'Scoped theming',
                    subtitle:
                        'Restyle one section with a custom TextTheme instead of the full app.',
                  ),
                  _UseCaseChip(
                    title: 'Fast experiments',
                    subtitle:
                        'Try fonts through code before deciding whether a full custom theme is worth it.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard();

  static const String _sampleCode = '''
Text(
  'Brand headline',
  style: GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  ),
);

final textTheme = GoogleFonts.latoTextTheme(
  Theme.of(context).textTheme,
);

Theme(
  data: Theme.of(context).copyWith(textTheme: textTheme),
  child: const MarketingPanel(),
);
''';

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: const Color(0xFF0F172A),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Minimal API surface',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The package mainly exposes two patterns: create one TextStyle, or replace a TextTheme.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 16),
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  _sampleCode,
                  style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: Color(0xFFE5E7EB),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypographyPreviewTile extends StatelessWidget {
  const _TypographyPreviewTile({
    required this.title,
    required this.caption,
    required this.text,
    required this.style,
  });

  final String title;
  final String caption;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
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
            Text(caption, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text(text, style: style),
          ],
        ),
      ),
    );
  }
}

class _UseCaseChip extends StatelessWidget {
  const _UseCaseChip({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 300),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
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
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
