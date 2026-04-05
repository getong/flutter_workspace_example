import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'ActionChipRoute')
class ActionChipPage extends StatefulWidget {
  const ActionChipPage({super.key});

  @override
  State<ActionChipPage> createState() => _ActionChipPageState();
}

class _ActionChipPageState extends State<ActionChipPage> {
  int _refreshCount = 0;
  final List<String> _activityLog = <String>[
    'Dashboard opened',
    'Filters synced',
  ];

  void _appendLog(String message) {
    setState(() {
      _activityLog.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ActionChip Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'ActionChip triggers an action without staying selected. It is useful for compact commands, suggestions, and quick tools.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Quick Actions',
              description:
                  'Each chip executes an immediate operation and updates a small activity log.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  ActionChip(
                    avatar: const Icon(Icons.refresh, size: 18),
                    label: const Text('Refresh Data'),
                    onPressed: () {
                      setState(() {
                        _refreshCount += 1;
                      });
                      _appendLog('Refresh requested (#$_refreshCount)');
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.download, size: 18),
                    label: const Text('Export CSV'),
                    onPressed: () {
                      _appendLog('CSV export queued');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Export queued.')),
                      );
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.add_alert, size: 18),
                    label: const Text('Notify Team'),
                    onPressed: () {
                      _appendLog('Team notification sent');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Suggested Commands',
              description:
                  'Action chips can surface contextual shortcuts after a user completes another task.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  ActionChip(
                    label: const Text('Open Analytics'),
                    onPressed: () => _appendLog('Analytics panel opened'),
                  ),
                  ActionChip(
                    label: const Text('Create Follow-up Task'),
                    onPressed: () => _appendLog('Follow-up task created'),
                  ),
                  ActionChip(
                    label: const Text('Share Snapshot'),
                    onPressed: () => _appendLog('Snapshot shared'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Activity Log',
              description:
                  'The result of pressing an ActionChip should usually be visible somewhere in the interface.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Refresh count: $_refreshCount'),
                  const SizedBox(height: 12),
                  ..._activityLog
                      .take(6)
                      .map(
                        (String entry) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: const Icon(Icons.bolt),
                          title: Text(entry),
                        ),
                      ),
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
