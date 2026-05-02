import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.customScrollViewSplit)
class CustomScrollViewSplitPage extends StatefulWidget {
  const CustomScrollViewSplitPage({super.key});

  @override
  State<CustomScrollViewSplitPage> createState() =>
      _CustomScrollViewSplitPageState();
}

class _CustomScrollViewSplitPageState extends State<CustomScrollViewSplitPage> {
  int _selectedSection = 0;

  static const List<_SectionConfig> _sections = <_SectionConfig>[
    _SectionConfig(
      label: 'Overview',
      icon: Icons.dashboard_outlined,
      colorSeed: _SectionColor.primary,
      description:
          'Summary panel — key facts displayed on the right while '
          'the left panel stays pinned in place.',
    ),
    _SectionConfig(
      label: 'Activity',
      icon: Icons.timeline,
      colorSeed: _SectionColor.secondary,
      description:
          'A feed of events. Scroll down the right side as far as you like '
          'and notice the left panel never moves.',
    ),
    _SectionConfig(
      label: 'Library',
      icon: Icons.collections_bookmark_outlined,
      colorSeed: _SectionColor.tertiary,
      description:
          'Media-style listing. Each section gets its own scroll position '
          'on the right while the sidebar stays constant.',
    ),
    _SectionConfig(
      label: 'Members',
      icon: Icons.group_outlined,
      colorSeed: _SectionColor.primary,
      description:
          'Team roster. Tap a section on the left to swap the content '
          'displayed on the right.',
    ),
    _SectionConfig(
      label: 'Settings',
      icon: Icons.settings_outlined,
      colorSeed: _SectionColor.secondary,
      description:
          'Preferences. The right-side CustomScrollView resets its scroll '
          'position each time you switch sections.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 720;
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: isWide
          ? Row(
              children: <Widget>[
                // ── Fixed left sidebar ─────────────────────────────────────
                _LeftSidebar(
                  sections: _sections,
                  selectedIndex: _selectedSection,
                  onSelect: (int i) => setState(() => _selectedSection = i),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: cs.outlineVariant,
                ),
                // ── Right panel: CustomScrollView ──────────────────────────
                Expanded(
                  child: _RightScrollPanel(
                    key: ValueKey<int>(_selectedSection),
                    section: _sections[_selectedSection],
                  ),
                ),
              ],
            )
          : _NarrowLayout(
              sections: _sections,
              selectedIndex: _selectedSection,
              onSelect: (int i) => setState(() => _selectedSection = i),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fixed left sidebar
// ─────────────────────────────────────────────────────────────────────────────

class _LeftSidebar extends StatelessWidget {
  const _LeftSidebar({
    required this.sections,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<_SectionConfig> sections;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return SizedBox(
      width: 280,
      child: ColoredBox(
        color: cs.surfaceContainerLowest,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ── Header ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Fixed Left Panel',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '+ CustomScrollView Right',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'The sidebar is a plain Column inside a SizedBox. '
                      'The right side is an Expanded child with a '
                      'CustomScrollView — no NestedScrollView needed.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Section navigation ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                child: Text(
                  'SECTIONS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              for (int i = 0; i < sections.length; i++)
                _SidebarNavItem(
                  section: sections[i],
                  selected: i == selectedIndex,
                  onTap: () => onSelect(i),
                ),

              const SizedBox(height: 8),
              Divider(
                height: 1,
                thickness: 1,
                indent: 20,
                endIndent: 20,
                color: cs.outlineVariant,
              ),

              // ── Pattern info (scrollable within sidebar) ──────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: _SidebarPatternCard(theme: theme, cs: cs),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarPatternCard extends StatelessWidget {
  const _SidebarPatternCard({required this.theme, required this.cs});

  final ThemeData theme;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'PATTERN',
          style: theme.textTheme.labelSmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.primary.withValues(alpha: 0.20)),
          ),
          child: Text(
            'Row(\n'
            '  children: [\n'
            '    SizedBox(          // ← fixed\n'
            '      width: 280,\n'
            '      child: Column(\n'
            '        children: sidebar,\n'
            '      ),\n'
            '    ),\n'
            '    VerticalDivider(),\n'
            '    Expanded(          // ← scrolls\n'
            '      child: CustomScrollView(\n'
            '        slivers: [\n'
            '          SliverAppBar(...),\n'
            '          SliverToBoxAdapter(\n'
            '            child: infoCard,\n'
            '          ),\n'
            '          SliverList(...),\n'
            '        ],\n'
            '      ),\n'
            '    ),\n'
            '  ],\n'
            ')',
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              height: 1.55,
              color: cs.onSurface,
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'KEY DIFFERENCES vs NestedScrollView',
          style: theme.textTheme.labelSmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 10),
        ...<_DiffRow>[
          const _DiffRow(
            icon: Icons.check_circle_outline,
            text:
                'No headerSliverBuilder — just put SliverAppBar directly '
                'inside the CustomScrollView slivers list.',
          ),
          const _DiffRow(
            icon: Icons.check_circle_outline,
            text:
                'No SliverOverlapAbsorber/Injector pair needed because '
                'there is only one scroll view.',
          ),
          const _DiffRow(
            icon: Icons.check_circle_outline,
            text:
                'Left panel is completely outside the scroll tree — '
                'it is a plain Row sibling.',
          ),
          const _DiffRow(
            icon: Icons.info_outline,
            text:
                'Use NestedScrollView when you need a TabBar inside the '
                'collapsing header sharing state across tabs.',
          ),
        ].map(
          (_DiffRow row) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(row.icon, size: 16, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    row.text,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DiffRow {
  const _DiffRow({required this.icon, required this.text});

  final IconData icon;
  final String text;
}

class _SidebarNavItem extends StatelessWidget {
  const _SidebarNavItem({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final _SectionConfig section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Color accent = section.colorSeed.resolve(cs);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected ? accent.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: accent.withValues(alpha: 0.15),
                  foregroundColor: accent,
                  child: Icon(section.icon, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? accent : cs.onSurface,
                    ),
                  ),
                ),
                if (selected)
                  Icon(Icons.chevron_right, size: 18, color: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Right panel — plain CustomScrollView, no NestedScrollView
// ─────────────────────────────────────────────────────────────────────────────

class _RightScrollPanel extends StatelessWidget {
  const _RightScrollPanel({super.key, required this.section});

  final _SectionConfig section;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Color accent = section.colorSeed.resolve(cs);

    return CustomScrollView(
      slivers: <Widget>[
        // ── Collapsing app bar (no headerSliverBuilder needed) ─────────────
        SliverAppBar(
          automaticallyImplyLeading: false,
          title: Text(section.label),
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(section.label, style: const TextStyle(fontSize: 14)),
            titlePadding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
            background: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[accent.withValues(alpha: 0.75), accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 32,
                    right: 24,
                    child: Icon(
                      section.icon,
                      size: 100,
                      color: cs.onPrimary.withValues(alpha: 0.12),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 80,
                    bottom: 56,
                    child: Text(
                      section.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onPrimary.withValues(alpha: 0.88),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Explainer card ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: _ExplainerCard(theme: theme, cs: cs),
          ),
        ),

        // ── Content list ───────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ContentCard(section: section, index: index),
              );
            }, childCount: 14),
          ),
        ),
      ],
    );
  }
}

class _ExplainerCard extends StatelessWidget {
  const _ExplainerCard({required this.theme, required this.cs});

  final ThemeData theme;
  final ColorScheme cs;

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
              'How this works',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The entire right column is one CustomScrollView. '
              'The SliverAppBar sits at the top of its slivers list and '
              'collapses as you scroll — no NestedScrollView or '
              'SliverOverlapAbsorber is required because there is only '
              'one scroll view involved. '
              'The left sidebar lives in a Row sibling and is completely '
              'outside the scroll tree.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const <Widget>[
                _KeyChip(label: 'CustomScrollView'),
                _KeyChip(label: 'SliverAppBar'),
                _KeyChip(label: 'SliverToBoxAdapter'),
                _KeyChip(label: 'SliverList'),
                _KeyChip(label: 'SliverPadding'),
                _KeyChip(label: 'Row (fixed left)'),
                _KeyChip(label: 'Expanded (right)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.section, required this.index});

  final _SectionConfig section;
  final int index;

  static const List<String> _tags = <String>[
    'right side scrolls',
    'left side fixed',
    'CustomScrollView',
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Color accent = section.colorSeed.resolve(cs);
    final int itemNumber = index + 1;
    final double progress = ((index % 5) + 1) / 5;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ── Header ──────────────────────────────────────────────────────
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: accent.withValues(alpha: 0.15),
                  foregroundColor: accent,
                  child: Text('$itemNumber'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${section.label} · Item $itemNumber',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'The SliverAppBar above collapses as you scroll here. '
                        'The sidebar on the left stays completely still.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Tags ─────────────────────────────────────────────────────────
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _tags
                  .map(
                    (String tag) => Chip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelStyle: theme.textTheme.labelSmall,
                      label: Text(tag),
                      backgroundColor: cs.surfaceContainerHighest,
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 12),

            // ── Progress bar ─────────────────────────────────────────────────
            Row(
              children: <Widget>[
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(999),
                    color: accent,
                    backgroundColor: accent.withValues(alpha: 0.14),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(progress * 100).round()}%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Actions ──────────────────────────────────────────────────────
            Row(
              children: <Widget>[
                FilledButton.tonalIcon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Inspect'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border, size: 18),
                  label: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyChip extends StatelessWidget {
  const _KeyChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(Icons.widgets_outlined, size: 14, color: cs.primary),
      label: Text(label, style: Theme.of(context).textTheme.labelSmall),
      backgroundColor: cs.primaryContainer.withValues(alpha: 0.45),
      side: BorderSide(color: cs.primary.withValues(alpha: 0.20)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Narrow layout (portrait / small screens)
// ─────────────────────────────────────────────────────────────────────────────

class _NarrowLayout extends StatefulWidget {
  const _NarrowLayout({
    required this.sections,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<_SectionConfig> sections;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  State<_NarrowLayout> createState() => _NarrowLayoutState();
}

class _NarrowLayoutState extends State<_NarrowLayout> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        ColoredBox(
          color: cs.surfaceContainerLowest,
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: List<Widget>.generate(
                  widget.sections.length,
                  (int i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(widget.sections[i].label),
                      avatar: Icon(widget.sections[i].icon, size: 16),
                      selected: i == widget.selectedIndex,
                      onSelected: (_) => widget.onSelect(i),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider(height: 1, thickness: 1, color: cs.outlineVariant),
        Expanded(
          child: _RightScrollPanel(
            key: ValueKey<int>(widget.selectedIndex),
            section: widget.sections[widget.selectedIndex],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────

enum _SectionColor {
  primary,
  secondary,
  tertiary;

  Color resolve(ColorScheme cs) {
    switch (this) {
      case _SectionColor.primary:
        return cs.primary;
      case _SectionColor.secondary:
        return cs.secondary;
      case _SectionColor.tertiary:
        return cs.tertiary;
    }
  }
}

class _SectionConfig {
  const _SectionConfig({
    required this.label,
    required this.icon,
    required this.colorSeed,
    required this.description,
  });

  final String label;
  final IconData icon;
  final _SectionColor colorSeed;
  final String description;
}
