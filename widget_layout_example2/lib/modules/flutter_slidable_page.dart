import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class _MailItem {
  const _MailItem({
    required this.id,
    required this.sender,
    required this.subject,
    required this.preview,
    required this.color,
  });

  final String id;
  final String sender;
  final String subject;
  final String preview;
  final Color color;
}

class _TaskItem {
  const _TaskItem({
    required this.id,
    required this.title,
    required this.detail,
    required this.color,
  });

  final String id;
  final String title;
  final String detail;
  final Color color;
}

const List<(String title, String description, Widget motion, Color color)>
_motionExamples = <(String, String, Widget, Color)>[
  (
    'BehindMotion',
    'Actions stay behind the tile while the content slides away.',
    BehindMotion(),
    Color(0xFF2563EB),
  ),
  (
    'DrawerMotion',
    'Actions appear like stacked drawers entering as the pane opens.',
    DrawerMotion(),
    Color(0xFF0F766E),
  ),
  (
    'ScrollMotion',
    'Actions move in from outside the tile boundary as if they are scrolling into view.',
    ScrollMotion(),
    Color(0xFF7C3AED),
  ),
  (
    'StretchMotion',
    'Actions stretch from zero width into their final size while the tile moves.',
    StretchMotion(),
    Color(0xFFEA580C),
  ),
];

@RoutePage(name: 'FlutterSlidableRoute')
class FlutterSlidablePage extends StatefulWidget {
  const FlutterSlidablePage({super.key});

  @override
  State<FlutterSlidablePage> createState() => _FlutterSlidablePageState();
}

class _FlutterSlidablePageState extends State<FlutterSlidablePage> {
  late List<_MailItem> _mailItems;
  late List<_TaskItem> _taskItems;
  List<String> _eventLog = <String>[];

  @override
  void initState() {
    super.initState();
    _mailItems = const <_MailItem>[
      _MailItem(
        id: 'mail-1',
        sender: 'Design Review',
        subject: 'Landing page revisions',
        preview: 'Swipe to archive, pin, or mark this conversation as done.',
        color: Color(0xFF2563EB),
      ),
      _MailItem(
        id: 'mail-2',
        sender: 'Ops Team',
        subject: 'Incident retrospective',
        preview:
            'This row is part of an auto-close group shared with its neighbors.',
        color: Color(0xFF0F766E),
      ),
      _MailItem(
        id: 'mail-3',
        sender: 'Product',
        subject: 'Roadmap sync',
        preview:
            'Open one tile and the rest close automatically because the groupTag matches.',
        color: Color(0xFF7C3AED),
      ),
    ];
    _taskItems = const <_TaskItem>[
      _TaskItem(
        id: 'task-1',
        title: 'Reply to security review',
        detail: 'Dismiss from the end pane after confirmation.',
        color: Color(0xFFDC2626),
      ),
      _TaskItem(
        id: 'task-2',
        title: 'Update release checklist',
        detail:
            'The end action pane uses DismissiblePane with a confirm dialog.',
        color: Color(0xFFEA580C),
      ),
      _TaskItem(
        id: 'task-3',
        title: 'Schedule customer follow-up',
        detail:
            'Removing the row triggers the resize animation before the callback.',
        color: Color(0xFF0284C7),
      ),
    ];
  }

