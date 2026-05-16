import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.clipOval)
class ClipOvalExamplePage extends StatelessWidget {
  const ClipOvalExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClipOval Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const <Widget>[
            Text(
              'ClipOval clips its child into an oval or circle shape.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            _ExampleCard(
              title: 'Circular Avatar',
              description:
                  'ClipOval is often used to create avatars or rounded media previews.',
              child: Center(
                child: ClipOval(child: _GradientPanel(width: 140, height: 140)),
              ),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Oval Banner',
              description:
                  'The child does not need to be square. Wider children become oval when clipped.',
              child: Center(
                child: ClipOval(child: _GradientPanel(width: 240, height: 120)),
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

class _GradientPanel extends StatelessWidget {
  const _GradientPanel({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: <Color>[Colors.indigo, Colors.pink]),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 52, color: Colors.white),
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
