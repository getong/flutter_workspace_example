import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.placeholder)
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Placeholder Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Placeholder',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Placeholder draws a box with an X through it, useful during '
              'development to mark spots where real widgets will go.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 24),

            // ── Default Placeholder ────────────────────────────────────────
            _SectionHeader(title: '1. Default Placeholder'),
            const Text(
              'With no arguments, Placeholder expands to fill its parent '
              'or falls back to 400×400.',
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 160, child: Placeholder()),
            _CodeBlock(
              code:
                  'SizedBox(\n'
                  '  height: 160,\n'
                  '  child: Placeholder(),\n'
                  ')',
            ),
            const SizedBox(height: 24),

            // ── Custom Color & StrokeWidth ─────────────────────────────────
            _SectionHeader(title: '2. Custom Color and Stroke Width'),
            const Text(
              'Set color and strokeWidth to match your design language '
              'during mocking.',
            ),
            const SizedBox(height: 8),
            const SizedBox(
              height: 140,
              child: Placeholder(color: Colors.deepPurple, strokeWidth: 4.0),
            ),
            _CodeBlock(
              code:
                  'Placeholder(\n'
                  '  color: Colors.deepPurple,\n'
                  '  strokeWidth: 4.0,\n'
                  ')',
            ),
            const SizedBox(height: 24),

            // ── Fallback Size ──────────────────────────────────────────────
            _SectionHeader(title: '3. Explicit Fallback Size'),
            const Text(
              'fallbackWidth and fallbackHeight control the size when the '
              'parent is unconstrained — useful inside scrollable containers.',
            ),
            const SizedBox(height: 8),
            const Placeholder(
              fallbackWidth: double.infinity,
              fallbackHeight: 100,
              color: Colors.teal,
            ),
            _CodeBlock(
              code:
                  'Placeholder(\n'
                  '  fallbackWidth: double.infinity,\n'
                  '  fallbackHeight: 100,\n'
                  '  color: Colors.teal,\n'
                  ')',
            ),
            const SizedBox(height: 24),

            // ── Placeholder as child ───────────────────────────────────────
            _SectionHeader(title: '4. Placeholder Inside a Card'),
            const Text(
              'Drop Placeholder anywhere a real widget will eventually go.',
            ),
            const SizedBox(height: 8),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Placeholder(fallbackHeight: 180, color: Colors.orange),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Placeholder(fallbackHeight: 20, color: Colors.grey),
                        SizedBox(height: 8),
                        Placeholder(fallbackHeight: 14, color: Colors.grey),
                        SizedBox(height: 4),
                        Placeholder(fallbackHeight: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _CodeBlock(
              code:
                  'Card(\n'
                  '  child: Column(children: [\n'
                  '    Placeholder(fallbackHeight: 180),\n'
                  '    Placeholder(fallbackHeight: 20),  // title\n'
                  '    Placeholder(fallbackHeight: 14),  // body\n'
                  '  ]),\n'
                  ')',
            ),
            const SizedBox(height: 24),

            // ── Placeholder in Row ─────────────────────────────────────────
            _SectionHeader(title: '5. Placeholder Inside a Row (Expanded)'),
            const Text(
              'Use Expanded so the Placeholder fills remaining horizontal '
              'space next to a real widget.',
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.image, size: 64, color: Colors.blueGrey),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Placeholder(
                      fallbackHeight: 60,
                      color: Colors.blueAccent,
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ),
            ),
            _CodeBlock(
              code:
                  'Row(children: [\n'
                  '  Icon(Icons.image, size: 64),\n'
                  '  SizedBox(width: 12),\n'
                  '  Expanded(\n'
                  '    child: Placeholder(fallbackHeight: 60),\n'
                  '  ),\n'
                  '])',
            ),
            const SizedBox(height: 24),

            // ── Placeholder in ListView ────────────────────────────────────
            _SectionHeader(title: '6. Skeleton / Loading Pattern'),
            const Text(
              'Use multiple Placeholders to mock a loading skeleton before '
              'real data arrives.',
            ),
            const SizedBox(height: 8),
            ...<Widget>[
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: <Widget>[
                      const Placeholder(
                        fallbackWidth: 48,
                        fallbackHeight: 48,
                        color: Colors.grey,
                        strokeWidth: 1,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Placeholder(
                              fallbackHeight: 14,
                              color: Colors.grey,
                              strokeWidth: 1,
                            ),
                            SizedBox(height: 6),
                            Placeholder(
                              fallbackHeight: 14,
                              color: Colors.grey,
                              strokeWidth: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            _CodeBlock(
              code:
                  '// Skeleton row\n'
                  'Row(children: [\n'
                  '  Placeholder(fallbackWidth: 48, fallbackHeight: 48),\n'
                  '  Expanded(\n'
                  '    child: Column(children: [\n'
                  '      Placeholder(fallbackHeight: 14),\n'
                  '      Placeholder(fallbackHeight: 14),\n'
                  '    ]),\n'
                  '  ),\n'
                  '])',
            ),
            const SizedBox(height: 80),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