  void _logEvent(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    setState(() {
      _eventLog = <String>[
        '$timestamp  $message',
        ..._eventLog,
      ].take(12).toList();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _confirmDelete(_TaskItem item) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Task'),
          content: Text('Delete "${item.title}" from the dismissible demo?'),
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
    return confirmed ?? false;
  }

  void _archiveMail(_MailItem item) {
    _showSnackBar('Archived "${item.subject}".');
    _logEvent('Archived ${item.id}');
  }

  void _pinMail(_MailItem item) {
    _showSnackBar('Pinned "${item.subject}".');
    _logEvent('Pinned ${item.id}');
  }

  void _markDone(_MailItem item) {
    _showSnackBar('Marked "${item.subject}" as done.');
    _logEvent('Marked done ${item.id}');
  }

  void _removeTask(_TaskItem item) {
    setState(() {
      _taskItems = _taskItems
          .where((_TaskItem existing) => existing.id != item.id)
          .toList();
    });
    _showSnackBar('Removed "${item.title}".');
    _logEvent('Dismissed ${item.id}');
  }

  void _reinsertTasks() {
    setState(() {
      _taskItems = const <_TaskItem>[
        _TaskItem(
          id: 'task-1',
          title: 'Reply to security review',
          detail: 'Dismiss from the end pane after confirmation.',
          color: Color(0xFFDC2626),
        ),
        _TaskItem(
          id: 'task-2',
          title: 'Update release checklist',
          detail:
              'The end action pane uses DismissiblePane with a confirm dialog.',
          color: Color(0xFFEA580C),
        ),
        _TaskItem(
          id: 'task-3',
          title: 'Schedule customer follow-up',
          detail:
              'Removing the row triggers the resize animation before the callback.',
          color: Color(0xFF0284C7),
        ),
      ];
    });
    _logEvent('Reset dismissible task list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_slidable Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'flutter_slidable adds contextual swipe actions to list rows. This page demonstrates multiple pane motions, grouped auto-closing, dismissible panes, and fully custom actions.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _SlidableInfoCard(
              title: 'Basic setup',
              description:
                  'A Slidable wraps a child and exposes startActionPane and endActionPane. Each ActionPane can use a different motion and a set of SlidableAction or CustomSlidableAction widgets.',
            ),
            const SizedBox(height: 16),
            const _SlidableCodeCard(
              title: 'Typical usage',
              code: '''
Slidable(
  startActionPane: ActionPane(
    motion: const DrawerMotion(),
    children: <Widget>[
      SlidableAction(
        onPressed: (_) {},
        icon: Icons.archive_outlined,
        label: 'Archive',
      ),
    ],
  ),
  child: const ListTile(title: Text('Swipe me')),
)
''',
            ),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: 'Motion Gallery',
              subtitle:
                  'These tiles show the four built-in action-pane motions exported by flutter_slidable.',
            ),
            const SizedBox(height: 12),
            ..._motionExamples.map((
              (String title, String description, Widget motion, Color color)
              example,
            ) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MotionDemoCard(
                  title: example.$1,
                  description: example.$2,
                  motion: example.$3,
                  color: example.$4,
                  onPrimaryAction: () => _logEvent('Opened ${example.$1} demo'),
                ),
              );
            }),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: 'Auto-Close Group',
              subtitle:
                  'SlidableAutoCloseBehavior keeps only one row in the same group open at a time.',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SlidableAutoCloseBehavior(
                  child: Column(
                    children: _mailItems.map((_MailItem item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Slidable(
                          key: ValueKey<String>(item.id),
                          groupTag: 'inbox-demo',
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.5,
                            children: <Widget>[
                              SlidableAction(
                                onPressed: (_) => _archiveMail(item),
                                backgroundColor: item.color,
                                foregroundColor: Colors.white,
                                icon: Icons.archive_outlined,
                                label: 'Archive',
                              ),
                              SlidableAction(
                                onPressed: (_) => _pinMail(item),
                                backgroundColor: Colors.black87,
                                foregroundColor: Colors.white,
                                icon: Icons.push_pin_outlined,
                                label: 'Pin',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.25,
                            children: <Widget>[
                              SlidableAction(
                                onPressed: (_) => _markDone(item),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                icon: Icons.done_all_outlined,
                                label: 'Done',
                              ),
                            ],
                          ),
                          child: _MailTile(item: item),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: 'Dismissible Pane',
              subtitle:
                  'DismissiblePane can confirm or cancel the gesture before the item is removed.',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: _reinsertTasks,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset Task List'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_taskItems.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'All tasks were dismissed. Use "Reset Task List" to replay the demo.',
                        ),
                      )
                    else
                      ..._taskItems.map((_TaskItem item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Slidable(
                            key: ValueKey<String>(item.id),
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              extentRatio: 0.32,
                              dismissible: DismissiblePane(
                                confirmDismiss: () => _confirmDelete(item),
                                closeOnCancel: true,
                                onDismissed: () => _removeTask(item),
                              ),
                              children: <Widget>[
                                SlidableAction(
                                  onPressed: (_) => _removeTask(item),
                                  backgroundColor: item.color,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete_outline,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: _TaskTile(item: item),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: 'Custom Action Layout',
              subtitle:
                  'CustomSlidableAction lets you provide any widget tree instead of only icon plus label.',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Slidable(
                  key: const ValueKey<String>('custom-action-demo'),
                  startActionPane: ActionPane(
                    motion: const BehindMotion(),
                    extentRatio: 0.62,
                    children: <Widget>[
                      CustomSlidableAction(
                        onPressed: (_) {
                          _showSnackBar('Queued a quick review session.');
                          _logEvent('Triggered quick review custom action');
                        },
                        backgroundColor: const Color(0xFF111827),
                        foregroundColor: Colors.white,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.rate_review_outlined),
                            SizedBox(height: 8),
                            Text(
                              'Review',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 4),
                            Text('Custom widget'),
                          ],
                        ),
                      ),
                      CustomSlidableAction(
                        onPressed: (_) {
                          _showSnackBar('Scheduled this item for tomorrow.');
                          _logEvent('Triggered schedule custom action');
                        },
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.black,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.schedule_outlined),
                              SizedBox(height: 8),
                              Text(
                                'Tomorrow',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Full custom layout',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: <Widget>[
                      SlidableAction(
                        onPressed: (_) {
                          _showSnackBar(
                            'Muted notifications for this demo row.',
                          );
                          _logEvent('Triggered mute action');
                        },
                        backgroundColor: const Color(0xFF4B5563),
                        foregroundColor: Colors.white,
                        icon: Icons.notifications_off_outlined,
                        label: 'Mute',
                      ),
                    ],
                  ),
                  child: const ListTile(
                    tileColor: Color(0xFFF8FAFC),
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFDBEAFE),
                      foregroundColor: Color(0xFF1D4ED8),
                      child: Icon(Icons.widgets_outlined),
                    ),
                    title: Text('Composite Action Tile'),
                    subtitle: Text(
                      'Swipe either side to compare SlidableAction with CustomSlidableAction.',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _SlidableCodeCard(
              title: 'Dismissible and grouped usage',
              code: '''
SlidableAutoCloseBehavior(
  child: Slidable(
    groupTag: 'inbox-demo',
    endActionPane: ActionPane(
      motion: const StretchMotion(),
      dismissible: DismissiblePane(
        confirmDismiss: _confirmDelete,
        onDismissed: _removeItem,
      ),
      children: <Widget>[
        SlidableAction(
          onPressed: (_) {},
          icon: Icons.delete_outline,
          label: 'Delete',
        ),
      ],
    ),
    child: const ListTile(title: Text('Swipe to dismiss')),
  ),
)
''',
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Event Log',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_eventLog.isEmpty)
                      const Text('No actions triggered yet.')
                    else
                      ..._eventLog.map((String line) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            line,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontFamily: 'monospace'),
                          ),
                        );
                      }),
                  ],
                ),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(subtitle),
      ],
    );
  }
}

class _SlidableInfoCard extends StatelessWidget {
  const _SlidableInfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
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
          ],
        ),
      ),
    );
  }
}

