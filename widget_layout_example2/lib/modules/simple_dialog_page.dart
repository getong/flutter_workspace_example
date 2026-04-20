import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SimpleDialogExamplePage extends StatefulWidget {
  const SimpleDialogExamplePage({super.key});

  @override
  State<SimpleDialogExamplePage> createState() =>
      _SimpleDialogExamplePageState();
}

class _SimpleDialogExamplePageState extends State<SimpleDialogExamplePage> {
  String _selection = 'No option selected yet.';
  String _priority = 'No priority selected yet.';

  Future<void> _openWorkspaceDialog() async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose a workspace'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('Design'),
              child: const Row(
                children: <Widget>[
                  Icon(Icons.palette_outlined),
                  SizedBox(width: 12),
                  Text('Design'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('Development'),
              child: const Row(
                children: <Widget>[
                  Icon(Icons.code),
                  SizedBox(width: 12),
                  Text('Development'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('QA'),
              child: const Row(
                children: <Widget>[
                  Icon(Icons.verified_outlined),
                  SizedBox(width: 12),
                  Text('QA'),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _selection = result;
    });
  }

  Future<void> _openPriorityDialog() async {
    final String? result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: const Text('Escalation priority'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('Low priority'),
              child: const Text('Low priority'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('Normal priority'),
              child: const Text('Normal priority'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('High priority'),
              child: const Text('High priority'),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.of(context).pop('Priority selection cancelled'),
                child: const Text('Cancel'),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _priority = result;
    });
  }

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
                onPressed: _openWorkspaceDialog,
                child: const Text('Open SimpleDialog'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Customized SimpleDialog Layout',
              description:
                  'You can adjust title and content padding, keep the barrier non-dismissible, and still use SimpleDialogOption for fast actions.',
              child: OutlinedButton(
                onPressed: _openPriorityDialog,
                child: const Text('Open priority dialog'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Current Selection',
              description:
                  'The chosen values can be returned from the dialog Future and stored in page state.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Workspace: $_selection'),
                  const SizedBox(height: 8),
                  Text('Priority: $_priority'),
                ],
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
