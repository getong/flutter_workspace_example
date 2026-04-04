import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'AlertDialogExampleRoute')
class AlertDialogExamplePage extends StatelessWidget {
  const AlertDialogExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AlertDialog Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'AlertDialog is a Material dialog for confirmations, warnings, and compact modal decisions.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Confirmation Dialog',
              description:
                  'This is the classic confirmation pattern with title, message, and actions.',
              child: FilledButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete item?'),
                        content: const Text(
                          'This action cannot be undone after confirmation.',
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Open AlertDialog'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Alert With Icon',
              description:
                  'AlertDialog can also include richer content such as leading icons or highlighted status messaging.',
              child: OutlinedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        icon: const Icon(Icons.warning_amber_rounded),
                        title: const Text('Storage almost full'),
                        content: const Text(
                          'Clear cached files or export older reports to free space.',
                        ),
                        actions: <Widget>[
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Review storage'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Open icon AlertDialog'),
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
