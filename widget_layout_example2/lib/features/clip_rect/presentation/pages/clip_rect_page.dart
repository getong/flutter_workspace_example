import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.clipRect)
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
              child: _OverflowDemo(clip: true),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Without Clipping',
              description:
                  'The same content without ClipRect can paint beyond the visible region.',
              child: _OverflowDemo(clip: false),
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

class _OverflowDemo extends StatelessWidget {
  const _OverflowDemo({required this.clip});

  final bool clip;

  @override
  Widget build(BuildContext context) {
    final Widget overflowingBanner = OverflowBox(
      alignment: Alignment.centerLeft,
      minWidth: 0,
      maxWidth: double.infinity,
      child: Transform.translate(
        offset: const Offset(56, 0),
        child: const _Banner(),
      ),
    );

    return SizedBox(
      width: 320,
      height: 128,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            left: 0,
            top: 14,
            child: Container(
              width: 220,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blueGrey.withValues(alpha: 0.08),
                border: Border.all(
                  color: Colors.blueGrey.withValues(alpha: 0.45),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: clip
                  ? ClipRect(child: overflowingBanner)
                  : overflowingBanner,
            ),
          ),
          Positioned(
            left: 12,
            top: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  'Visible frame',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
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
