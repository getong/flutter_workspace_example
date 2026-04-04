import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'ShowDialogExampleRoute')
class ShowDialogExamplePage extends StatefulWidget {
  const ShowDialogExamplePage({super.key});

  @override
  State<ShowDialogExamplePage> createState() => _ShowDialogExamplePageState();
}

class _ShowDialogExamplePageState extends State<ShowDialogExamplePage> {
  String _lastResult = 'No dialog result yet.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('showDialog Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'showDialog is the function that presents a modal dialog above the current route.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Dialog Result',
              description:
                  'showDialog returns a Future that completes when the dialog is dismissed, which is useful for confirmations and selections.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton(
                    onPressed: () async {
                      final bool? approved = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Publish changes?'),
                            content: const Text(
                              'This uses showDialog to wait for a result.',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Publish'),
                              ),
                            ],
                          );
                        },
                      );
                      setState(() {
                        _lastResult =
                            'Dialog result: ${approved == true ? 'approved' : 'cancelled'}';
                      });
                    },
                    child: const Text('Open dialog'),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      await showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Blocking dialog'),
                            content: const Text(
                              'This dialog must be closed with its button.',
                            ),
                            actions: <Widget>[
                              FilledButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Barrier disabled'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Latest Result',
              description:
                  'The Future returned by showDialog makes result handling straightforward.',
              child: Text(_lastResult),
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
