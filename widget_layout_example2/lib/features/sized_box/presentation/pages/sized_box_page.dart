import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.sizedBox)
class SizedBoxPage extends StatelessWidget {
  const SizedBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SizedBox Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const <Widget>[
            _SizedBoxIntro(),
            SizedBox(height: 20),
            _SizedBoxExampleCard(
              title: 'Tight width and height',
              description:
                  'A SizedBox is the direct way to force a widget into a known '
                  'footprint such as a button row or media tile.',
              codeLabel: 'SizedBox(width: 220, height: 56, child: ...)',
              child: _FixedSizeExample(),
            ),
            SizedBox(height: 16),
            _SizedBoxExampleCard(
              title: 'SizedBox.square',
              description:
                  'Square constraints are useful for avatar placeholders, icon '
                  'buttons, thumbnails, and color chips.',
              codeLabel: 'SizedBox.square(dimension: 76, child: ...)',
              child: _SquareExample(),
            ),
            SizedBox(height: 16),
            _SizedBoxExampleCard(
              title: 'SizedBox.expand',
              description:
                  'Expand makes the child fill the biggest size the parent allows.',
              codeLabel: 'SizedBox.expand(child: DecoratedBox(...))',
              child: _ExpandExample(),
            ),
            SizedBox(height: 16),
            _SizedBoxExampleCard(
              title: 'Spacing between widgets',
              description:
                  'Many Flutter layouts use `const SizedBox(height: ...)` or '
                  '`const SizedBox(width: ...)` as explicit, readable spacing.',
              codeLabel:
                  'Column(children: [Text(...), SizedBox(height: 12), Text(...)])',
              child: _SpacingExample(),
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

class _SizedBoxIntro extends StatelessWidget {
  const _SizedBoxIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'SizedBox creates explicit empty space or tight box constraints.',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          'The widget is small, but it shows up everywhere in Flutter UI: '
          'fixed controls, square surfaces, fill layouts, and intentional gaps '
          'between components.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _SizedBoxExampleCard extends StatelessWidget {
  const _SizedBoxExampleCard({
    required this.title,
    required this.description,
    required this.codeLabel,
    required this.child,
  });

  final String title;
  final String description;
  final String codeLabel;
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
            const SizedBox(height: 12),
            Text(codeLabel, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _FixedSizeExample extends StatelessWidget {
  const _FixedSizeExample();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 220,
          height: 56,
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
            label: const Text('Sized CTA'),
          ),
        ),
        SizedBox(
          width: 140,
          height: 56,
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('Secondary'),
          ),
        ),
      ],
    );
  }
}

class _SquareExample extends StatelessWidget {
  const _SquareExample();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: <Widget>[
        for (final Color color in <Color>[
          const Color(0xFF4CC9F0),
          const Color(0xFFF72585),
          const Color(0xFF4361EE),
        ])
          SizedBox.square(
            dimension: 76,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.widgets, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class _ExpandExample extends StatelessWidget {
  const _ExpandExample();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFE0FBFC),
          borderRadius: BorderRadius.circular(18),
        ),
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFF3D5A80), Color(0xFF293241)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Child fills the parent bounds',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpacingExample extends StatelessWidget {
  const _SpacingExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Release Notes',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12),
          Text(
            'SizedBox(height: 12) creates stable spacing between text blocks.',
          ),
          SizedBox(height: 18),
          Row(
            children: <Widget>[
              Icon(Icons.bolt, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text('Fast to read in code and easy to tune visually.'),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: <Widget>[
              Icon(Icons.check_circle, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'No extra decoration or layout semantics when you only need space.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
