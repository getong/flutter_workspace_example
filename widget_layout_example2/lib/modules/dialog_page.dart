import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'DialogExampleRoute')
class DialogExamplePage extends StatefulWidget {
  const DialogExamplePage({super.key});

  @override
  State<DialogExamplePage> createState() => _DialogExamplePageState();
}

class _DialogExamplePageState extends State<DialogExamplePage> {
  String _status = 'No custom dialog action yet.';
  String _draftTitle = 'Q2 release note';

  Future<void> _openComposerDialog() async {
    final TextEditingController controller = TextEditingController(
      text: _draftTitle,
    );

    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Icon(Icons.auto_awesome, color: Colors.deepOrange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Create release note',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dialog is the lower-level Material widget for fully custom modal composition.',
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const <Widget>[
                    Chip(label: Text('Release')),
                    Chip(label: Text('QA')),
                    Chip(label: Text('Docs')),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () =>
                          Navigator.of(context).pop(controller.text.trim()),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.dispose();

    if (!mounted) {
      return;
    }

    setState(() {
      if (result == null || result.isEmpty) {
        _status = 'Custom dialog dismissed without saving.';
        return;
      }

      _draftTitle = result;
      _status = 'Saved custom dialog draft: "$_draftTitle".';
    });
  }

  Future<void> _openTemplateDialog() async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Choose a dialog template',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'A plain Dialog is useful when your modal layout does not match AlertDialog or SimpleDialog.',
                  ),
                  const SizedBox(height: 20),
                  ...<String>[
                    'Release notes',
                    'Incident summary',
                    'Customer update',
                  ].map((String label) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        tileColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        leading: const Icon(Icons.description_outlined),
                        title: Text(label),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).pop(label),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _status = 'Selected dialog template: $result.';
    });
  }

  Future<void> _openFullscreenDialog() async {
    final String? result = await showDialog<String>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.of(
                          context,
                        ).pop('Closed fullscreen dialog'),
                        icon: const Icon(Icons.close),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Dialog.fullscreen example',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Dialog.fullscreen is useful for modal flows that need significantly more space than a compact alert-style surface.',
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.fact_check_outlined),
                            title: const Text('Review release checklist'),
                            subtitle: Text('Current draft: $_draftTitle'),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Icon(Icons.groups_outlined),
                            title: Text('Notify stakeholders'),
                            subtitle: Text(
                              'Prepare engineering, QA, and support communication.',
                            ),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Icon(Icons.rocket_launch_outlined),
                            title: Text('Ready to launch'),
                            subtitle: Text(
                              'Use a fullscreen dialog when the modal content becomes a focused task flow.',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(
                        context,
                      ).pop('Completed fullscreen review'),
                      icon: const Icon(Icons.check),
                      label: const Text('Finish review'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _status = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialog Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Dialog is the lower-level Material dialog widget used for fully custom modal content.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Custom Dialog Layout',
              description:
                  'Use Dialog when AlertDialog or SimpleDialog are too opinionated for your design.',
              child: FilledButton(
                onPressed: _openComposerDialog,
                child: const Text('Open custom Dialog'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Dialog as a Custom Surface',
              description:
                  'The base Dialog widget lets you build card-style pickers, previews, and other modal layouts that do not fit the standard dialog templates.',
              child: OutlinedButton(
                onPressed: _openTemplateDialog,
                child: const Text('Open template picker'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Dialog.fullscreen',
              description:
                  'Use the fullscreen constructor for modal flows that need the space of an entire screen while still behaving like a dialog route.',
              child: FilledButton.tonal(
                onPressed: _openFullscreenDialog,
                child: const Text('Open fullscreen dialog'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Latest Result',
              description:
                  'The dialog result can be returned from Navigator.pop just like any other modal flow.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_status),
                  const SizedBox(height: 8),
                  Text('Latest draft title: $_draftTitle'),
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
