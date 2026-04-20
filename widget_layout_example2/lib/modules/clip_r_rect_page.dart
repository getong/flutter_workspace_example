import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ClipRRectExamplePage extends StatelessWidget {
  const ClipRRectExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClipRRect Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const <Widget>[
            Text(
              'ClipRRect clips its child using a rounded rectangle.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            _ExampleCard(
              title: 'Rounded Media Card',
              description:
                  'ClipRRect is commonly used for card thumbnails and rounded image containers.',
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                child: _ShowcasePanel(),
              ),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Sharper Radius',
              description:
                  'The borderRadius value controls how soft or sharp the clipped corners appear.',
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: _ShowcasePanel(),
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

class _ShowcasePanel extends StatelessWidget {
  const _ShowcasePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: <Color>[Colors.teal, Colors.indigo]),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Rounded clip',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
