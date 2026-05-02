import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.snackBar)
class SnackBarExamplePage extends StatelessWidget {
  const SnackBarExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnackBar Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'SnackBar shows short, temporary feedback at the bottom of the screen.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Standard SnackBar',
              description:
                  'Useful for confirming quick actions such as save, copy, delete, or archive.',
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Draft saved successfully.')),
                  );
                },
                child: const Text('Show standard SnackBar'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'SnackBar With Action',
              description:
                  'Actions make it easy to offer undo or retry after a transient event.',
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Message archived.'),
                      action: SnackBarAction(label: 'Undo', onPressed: () {}),
                    ),
                  );
                },
                child: const Text('Show action SnackBar'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Floating SnackBar',
              description:
                  'Behavior.floating helps the SnackBar feel more like a toast in roomy layouts.',
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Show floating SnackBar'),
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
