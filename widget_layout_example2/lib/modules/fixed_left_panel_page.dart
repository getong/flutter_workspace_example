import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.fixedLeftPanel)
class FixedLeftPanelPage extends StatefulWidget {
  const FixedLeftPanelPage({super.key});

  @override
  State<FixedLeftPanelPage> createState() => _FixedLeftPanelPageState();
}

class _FixedLeftPanelPageState extends State<FixedLeftPanelPage> {
  int _selectedSection = 0;

  static const List<_SectionData> _sections = <_SectionData>[
    _SectionData(
      title: 'Overview',
      icon: Icons.dashboard_outlined,
      accent: Colors.blue,
      summary:
          'The left panel stays fixed while the right side swaps between sections and scrolls independently.',
      bullets: <String>[
        'Use a Row for the outer layout.',
        'Give the left side a fixed width.',
        'Put the changing content on the right inside Expanded.',
      ],
    ),
    _SectionData(
      title: 'Analytics',
      icon: Icons.analytics_outlined,
      accent: Colors.teal,
      summary:
          'This section shows a denser layout to make the contrast obvious: the left side never rebuilds visually.',
      bullets: <String>[
        'Charts or cards can change here.',
        'The left navigation can remain visible.',
        'The right pane can scroll without affecting the left pane.',
      ],
    ),
    _SectionData(
      title: 'Activity',
      icon: Icons.timeline_outlined,
      accent: Colors.orange,
      summary:
          'A long feed on the right demonstrates that only the content area moves, while the left panel remains anchored.',
      bullets: <String>[
        'Independent scrolling is easier to understand.',
        'Selection state can drive the right panel.',
        'This pattern fits dashboards and master-detail layouts.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool useSideBySide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      appBar: AppBar(title: const Text('Fixed Left Panel Example')),
      body: useSideBySide
          ? Row(
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: _FixedSidebar(
                    sections: _sections,
                    selectedIndex: _selectedSection,
                    onSelect: _handleSelect,
                  ),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.colorScheme.outlineVariant,
                ),
                Expanded(
                  child: _ChangingContentPane(
                    section: _sections[_selectedSection],
                    selectedIndex: _selectedSection,
                    onSelect: _handleSelect,
                  ),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                Material(
                  color: theme.colorScheme.surfaceContainerLowest,
                  child: SizedBox(
                    width: double.infinity,
                    child: _CompactSectionTabs(
                      sections: _sections,
                      selectedIndex: _selectedSection,
                      onSelect: _handleSelect,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: theme.colorScheme.outlineVariant,
                ),
                Expanded(
                  child: _ChangingContentPane(
                    section: _sections[_selectedSection],
                    selectedIndex: _selectedSection,
                    onSelect: _handleSelect,
                  ),
                ),
              ],
            ),
    );
  }

  void _handleSelect(int index) {
    setState(() {
      _selectedSection = index;
    });
  }
}

class _FixedSidebar extends StatelessWidget {
  const _FixedSidebar({
    required this.sections,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<_SectionData> sections;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ColoredBox(
      color: colorScheme.surfaceContainerLowest,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Left side fixed',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This panel does not move or change when the right side switches sections.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: <Color>[
                      colorScheme.primaryContainer,
                      colorScheme.secondaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.push_pin_outlined,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pinned helper area',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Keep filters, summary data, or navigation here while the content pane updates.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.92,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Sections',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: sections.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (BuildContext context, int index) {
                    final _SectionData section = sections[index];
                    final bool selected = index == selectedIndex;
                    return _SidebarButton(
                      section: section,
                      selected: selected,
                      onTap: () => onSelect(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactSectionTabs extends StatelessWidget {
  const _CompactSectionTabs({
    required this.sections,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<_SectionData> sections;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: List<Widget>.generate(sections.length, (int index) {
          final _SectionData section = sections[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(section.title),
              avatar: Icon(section.icon, size: 18),
              selected: selectedIndex == index,
              onSelected: (_) => onSelect(index),
            ),
          );
        }),
      ),
    );
  }
}

class _ChangingContentPane extends StatelessWidget {
  const _ChangingContentPane({
    required this.section,
    required this.selectedIndex,
    required this.onSelect,
  });

  final _SectionData section;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<int> items = List<int>.generate(18, (int index) => index);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: ListView(
        key: ValueKey<int>(selectedIndex),
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            section.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(section.summary, style: theme.textTheme.titleMedium),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: section.bullets
                .map(
                  (String bullet) =>
                      _InfoCard(accent: section.accent, child: Text(bullet)),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: section.accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: section.accent.withValues(alpha: 0.24)),
            ),
            child: Row(
              children: <Widget>[
                Icon(section.icon, color: section.accent, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Only this right pane changes when you tap another section.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...items.map(
            (int item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _FeedCard(section: section, index: item + 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarButton extends StatelessWidget {
  const _SidebarButton({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final _SectionData section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: selected
          ? section.accent.withValues(alpha: 0.14)
          : colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: section.accent.withValues(alpha: 0.18),
                foregroundColor: section.accent,
                child: Icon(section.icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: section.accent, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child, required this.accent});

  final Widget child;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withValues(alpha: 0.16)),
        ),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({required this.section, required this.index});

  final _SectionData section;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: section.accent.withValues(alpha: 0.16),
              foregroundColor: section.accent,
              child: Text('$index'),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${section.title} item $index',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'The content scrolls and changes here. The fixed panel is intentionally outside this scrollable region.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionData {
  const _SectionData({
    required this.title,
    required this.icon,
    required this.accent,
    required this.summary,
    required this.bullets,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final String summary;
  final List<String> bullets;
}
