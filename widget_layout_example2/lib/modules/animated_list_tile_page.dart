import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AnimatedListTilePage extends StatefulWidget {
  const AnimatedListTilePage({super.key});

  @override
  State<AnimatedListTilePage> createState() => _AnimatedListTilePageState();
}

class _AnimatedListTilePageState extends State<AnimatedListTilePage> {
  final Set<int> _expandedIds = <int>{1};
  int _selectedId = 2;

  void _toggleExpanded(int id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<_TaskItem> tasks = <_TaskItem>[
      const _TaskItem(
        id: 1,
        title: 'Staging deployment',
        subtitle: 'Prepare release candidate environment',
        details: 'Verify migrations, feature flags, and smoke tests.',
        icon: Icons.rocket_launch_outlined,
      ),
      const _TaskItem(
        id: 2,
        title: 'Design sign-off',
        subtitle: 'Approve responsive dashboard screens',
        details: 'Confirm spacing, typography, and loading states.',
        icon: Icons.design_services_outlined,
      ),
      const _TaskItem(
        id: 3,
        title: 'Support handoff',
        subtitle: 'Share incident playbook and release notes',
        details: 'Attach escalation steps and customer-facing summaries.',
        icon: Icons.support_agent_outlined,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedListTile Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'AnimatedListTile adds motion to selection, expansion, background emphasis, and supporting metadata while keeping the familiar list-tile structure.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Interactive Task List',
              description:
                  'Tap a tile to select it, and use the trailing affordance to expand or collapse additional details.',
              child: Column(
                children: tasks.map((_TaskItem item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AnimatedListTile(
                      title: item.title,
                      subtitle: item.subtitle,
                      details: item.details,
                      selected: _selectedId == item.id,
                      expanded: _expandedIds.contains(item.id),
                      leading: Icon(item.icon),
                      badge: item.id == 2
                          ? const _TileBadge(
                              label: 'Priority',
                              color: Colors.deepPurple,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedId = item.id;
                        });
                      },
                      onExpandToggle: () => _toggleExpanded(item.id),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Compact Notification Variant',
              description:
                  'The same widget also works for shorter, denser lists that still benefit from animation on selection and reveal.',
              child: Column(
                children: <Widget>[
                  AnimatedListTile(
                    title: 'Analytics sync finished',
                    subtitle: 'Last updated 2 minutes ago',
                    details: 'Warehouse tables and dashboards are in sync.',
                    selected: true,
                    expanded: true,
                    leading: const CircleAvatar(
                      child: Icon(Icons.analytics_outlined),
                    ),
                    onTap: () {},
                    onExpandToggle: () {},
                  ),
                  const SizedBox(height: 12),
                  AnimatedListTile(
                    title: 'New customer feedback',
                    subtitle: 'Three unread comments',
                    details:
                        'Open the feedback queue to triage product issues.',
                    leading: const CircleAvatar(
                      child: Icon(Icons.forum_outlined),
                    ),
                    badge: const _TileBadge(label: 'Unread', color: Colors.red),
                    onTap: () {},
                    onExpandToggle: () {},
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

class AnimatedListTile extends StatelessWidget {
  const AnimatedListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.details,
    required this.onTap,
    required this.onExpandToggle,
    this.leading,
    this.badge,
    this.selected = false,
    this.expanded = false,
  });

  final String title;
  final String subtitle;
  final String details;
  final VoidCallback onTap;
  final VoidCallback onExpandToggle;
  final Widget? leading;
  final Widget? badge;
  final bool selected;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color selectedColor = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: selected
              ? selectedColor.withValues(alpha: 0.10)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? selectedColor.withValues(alpha: 0.55)
                : theme.colorScheme.outlineVariant,
          ),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: selectedColor.withValues(alpha: 0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (leading != null) ...<Widget>[
                      leading!,
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (badge case final Widget badgeWidget)
                                badgeWidget,
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(subtitle),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: onExpandToggle,
                      icon: AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 220),
                        child: const Icon(Icons.expand_more),
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 220),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(details, style: theme.textTheme.bodyMedium),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TileBadge extends StatelessWidget {
  const _TileBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _TaskItem {
  const _TaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.details,
    required this.icon,
  });

  final int id;
  final String title;
  final String subtitle;
  final String details;
  final IconData icon;
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
