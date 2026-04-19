import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'AlertDialogExampleRoute')
class AlertDialogExamplePage extends StatefulWidget {
  const AlertDialogExamplePage({super.key});

  @override
  State<AlertDialogExamplePage> createState() => _AlertDialogExamplePageState();
}

class _AlertDialogExamplePageState extends State<AlertDialogExamplePage> {
  String _latestAction = 'No alert action yet.';

  Future<void> _openConfirmationDialog() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete item?'),
          content: const Text(
            'This action cannot be undone after confirmation.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _latestAction = confirmed == true
          ? 'Confirmation dialog: delete approved.'
          : 'Confirmation dialog: delete cancelled.';
    });
  }

  Future<void> _openScrollableAlert() async {
    final String? action = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded),
          title: const Text('Release checklist'),
          scrollable: true,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.generate(6, (int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Step ${index + 1}: Verify deployment condition ${index + 1}.',
                ),
              );
            }),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsOverflowButtonSpacing: 12,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop('Checklist deferred'),
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop('Checklist accepted'),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (!mounted || action == null) {
      return;
    }

    setState(() {
      _latestAction = action;
    });
  }

  Future<void> _openPreferencesDialog() async {
    bool sendEmail = true;
    bool pingMobile = false;

    final String? summary = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (
                BuildContext context,
                void Function(void Function()) setInnerState,
              ) {
                return AlertDialog(
                  title: const Text('Notify the team'),
                  contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CheckboxListTile(
                        value: sendEmail,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Send summary email'),
                        onChanged: (bool? value) {
                          setInnerState(() {
                            sendEmail = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        value: pingMobile,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Send mobile push'),
                        onChanged: (bool? value) {
                          setInnerState(() {
                            pingMobile = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop('Preferences cancelled'),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop(
                          'Saved notification preferences: email ${sendEmail ? 'on' : 'off'}, mobile ${pingMobile ? 'on' : 'off'}.',
                        );
                      },
                      child: const Text('Save'),
                    ),
                  ],
                );
              },
        );
      },
    );

    if (!mounted || summary == null) {
      return;
    }

    setState(() {
      _latestAction = summary;
    });
  }

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
                onPressed: _openConfirmationDialog,
                child: const Text('Open AlertDialog'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Scrollable Alert With Icon',
              description:
                  'AlertDialog supports icons, scrolling content, and action layout controls when the message grows beyond a short warning.',
              child: OutlinedButton(
                onPressed: _openScrollableAlert,
                child: const Text('Open scrollable alert'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'AlertDialog with Temporary UI State',
              description:
                  'StatefulBuilder is useful when a dialog needs transient controls such as checkboxes without promoting that state to the page.',
              child: OutlinedButton(
                onPressed: _openPreferencesDialog,
                child: const Text('Open preferences alert'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Latest Result',
              description:
                  'Dialog actions can be returned from Navigator.pop and persisted in the page state after showDialog completes.',
              child: Text(_latestAction),
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
