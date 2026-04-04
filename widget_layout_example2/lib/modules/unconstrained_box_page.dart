import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'UnconstrainedBoxExampleRoute')
class UnconstrainedBoxExamplePage extends StatelessWidget {
  const UnconstrainedBoxExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UnconstrainedBox Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'UnconstrainedBox lets its child size itself more freely than the incoming constraints would normally allow.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _ExampleCard(
              title: 'Child Larger Than Parent Box',
              description:
                  'The parent here is narrow, but UnconstrainedBox allows the child badge to keep a larger natural width.',
              child: _DemoFrame(
                child: UnconstrainedBox(
                  child: _WideDemoPanel(
                    label: 'Wide child keeps natural width',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Without UnconstrainedBox',
              description:
                  'Without it, the same child must respect the parent width and gets squeezed.',
              child: _DemoFrame(
                child: _WideDemoPanel(label: 'Wide child gets constrained'),
              ),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Common Use Cases',
              description:
                  'This is useful when embedding a naturally sized child inside tight layouts such as badges, previews, or overlaid labels.',
              child: Text(
                'Typical pattern: constrained outer card + naturally sized child preview.',
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

class _DemoFrame extends StatelessWidget {
  const _DemoFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      color: Colors.blueGrey.withValues(alpha: 0.08),
      child: child,
    );
  }
}

class _WideDemoPanel extends StatelessWidget {
  const _WideDemoPanel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(12),
      ),
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
