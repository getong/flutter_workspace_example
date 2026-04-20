import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TextStylePage extends StatelessWidget {
  const TextStylePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('TextStyle Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'TextStyle controls how text looks in Flutter, including size, weight, color, spacing, decoration, height, shadows, and painting.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'This page focuses on direct TextStyle usage and composition patterns you will use with Text, RichText, DefaultTextStyle, and theme-derived typography.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _TextStyleInfoCard(
              title: 'When TextStyle matters',
              description:
                  'TextStyle is the core styling object behind most text in Flutter. It is commonly passed directly to Text, copied from the theme with copyWith, or merged through DefaultTextStyle.',
            ),
            const SizedBox(height: 16),
            const _TextStyleInfoCard(
              title: 'Common properties',
              description:
                  'fontSize, fontWeight, fontStyle, color, letterSpacing, wordSpacing, height, decoration, shadows, backgroundColor, and foreground are the most common knobs you will adjust.',
            ),
            const SizedBox(height: 20),
            _TextStyleExampleCard(
              title: '1. Weight, size, and color',
              description:
                  'The most common use case is adjusting emphasis with size, weight, and color.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Display emphasis',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Section label',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Subtle secondary copy',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _TextStyleExampleCard(
              title: '2. Italic, letter spacing, and word spacing',
              description:
                  'TextStyle can tune the rhythm and tone of text, not just its size.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Refined editorial heading',
                    style: TextStyle(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Wider word spacing can make labels and short summaries easier to scan in some layouts.',
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 0.3,
                      wordSpacing: 3,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _TextStyleExampleCard(
              title: '3. Decoration and background color',
              description:
                  'Underline, line-through, overline, and backgroundColor are useful for inline emphasis and status text.',
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                children: const <Widget>[
                  Text(
                    'Underlined link',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Completed task',
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Flagged note',
                    style: TextStyle(
                      backgroundColor: Color(0xFFFFF1A8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _TextStyleExampleCard(
              title: '4. Line height for readable paragraphs',
              description:
                  'The height property controls line height and is useful for dense or roomy reading layouts.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Compact paragraph: Flutter renders fast UI by composing widgets into a tree and recalculating only the parts that need to change.',
                    style: TextStyle(fontSize: 14, height: 1.1),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Relaxed paragraph: Flutter renders fast UI by composing widgets into a tree and recalculating only the parts that need to change.',
                    style: TextStyle(fontSize: 14, height: 1.7),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _TextStyleExampleCard(
              title: '5. Shadows and visual treatment',
              description:
                  'TextStyle shadows help create depth or improve contrast in hero banners and highlighted labels.',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFF1E293B),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Shadowed banner title',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _TextStyleExampleCard(
              title: '6. Foreground paint for custom drawing',
              description:
                  'For advanced text treatment, use foreground with a Paint to draw strokes or gradient-like effects.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Outlined label',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.5
                        ..color = colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Gradient title',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[Colors.deepOrange, Colors.pink],
                        ).createShader(const Rect.fromLTWH(0, 0, 220, 60)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _TextStyleExampleCard(
              title: '7. copyWith from the theme',
              description:
                  'A common pattern is to start from the current theme and override just the properties you need.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Theme titleMedium with stronger emphasis',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Theme bodySmall adjusted for helper text',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.65),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _TextStyleExampleCard(
              title: '8. DefaultTextStyle.merge for shared styling',
              description:
                  'DefaultTextStyle.merge is useful when many child Text widgets should inherit the same base style.',
              child: _InheritedStyleExample(),
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

class _InheritedStyleExample extends StatelessWidget {
  const _InheritedStyleExample();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.teal),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.teal.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Shared base style',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'This paragraph inherits color, size, and height from DefaultTextStyle.merge.',
            ),
            Text(
              'Only the first line overrides some fields while the rest keep the shared base style.',
            ),
          ],
        ),
      ),
    );
  }
}

class _TextStyleExampleCard extends StatelessWidget {
  const _TextStyleExampleCard({
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

class _TextStyleInfoCard extends StatelessWidget {
  const _TextStyleInfoCard({required this.title, required this.description});

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
