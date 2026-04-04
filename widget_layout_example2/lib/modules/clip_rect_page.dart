import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'ClipRectExampleRoute')
class ClipRectExamplePage extends StatelessWidget {
  const ClipRectExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClipRect Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const <Widget>[
            Text(
              'ClipRect clips its child to a rectangular region.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            _ExampleCard(
              title: 'Clipping Overflow',
              description:
                  'ClipRect is useful when a translated or aligned child would otherwise paint outside its box.',
              child: SizedBox(
                width: 220,
                height: 100,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.6,
                    child: _Banner(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Without Clipping',
              description:
                  'The same content without ClipRect can paint beyond the visible region.',
              child: SizedBox(
                width: 220,
                height: 100,
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.6,
                  child: _Banner(),
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

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: <Color>[Colors.orange, Colors.pink]),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Overflowing content',
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
