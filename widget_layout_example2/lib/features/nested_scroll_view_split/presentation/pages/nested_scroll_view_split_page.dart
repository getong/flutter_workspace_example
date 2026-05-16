import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.nestedScrollViewSplit)
class NestedScrollViewSplitPage extends StatefulWidget {
  const NestedScrollViewSplitPage({super.key});

  @override
  State<NestedScrollViewSplitPage> createState() =>
      _NestedScrollViewSplitPageState();
}

class _NestedScrollViewSplitPageState extends State<NestedScrollViewSplitPage> {
  int _selectedSection = 0;
  bool _pinned = true;
  bool _floating = false;
  bool _snap = false;
  bool _useOverlapAbsorber = true;

  static const List<_SplitSectionConfig> _sections = <_SplitSectionConfig>[
    _SplitSectionConfig(
      label: 'Overview',
      icon: Icons.dashboard_outlined,
      colorSeed: _SplitColor.primary,
      description:
          'Summary panel — key metrics and pinned information load here while '
          'the sidebar stays perfectly still.',
    ),
    _SplitSectionConfig(
      label: 'Activity',
      icon: Icons.timeline,
      colorSeed: _SplitColor.secondary,
      description:
          'Activity feed: the right side scrolls through events while the left '
          'navigation panel remains anchored.',
    ),
    _SplitSectionConfig(
      label: 'Library',
      icon: Icons.collections_bookmark_outlined,
      colorSeed: _SplitColor.tertiary,
      description:
          'Library view — each section swap resets the right-panel scroll '
          'position without disturbing the sidebar.',
    ),
    _SplitSectionConfig(
      label: 'Members',
      icon: Icons.group_outlined,
      colorSeed: _SplitColor.primary,
      description:
          'Team roster. Selecting a section on the left drives the content '
          'on the right via NestedScrollView.',
    ),
    _SplitSectionConfig(
      label: 'Settings',
      icon: Icons.settings_outlined,
      colorSeed: _SplitColor.secondary,
      description:
          'Preferences pane. The left navigation panel never scrolls away '
          'regardless of how far you scroll right.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool isWide = MediaQuery.sizeOf(context).width >= 720;
    final _SplitSectionConfig section = _sections[_selectedSection];

    return Scaffold(
      body: isWide
          ? Row(
              children: <Widget>[
                // ── Fixed left sidebar ─────────────────────────────────────
                _LeftSidebar(
                  sections: _sections,
                  selectedIndex: _selectedSection,
                  onSectionSelected: (int i) =>
                      setState(() => _selectedSection = i),
                  pinned: _pinned,
                  floating: _floating,
                  snap: _snap,
                  useOverlapAbsorber: _useOverlapAbsorber,
                  onPinnedChanged: (bool v) => setState(() => _pinned = v),
                  onFloatingChanged: (bool v) => setState(() {
                    _floating = v;
                    if (!v) _snap = false;
                  }),
                  onSnapChanged: (bool v) => setState(() => _snap = v),
                  onOverlapAbsorberChanged: (bool v) =>
                      setState(() => _useOverlapAbsorber = v),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: cs.outlineVariant,
                ),
                // ── Right panel — NestedScrollView ─────────────────────────
                Expanded(
                  child: _RightNestedPanel(
                    key: ValueKey<int>(_selectedSection),
                    section: section,
                    pinned: _pinned,
                    floating: _floating,
                    snap: _snap,
                    useOverlapAbsorber: _useOverlapAbsorber,
                  ),
                ),
              ],
            )
          : _NarrowLayout(
              sections: _sections,
              selectedIndex: _selectedSection,
              onSectionSelected: (int i) =>
                  setState(() => _selectedSection = i),
              section: section,
              pinned: _pinned,
              floating: _floating,
              snap: _snap,
              useOverlapAbsorber: _useOverlapAbsorber,
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
    required this.onSectionSelected,
    required this.pinned,
    required this.floating,
    required this.snap,
    required this.useOverlapAbsorber,
    required this.onPinnedChanged,
    required this.onFloatingChanged,
    required this.onSnapChanged,
    required this.onOverlapAbsorberChanged,
  });

  final List<_SplitSectionConfig> sections;
  final int selectedIndex;
  final ValueChanged<int> onSectionSelected;
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool useOverlapAbsorber;
  final ValueChanged<bool> onPinnedChanged;
  final ValueChanged<bool> onFloatingChanged;
  final ValueChanged<bool> onSnapChanged;
  final ValueChanged<bool> onOverlapAbsorberChanged;

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
                      '+ NestedScrollView Right',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'This sidebar never scrolls. '
                      'The right panel uses NestedScrollView with a '
                      'collapsing SliverAppBar.',
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
                  onTap: () => onSectionSelected(i),
                ),
              const SizedBox(height: 8),
              Divider(
                height: 1,
                thickness: 1,
                indent: 20,
                endIndent: 20,
                color: cs.outlineVariant,
              ),

              // ── Controls & pattern info (scrollable within sidebar) ───────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'RIGHT PANEL CONTROLS',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _CompactSwitch(
                        label: 'Pinned header',
                        value: pinned,
                        onChanged: onPinnedChanged,
                      ),
                      _CompactSwitch(
                        label: 'Floating header',
                        value: floating,
                        onChanged: onFloatingChanged,
                      ),
                      _CompactSwitch(
                        label: 'Snap (requires floating)',
                        value: snap,
                        onChanged: floating ? onSnapChanged : null,
                      ),
                      _CompactSwitch(
                        label: 'Overlap absorber/injector',
                        value: useOverlapAbsorber,
                        onChanged: onOverlapAbsorberChanged,
                      ),
                      const SizedBox(height: 16),
                      // ── Pattern code card ─────────────────────────────────
                      _SidebarCodeCard(cs: cs, theme: theme),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarCodeCard extends StatelessWidget {
  const _SidebarCodeCard({required this.cs, required this.theme});

  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.code, size: 14, color: cs.primary),
              const SizedBox(width: 6),
              Text(
                'Pattern',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Row(\n'
            '  children: [\n'
            '    SizedBox(     // ← fixed\n'
            '      width: 280,\n'
            '      child: sidebar,\n'
            '    ),\n'
            '    VerticalDivider(),\n'
            '    Expanded(     // ← scrolls\n'
            '      child: NestedScrollView(\n'
            '        headerSliverBuilder:\n'
            '          => [SliverAppBar(...)],\n'
            '        body: CustomScrollView(\n'
            '          slivers: [\n'
            '            SliverOverlapInjector,\n'
            '            SliverList(...),\n'
            '          ],\n'
            '        ),\n'
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
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  const _SidebarNavItem({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final _SplitSectionConfig section;
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

class _CompactSwitch extends StatelessWidget {
  const _CompactSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(label, style: Theme.of(context).textTheme.bodySmall),
      value: value,
      onChanged: onChanged,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Right panel — uses NestedScrollView
// ─────────────────────────────────────────────────────────────────────────────

class _RightNestedPanel extends StatefulWidget {
  const _RightNestedPanel({
    super.key,
    required this.section,
    required this.pinned,
    required this.floating,
    required this.snap,
    required this.useOverlapAbsorber,
  });

  final _SplitSectionConfig section;
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool useOverlapAbsorber;

  @override
  State<_RightNestedPanel> createState() => _RightNestedPanelState();
}

class _RightNestedPanelState extends State<_RightNestedPanel> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Color accent = widget.section.colorSeed.resolve(cs);

    return NestedScrollView(
      floatHeaderSlivers: widget.floating,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        final SliverAppBar headerSliver = SliverAppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.section.label),
          expandedHeight: 200,
          pinned: widget.pinned,
          floating: widget.floating,
          snap: widget.floating && widget.snap,
          forceElevated: innerBoxIsScrolled,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              widget.section.label,
              style: const TextStyle(fontSize: 14),
            ),
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
                      widget.section.icon,
                      size: 100,
                      color: cs.onPrimary.withValues(alpha: 0.12),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 80,
                    bottom: 56,
                    child: Text(
                      widget.section.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onPrimary.withValues(alpha: 0.88),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        return <Widget>[
          if (widget.useOverlapAbsorber)
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: headerSliver,
            )
          else
            headerSliver,
        ];
      },
      body: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              if (widget.useOverlapAbsorber)
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _ExplainerCard(theme: theme, cs: cs),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SplitContentCard(
                        section: widget.section,
                        index: index,
                      ),
                    );
                  }, childCount: 12),
                ),
              ),
            ],
          );
        },
      ),
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
              'The left sidebar is a plain SizedBox with fixed width inside '
              'a Row — it is never part of any scrollable. '
              'The right side is an Expanded child wrapping a '
              'NestedScrollView whose headerSliverBuilder returns a '
              'SliverAppBar. That SliverAppBar collapses only within '
              'the right column; the left panel is completely unaffected.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const <Widget>[
                _KeyChip(label: 'Row'),
                _KeyChip(label: 'SizedBox (fixed left)'),
                _KeyChip(label: 'Expanded (right)'),
                _KeyChip(label: 'NestedScrollView'),
                _KeyChip(label: 'SliverAppBar'),
                _KeyChip(label: 'SliverOverlapAbsorber'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SplitContentCard extends StatelessWidget {
  const _SplitContentCard({required this.section, required this.index});

  final _SplitSectionConfig section;
  final int index;

  static const List<String> _tags = <String>[
    'right panel scrolls',
    'left panel fixed',
    'NestedScrollView',
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
            // ── Header row ─────────────────────────────────────────────────
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
                        'Scroll down — the SliverAppBar above collapses '
                        'while the sidebar stays still.',
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

            // ── Tags ────────────────────────────────────────────────────────
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

            // ── Progress bar ────────────────────────────────────────────────
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

            // ── Actions ─────────────────────────────────────────────────────
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
// Narrow (portrait / small screen) layout
// ─────────────────────────────────────────────────────────────────────────────

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({
    required this.sections,
    required this.selectedIndex,
    required this.onSectionSelected,
    required this.section,
    required this.pinned,
    required this.floating,
    required this.snap,
    required this.useOverlapAbsorber,
  });

  final List<_SplitSectionConfig> sections;
  final int selectedIndex;
  final ValueChanged<int> onSectionSelected;
  final _SplitSectionConfig section;
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool useOverlapAbsorber;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        // Horizontal chip bar replaces the left sidebar on narrow screens
        ColoredBox(
          color: cs.surfaceContainerLowest,
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: List<Widget>.generate(sections.length, (int i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(sections[i].label),
                      avatar: Icon(sections[i].icon, size: 16),
                      selected: i == selectedIndex,
                      onSelected: (_) => onSectionSelected(i),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        Divider(height: 1, thickness: 1, color: cs.outlineVariant),
        Expanded(
          child: _RightNestedPanel(
            key: ValueKey<int>(selectedIndex),
            section: section,
            pinned: pinned,
            floating: floating,
            snap: snap,
            useOverlapAbsorber: useOverlapAbsorber,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────

enum _SplitColor {
  primary,
  secondary,
  tertiary;

  Color resolve(ColorScheme cs) {
    switch (this) {
      case _SplitColor.primary:
        return cs.primary;
      case _SplitColor.secondary:
        return cs.secondary;
      case _SplitColor.tertiary:
        return cs.tertiary;
    }
  }
}

class _SplitSectionConfig {
  const _SplitSectionConfig({
    required this.label,
    required this.icon,
    required this.colorSeed,
    required this.description,
  });

  final String label;
  final IconData icon;
  final _SplitColor colorSeed;
  final String description;
}
