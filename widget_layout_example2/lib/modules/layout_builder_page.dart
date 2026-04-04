import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'LayoutBuilderExampleRoute')
class LayoutBuilderExamplePage extends StatelessWidget {
  const LayoutBuilderExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LayoutBuilder Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'LayoutBuilder lets you build different widget trees based on the constraints from the parent.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _ExampleCard(
              title: 'Responsive Card Layout',
              description:
                  'This example changes its arrangement depending on the width available from the parent container.',
              child: SizedBox(height: 260, child: _ResponsivePreview()),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'When to Use LayoutBuilder',
              description:
                  'Use it when the child layout depends on local width/height constraints rather than only global screen size.',
              child: Text(
                'This is especially useful inside cards, side panels, split views, and adaptive reusable widgets.',
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

class _ResponsivePreview extends StatelessWidget {
  const _ResponsivePreview();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 420;
        final List<Widget> panels = <Widget>[
          _Panel(
            color: Colors.indigo,
            label: compact ? 'Hero' : 'Hero summary',
          ),
          _Panel(color: Colors.teal, label: compact ? 'Stats' : 'Stats block'),
          _Panel(
            color: Colors.orange,
            label: compact ? 'Actions' : 'Action tray',
          ),
        ];

        if (compact) {
          return Column(
            children: panels
                .map(
                  (Widget panel) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: panel,
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: <Widget>[
            Expanded(flex: 2, child: panels[0]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(child: panels[1]),
                  const SizedBox(height: 12),
                  Expanded(child: panels[2]),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
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
