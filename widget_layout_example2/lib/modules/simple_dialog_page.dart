import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'SimpleDialogExampleRoute')
class SimpleDialogExamplePage extends StatefulWidget {
  const SimpleDialogExamplePage({super.key});

  @override
  State<SimpleDialogExamplePage> createState() =>
      _SimpleDialogExamplePageState();
}

class _SimpleDialogExamplePageState extends State<SimpleDialogExamplePage> {
  String _selection = 'No option selected yet.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SimpleDialog Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'SimpleDialog is useful for showing a small set of choices in a modal list.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Selection Dialog',
              description:
                  'SimpleDialogOption widgets are a clean fit when you want the user to choose one option quickly.',
              child: FilledButton(
                onPressed: () async {
                  final String? result = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text('Choose a workspace'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () =>
                                Navigator.of(context).pop('Design'),
                            child: const Text('Design'),
                          ),
                          SimpleDialogOption(
                            onPressed: () =>
                                Navigator.of(context).pop('Development'),
                            child: const Text('Development'),
                          ),
                          SimpleDialogOption(
                            onPressed: () => Navigator.of(context).pop('QA'),
                            child: const Text('QA'),
                          ),
                        ],
                      );
                    },
                  );
                  if (result != null) {
                    setState(() {
                      _selection = result;
                    });
                  }
                },
                child: const Text('Open SimpleDialog'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Current Selection',
              description:
                  'The chosen value can be returned from the dialog Future and stored in page state.',
              child: Text(_selection),
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
