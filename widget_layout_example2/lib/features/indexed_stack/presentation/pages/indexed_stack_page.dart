import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.indexedStack)
class IndexedStackPage extends StatefulWidget {
  const IndexedStackPage({super.key});

  @override
  State<IndexedStackPage> createState() => _IndexedStackPageState();
}

class _IndexedStackPageState extends State<IndexedStackPage> {
  int _overviewIndex = 0;
  int _preservedStateIndex = 0;
  int _shellIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IndexedStack Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'IndexedStack shows exactly one child by index while keeping the other children in the tree, which is useful when hidden views should preserve state.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'This differs from rebuilding a single child with conditionals, because inactive panels can keep counters, text fields, scroll positions, and local widget state.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Basic View Switching',
              description:
                  'IndexedStack is commonly used when several views share the same footprint and only one should be visible at a time.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      for (final ({int index, String label}) option
                          in <({int index, String label})>[
                            (index: 0, label: 'Overview'),
                            (index: 1, label: 'Metrics'),
                            (index: 2, label: 'Alerts'),
                          ])
                        ChoiceChip(
                          label: Text(option.label),
                          selected: _overviewIndex == option.index,
                          onSelected: (_) {
                            setState(() {
                              _overviewIndex = option.index;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 220),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: IndexedStack(
                      index: _overviewIndex,
                      children: const <Widget>[
                        _OverviewPanel(),
                        _MetricsPanel(),
                        _AlertsPanel(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Current index: $_overviewIndex. The container keeps a stable footprint because IndexedStack sizes itself to the largest child.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Preserving Local Widget State',
              description:
                  'Each tab below owns its own state. Switch tabs and come back to confirm that the hidden widgets were not disposed.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SegmentedButton<int>(
                    segments: const <ButtonSegment<int>>[
                      ButtonSegment<int>(
                        value: 0,
                        label: Text('Counter'),
                        icon: Icon(Icons.exposure_plus_1),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        label: Text('Notes'),
                        icon: Icon(Icons.edit_note),
                      ),
                      ButtonSegment<int>(
                        value: 2,
                        label: Text('Controls'),
                        icon: Icon(Icons.tune),
                      ),
                    ],
                    selected: <int>{_preservedStateIndex},
                    onSelectionChanged: (Set<int> selection) {
                      setState(() {
                        _preservedStateIndex = selection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 240),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueGrey.withValues(alpha: 0.22),
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: IndexedStack(
                      index: _preservedStateIndex,
                      children: const <Widget>[
                        _StatefulCounterPane(),
                        _StatefulNotesPane(),
                        _StatefulControlsPane(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Navigation Shell Pattern',
              description:
                  'A common production pattern is keeping several navigation bodies alive under a shared shell, then switching them with IndexedStack.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 280,
                      height: 420,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Scaffold(
                          backgroundColor: Colors.grey.shade100,
                          body: IndexedStack(
                            index: _shellIndex,
                            children: const <Widget>[
                              _ShellScreen(
                                title: 'Inbox',
                                color: Colors.blue,
                                icon: Icons.inbox,
                                items: <String>[
                                  'Design review notes',
                                  'Release checklist',
                                  'Support summary',
                                ],
                              ),
                              _ShellScreen(
                                title: 'Projects',
                                color: Colors.teal,
                                icon: Icons.folder_copy,
                                items: <String>[
                                  'Widget demos',
                                  'Accessibility audit',
                                  'Analytics dashboard',
                                ],
                              ),
                              _ShellScreen(
                                title: 'Profile',
                                color: Colors.deepOrange,
                                icon: Icons.person,
                                items: <String>[
                                  'Account security',
                                  'Notification settings',
                                  'Connected devices',
                                ],
                              ),
                            ],
                          ),
                          bottomNavigationBar: NavigationBar(
                            selectedIndex: _shellIndex,
                            onDestinationSelected: (int value) {
                              setState(() {
                                _shellIndex = value;
                              });
                            },
                            destinations: const <NavigationDestination>[
                              NavigationDestination(
                                icon: Icon(Icons.inbox_outlined),
                                selectedIcon: Icon(Icons.inbox),
                                label: 'Inbox',
                              ),
                              NavigationDestination(
                                icon: Icon(Icons.folder_copy_outlined),
                                selectedIcon: Icon(Icons.folder_copy),
                                label: 'Projects',
                              ),
                              NavigationDestination(
                                icon: Icon(Icons.person_outline),
                                selectedIcon: Icon(Icons.person),
                                label: 'Profile',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This pattern is useful when each section should keep its existing state instead of rebuilding every time the destination changes.',
                    style: Theme.of(context).textTheme.bodySmall,
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

class _OverviewPanel extends StatelessWidget {
  const _OverviewPanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Overview',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const _InfoTile(
            color: Colors.blue,
            icon: Icons.widgets,
            title: 'Stable layout region',
            subtitle: 'The shell does not jump in size when the index changes.',
          ),
          const SizedBox(height: 12),
          const _InfoTile(
            color: Colors.indigo,
            icon: Icons.layers,
            title: 'Only one child is painted',
            subtitle: 'Hidden children remain mounted but are not visible.',
          ),
        ],
      ),
    );
  }
}

class _MetricsPanel extends StatelessWidget {
  const _MetricsPanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Metrics',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          const Row(
            children: <Widget>[
              Expanded(
                child: _MetricCard(
                  label: 'Latency',
                  value: '124 ms',
                  color: Colors.teal,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: 'Crashes',
                  value: '0.02%',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _MetricCard(
            label: 'Retention',
            value: '84%',
            color: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}

class _AlertsPanel extends StatelessWidget {
  const _AlertsPanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Alerts',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.warning_amber, color: Colors.amber),
            title: Text('Build queue is growing'),
            subtitle: Text('Average wait time increased in the last hour.'),
          ),
          const Divider(),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.info, color: Colors.blue),
            title: Text('New design tokens available'),
            subtitle: Text('Sync the latest color variables this afternoon.'),
          ),
        ],
      ),
    );
  }
}

class _StatefulCounterPane extends StatefulWidget {
  const _StatefulCounterPane();

  @override
  State<_StatefulCounterPane> createState() => _StatefulCounterPaneState();
}

class _StatefulCounterPaneState extends State<_StatefulCounterPane> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Counter tab',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text('Current value: $_count'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton(
                onPressed: () {
                  setState(() {
                    _count += 1;
                  });
                },
                child: const Text('Increment'),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _count = 0;
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Switch to another tab and come back. The count stays because this child remains mounted inside IndexedStack.',
          ),
        ],
      ),
    );
  }
}

class _StatefulNotesPane extends StatefulWidget {
  const _StatefulNotesPane();

  @override
  State<_StatefulNotesPane> createState() => _StatefulNotesPaneState();
}

class _StatefulNotesPaneState extends State<_StatefulNotesPane> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: 'Write something here, switch tabs, and come back.',
    );
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Notes tab',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Internal TextEditingController state',
            ),
          ),
          const SizedBox(height: 12),
          Text('Character count: ${_controller.text.characters.length}'),
        ],
      ),
    );
  }
}

class _StatefulControlsPane extends StatefulWidget {
  const _StatefulControlsPane();

  @override
  State<_StatefulControlsPane> createState() => _StatefulControlsPaneState();
}

class _StatefulControlsPaneState extends State<_StatefulControlsPane> {
  bool _enabled = true;
  double _priority = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Controls tab',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Enable notifications'),
            value: _enabled,
            onChanged: (bool value) {
              setState(() {
                _enabled = value;
              });
            },
          ),
          const SizedBox(height: 4),
          Text('Priority: ${_priority.toStringAsFixed(0)}'),
          Slider(
            value: _priority,
            min: 1,
            max: 5,
            divisions: 4,
            label: _priority.toStringAsFixed(0),
            onChanged: (double value) {
              setState(() {
                _priority = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ShellScreen extends StatelessWidget {
  const _ShellScreen({
    required this.title,
    required this.color,
    required this.icon,
    required this.items,
  });

  final String title;
  final Color color;
  final IconData icon;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color.withValues(alpha: 0.08),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.16),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final String item in items)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(icon, color: color),
                title: Text(item),
                subtitle: Text('$title content stays alive between switches.'),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
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
