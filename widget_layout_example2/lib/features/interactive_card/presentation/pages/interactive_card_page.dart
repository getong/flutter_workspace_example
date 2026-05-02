import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.interactiveCard)
class InteractiveCardPage extends StatefulWidget {
  const InteractiveCardPage({super.key});

  @override
  State<InteractiveCardPage> createState() => _InteractiveCardPageState();
}

class _InteractiveCardPageState extends State<InteractiveCardPage> {
  final Set<String> _selectedCards = <String>{'Design'};

  @override
  Widget build(BuildContext context) {
    final List<({String label, IconData icon, Color color})> options =
        <({String label, IconData icon, Color color})>[
          (
            label: 'Design',
            icon: Icons.palette_outlined,
            color: Colors.pinkAccent,
          ),
          (label: 'Engineering', icon: Icons.code, color: Colors.blueAccent),
          (
            label: 'Support',
            icon: Icons.support_agent_outlined,
            color: Colors.teal,
          ),
        ];

    return Scaffold(
      appBar: AppBar(title: const Text('InteractiveCard Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'InteractiveCard is a custom surface for selection, hover feedback, and tap-driven actions while keeping more flexibility than a standard ListTile.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Selectable Workspace Cards',
              description:
                  'Use the card as an option picker by changing border, shadow, and background on selection.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: options.map((
                  ({String label, IconData icon, Color color}) item,
                ) {
                  return SizedBox(
                    width: 220,
                    child: InteractiveCard(
                      title: item.label,
                      subtitle: 'Tap to toggle this workspace',
                      accentColor: item.color,
                      selected: _selectedCards.contains(item.label),
                      leading: Icon(item.icon),
                      child: Text(
                        'Selected workspaces: ${_selectedCards.length}',
                      ),
                      onTap: () {
                        setState(() {
                          if (_selectedCards.contains(item.label)) {
                            _selectedCards.remove(item.label);
                          } else {
                            _selectedCards.add(item.label);
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Action-Oriented Card',
              description:
                  'The same widget can also host richer content and trailing actions for dashboard-style surfaces.',
              child: InteractiveCard(
                title: 'Weekly rollout summary',
                subtitle: '17 items shipped, 3 pending reviews',
                accentColor: Colors.deepPurple,
                leading: const CircleAvatar(
                  child: Icon(Icons.insights_outlined),
                ),
                trailing: FilledButton(
                  onPressed: () {},
                  child: const Text('Open'),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Divider(),
                    Text('Highlights'),
                    SizedBox(height: 8),
                    Text('- API latency improved by 18%'),
                    Text('- Error budget remained within target'),
                    Text('- Release notes are ready for publication'),
                  ],
                ),
                onTap: () {},
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

class InteractiveCard extends StatefulWidget {
  const InteractiveCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.leading,
    this.trailing,
    this.child,
    this.selected = false,
    this.accentColor = Colors.blue,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  final Widget? child;
  final bool selected;
  final Color accentColor;

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool active = _hovered || widget.selected;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _hovered ? 1.01 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: active
                ? widget.accentColor.withValues(alpha: 0.10)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active
                  ? widget.accentColor.withValues(alpha: 0.60)
                  : theme.colorScheme.outlineVariant,
              width: active ? 1.4 : 1,
            ),
            boxShadow: active
                ? <BoxShadow>[
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (widget.leading != null) ...<Widget>[
                          widget.leading!,
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(widget.subtitle),
                            ],
                          ),
                        ),
                        if (widget.trailing != null) ...<Widget>[
                          const SizedBox(width: 12),
                          widget.trailing!,
                        ],
                      ],
                    ),
                    if (widget.child != null) ...<Widget>[
                      const SizedBox(height: 16),
                      widget.child!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
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