class _SlidableCodeCard extends StatelessWidget {
  const _SlidableCodeCard({required this.title, required this.code});

  final String title;
  final String code;

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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                code.trim(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MotionDemoCard extends StatelessWidget {
  const _MotionDemoCard({
    required this.title,
    required this.description,
    required this.motion,
    required this.color,
    required this.onPrimaryAction,
  });

  final String title;
  final String description;
  final Widget motion;
  final Color color;
  final VoidCallback onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(description),
            const SizedBox(height: 12),
            Slidable(
              key: ValueKey<String>('motion-$title'),
              startActionPane: ActionPane(
                motion: motion,
                extentRatio: 0.5,
                children: <Widget>[
                  SlidableAction(
                    onPressed: (_) => onPrimaryAction(),
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    icon: Icons.flash_on_outlined,
                    label: 'Open',
                  ),
                  SlidableAction(
                    onPressed: (_) {},
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    icon: Icons.bookmark_border,
                    label: 'Save',
                  ),
                ],
              ),
              child: ListTile(
                tileColor: color.withValues(alpha: 0.08),
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.16),
                  foregroundColor: color,
                  child: const Icon(Icons.swipe_outlined),
                ),
                title: Text(title),
                subtitle: const Text(
                  'Drag horizontally to inspect the motion.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MailTile extends StatelessWidget {
  const _MailTile({required this.item});

  final _MailItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      leading: CircleAvatar(
        backgroundColor: item.color.withValues(alpha: 0.16),
        foregroundColor: item.color,
        child: Text(item.sender.characters.first),
      ),
      title: Text(item.subject),
      subtitle: Text('${item.sender} • ${item.preview}'),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.item});

  final _TaskItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: item.color.withValues(alpha: 0.08),
      leading: CircleAvatar(
        backgroundColor: item.color.withValues(alpha: 0.16),
        foregroundColor: item.color,
        child: const Icon(Icons.checklist_rtl_outlined),
      ),
      title: Text(item.title),
      subtitle: Text(item.detail),
    );
  }
}
