import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.padding)
class PaddingPage extends StatelessWidget {
  const PaddingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Padding Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Padding adds space inside a widget around its child.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _PaddingExampleCard(
              title: 'All Sides',
              description:
                  'EdgeInsets.all(16) applies the same spacing everywhere.',
              padding: const EdgeInsets.all(16),
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _PaddingExampleCard(
              title: 'Symmetric',
              description:
                  'EdgeInsets.symmetric(horizontal: 24, vertical: 12) uses different horizontal and vertical spacing.',
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _PaddingExampleCard(
              title: 'Only',
              description:
                  'EdgeInsets.only(left: 32, top: 8, right: 12, bottom: 20) gives fine-grained control.',
              padding: const EdgeInsets.only(
                left: 32,
                top: 8,
                right: 12,
                bottom: 20,
              ),
              color: Colors.orange,
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

class _PaddingExampleCard extends StatelessWidget {
  const _PaddingExampleCard({
    required this.title,
    required this.description,
    required this.padding,
    required this.color,
  });

  final String title;
  final String description;
  final EdgeInsets padding;
  final Color color;

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
            Container(
              width: double.infinity,
              color: color.withValues(alpha: 0.14),
              child: Padding(
                padding: padding,
                child: Container(
                  height: 72,
                  color: color,
                  alignment: Alignment.center,
                  child: const Text(
                    'Child Widget',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Padding: $padding',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
