import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ShowDialogExamplePage extends StatefulWidget {
  const ShowDialogExamplePage({super.key});

  @override
  State<ShowDialogExamplePage> createState() => _ShowDialogExamplePageState();
}

class _ShowDialogExamplePageState extends State<ShowDialogExamplePage> {
  String _lastResult = 'No dialog result yet.';
  int _dialogOpenCount = 0;

  Future<void> _openConfirmationDialog() async {
    final bool? approved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Publish changes?'),
          content: const Text(
            'This uses showDialog<bool>() and returns a typed result from Navigator.pop.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Publish'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _dialogOpenCount += 1;
      _lastResult =
          'AlertDialog result: ${approved == true ? 'published' : 'cancelled'}';
    });
  }

  Future<void> _openSelectionDialog() async {
    final String? workspace = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose a workspace'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('Design'),
              child: const Text('Design'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('Engineering'),
              child: const Text('Engineering'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('Operations'),
              child: const Text('Operations'),
            ),
          ],
        );
      },
    );

    if (!mounted || workspace == null) {
      return;
    }

    setState(() {
      _dialogOpenCount += 1;
      _lastResult = 'SimpleDialog result: $workspace';
    });
  }

  Future<void> _openPriorityDialog() async {
    final int? priority = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Choose review priority',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'This example uses showDialog<int>() with the lower-level Dialog widget.',
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.tonal(
                      onPressed: () => Navigator.of(context).pop(1),
                      child: const Text('Low'),
                    ),
                    FilledButton.tonal(
                      onPressed: () => Navigator.of(context).pop(2),
                      child: const Text('Medium'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(3),
                      child: const Text('High'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || priority == null) {
      return;
    }

    setState(() {
      _dialogOpenCount += 1;
      _lastResult = 'Dialog result: priority level $priority';
    });
  }

  Future<void> _openBlockingDialog() async {
    final String? result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.64),
      routeSettings: const RouteSettings(name: 'blocking-review-dialog'),
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.lock_clock),
          title: const Text('Complete review'),
          content: const Text(
            'This dialog disables tapping outside the barrier so the user must finish or explicitly cancel.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop('Review deferred'),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop('Review completed'),
              child: const Text('Finish'),
            ),
          ],
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _dialogOpenCount += 1;
      _lastResult = result;
    });
  }

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
              title: 'showDialog with Different Result Types',
              description:
                  'showDialog<T>() can present different dialog widgets and return strongly typed results such as bool, String, or int.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton(
                    onPressed: _openConfirmationDialog,
                    child: const Text('Bool result'),
                  ),
                  OutlinedButton(
                    onPressed: _openSelectionDialog,
                    child: const Text('String result'),
                  ),
                  OutlinedButton(
                    onPressed: _openPriorityDialog,
                    child: const Text('Int result'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Route Presentation Options',
              description:
                  'showDialog also controls modal behavior such as barrier dismissal, barrier color, and route settings.',
              child: FilledButton.tonal(
                onPressed: _openBlockingDialog,
                child: const Text('Blocking dialog'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Latest Result',
              description:
                  'The Future returned by showDialog makes result handling straightforward no matter which dialog implementation you present.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_lastResult),
                  const SizedBox(height: 8),
                  Text('Dialogs opened in this session: $_dialogOpenCount'),
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
