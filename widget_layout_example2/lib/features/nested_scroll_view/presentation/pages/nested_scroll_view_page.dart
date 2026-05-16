import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.nestedScrollView)
class NestedScrollViewPage extends StatefulWidget {
  const NestedScrollViewPage({super.key});

  @override
  State<NestedScrollViewPage> createState() => _NestedScrollViewPageState();
}

class _NestedScrollViewPageState extends State<NestedScrollViewPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  bool _pinned = true;
  bool _floating = false;
  bool _snap = false;
  bool _useOverlapAbsorber = true;
  bool _innerBouncing = false;

  static const List<_NestedTabConfig> _tabs = <_NestedTabConfig>[
    _NestedTabConfig(
      label: 'Overview',
      icon: Icons.dashboard_outlined,
      colorSeed: _TabColorSeed.primary,
      description:
          'Dashboard-style cards and summary rows that share one collapsing header with the other tabs.',
    ),
    _NestedTabConfig(
      label: 'Activity',
      icon: Icons.timeline,
      colorSeed: _TabColorSeed.secondary,
      description:
          'A feed-like tab where the inner list takes over scrolling after the outer slivers collapse.',
    ),
    _NestedTabConfig(
      label: 'Library',
      icon: Icons.collections_bookmark_outlined,
      colorSeed: _TabColorSeed.tertiary,
      description:
          'A denser media-like view showing that each inner list can keep its own scroll position.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ScrollPhysics innerPhysics = _innerBouncing
        ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
        : const ClampingScrollPhysics();

    return Scaffold(
      body: SelectionArea(
        child: NestedScrollView(
          floatHeaderSlivers: _floating,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            final SliverAppBar headerSliver = SliverAppBar(
              title: const Text('NestedScrollView Module'),
              expandedHeight: 240,
              pinned: _pinned,
              floating: _floating,
              snap: _floating && _snap,
              forceElevated: innerBoxIsScrolled,
              // Let the theme drive the bar color so it adapts to light/dark.
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Shared Header + Inner Scrollables'),
                titlePadding: const EdgeInsetsDirectional.fromSTEB(
                  16,
                  0,
                  16,
                  16,
                ),
                background: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[cs.primaryContainer, cs.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 42,
                        right: 28,
                        child: Icon(
                          Icons.layers_outlined,
                          size: 116,
                          color: cs.onPrimary.withValues(alpha: 0.12),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: 64,
                        child: Text(
                          'NestedScrollView links one outer scroll view with one '
                          'active inner scrollable such as a TabBarView page.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onPrimary.withValues(alpha: 0.87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: _tabs
                    .map(
                      (_NestedTabConfig tab) =>
                          Tab(text: tab.label, icon: Icon(tab.icon)),
                    )
                    .toList(),
              ),
            );

            return <Widget>[
              if (_useOverlapAbsorber)
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: headerSliver,
                )
              else
                headerSliver,
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Why NestedScrollView',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Use NestedScrollView when you need an outer scrollable '
                            'header and an inner scrollable body to feel like one '
                            'coordinated surface. A common example is '
                            'SliverAppBar + TabBar + TabBarView with per-tab lists.',
                          ),
                          const SizedBox(height: 16),
                          const Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              _KeywordChip(label: 'NestedScrollView'),
                              _KeywordChip(label: 'headerSliverBuilder'),
                              _KeywordChip(label: 'SliverAppBar'),
                              _KeywordChip(label: 'TabBar'),
                              _KeywordChip(label: 'TabBarView'),
                              _KeywordChip(
                                label: 'SliverOverlapAbsorber/Injector',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Behavior Controls',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'These controls let you feel how the outer header and '
                            'inner lists coordinate. snap only applies while '
                            'floating is enabled.',
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Pinned header'),
                            subtitle: const Text(
                              'Keep the toolbar and tabs visible after the flexible space collapses.',
                            ),
                            value: _pinned,
                            onChanged: (bool value) {
                              setState(() {
                                _pinned = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Floating header'),
                            subtitle: const Text(
                              'Let the header reappear immediately when you reverse scroll direction.',
                            ),
                            value: _floating,
                            onChanged: (bool value) {
                              setState(() {
                                _floating = value;
                                if (!value) {
                                  _snap = false;
                                }
                              });
                            },
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Snap header'),
                            subtitle: const Text(
                              'Requires floating. The app bar will snap fully in or out.',
                            ),
                            value: _snap,
                            onChanged: _floating
                                ? (bool value) {
                                    setState(() {
                                      _snap = value;
                                    });
                                  }
                                : null,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Use overlap absorber/injector'),
                            subtitle: const Text(
                              'Recommended when the inner body uses slivers. It prevents content from sliding underneath the outer app bar.',
                            ),
                            value: _useOverlapAbsorber,
                            onChanged: (bool value) {
                              setState(() {
                                _useOverlapAbsorber = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Bouncing inner physics'),
                            subtitle: const Text(
                              'Swap the inner list scroll physics to compare platform feel.',
                            ),
                            value: _innerBouncing,
                            onChanged: (bool value) {
                              setState(() {
                                _innerBouncing = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Code Patterns',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const _SnippetBlock(
                            code:
                                'NestedScrollView(\n'
                                '  headerSliverBuilder: (context, innerBoxIsScrolled) {\n'
                                '    return <Widget>[\n'
                                '      SliverAppBar(\n'
                                '        pinned: true,\n'
                                '        bottom: TabBar(...),\n'
                                '      ),\n'
                                '    ];\n'
                                '  },\n'
                                '  body: TabBarView(\n'
                                '    children: <Widget>[\n'
                                '      Builder(\n'
                                '        builder: (context) => CustomScrollView(\n'
                                '          slivers: <Widget>[\n'
                                '            SliverOverlapInjector(\n'
                                '              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),\n'
                                '            ),\n'
                                '            SliverList(...),\n'
                                '          ],\n'
                                '        ),\n'
                                '      ),\n'
                                '    ],\n'
                                '  ),\n'
                                ')',
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Each tab below uses its own inner CustomScrollView. The active one cooperates with the outer header while still preserving per-tab content and structure.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: _tabs.map((_NestedTabConfig tab) {
              return _NestedTabBody(
                tab: tab,
                useOverlapAbsorber: _useOverlapAbsorber,
                physics: innerPhysics,
              );
            }).toList(),
          ),
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

class _NestedTabBody extends StatefulWidget {
  const _NestedTabBody({
    required this.tab,
    required this.useOverlapAbsorber,
    required this.physics,
  });

  final _NestedTabConfig tab;
  final bool useOverlapAbsorber;
  final ScrollPhysics physics;

  @override
  State<_NestedTabBody> createState() => _NestedTabBodyState();
}

class _NestedTabBodyState extends State<_NestedTabBody> {
  // Each tab body owns its controller so the desktop Scrollbar can attach
  // to exactly one ScrollPosition (sharing causes an assertion error).
  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final Color tabColor = widget.tab.colorSeed.resolve(cs);

    return Builder(
      builder: (BuildContext context) {
        return CustomScrollView(
          key: PageStorageKey<String>('nested-scroll-${widget.tab.label}'),
          controller: _scrollController,
          physics: widget.physics,
          slivers: <Widget>[
            if (widget.useOverlapAbsorber)
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Card(
                  color: tabColor.withValues(alpha: 0.08),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: tabColor.withValues(alpha: 0.22)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: tabColor.withValues(alpha: 0.18),
                          foregroundColor: tabColor,
                          child: Icon(widget.tab.icon),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.tab.label,
                                style: tt.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.tab.description,
                                style: tt.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _NestedListCard(tab: widget.tab, index: index),
                  );
                }, childCount: 10),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NestedListCard extends StatelessWidget {
  const _NestedListCard({required this.tab, required this.index});

  final _NestedTabConfig tab;
  final int index;

  static const List<String> _badges = <String>[
    'Inner list item',
    'Tab keeps its state',
    'Header already collapsed',
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Color tabColor = tab.colorSeed.resolve(cs);
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
                  backgroundColor: tabColor.withValues(alpha: 0.15),
                  foregroundColor: tabColor,
                  child: Text('$itemNumber'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${tab.label} Item $itemNumber',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'NestedScrollView passes control to this inner '
                        'scrollable once the shared header collapses.',
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

            // ── Chips ───────────────────────────────────────────────────────
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _badges
                  .map(
                    (String badge) => Chip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelStyle: theme.textTheme.labelSmall,
                      label: Text(badge),
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
                    color: tabColor,
                    backgroundColor: tabColor.withValues(alpha: 0.14),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(progress * 100).round()}%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: tabColor,
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

/// Identifies which Material 3 color role to use for a tab accent.
enum _TabColorSeed {
  primary,
  secondary,
  tertiary;

  /// Resolves to the matching role color from the active [ColorScheme].
  Color resolve(ColorScheme cs) {
    switch (this) {
      case _TabColorSeed.primary:
        return cs.primary;
      case _TabColorSeed.secondary:
        return cs.secondary;
      case _TabColorSeed.tertiary:
        return cs.tertiary;
    }
  }
}

class _NestedTabConfig {
  const _NestedTabConfig({
    required this.label,
    required this.icon,
    required this.colorSeed,
    required this.description,
  });

  final String label;
  final IconData icon;
  final _TabColorSeed colorSeed;
  final String description;
}

class _KeywordChip extends StatelessWidget {
  const _KeywordChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(Icons.swap_vert, size: 16, color: cs.primary),
      label: Text(label, style: Theme.of(context).textTheme.labelSmall),
      backgroundColor: cs.primaryContainer.withValues(alpha: 0.45),
      side: BorderSide(color: cs.primary.withValues(alpha: 0.20)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _SnippetBlock extends StatelessWidget {
  const _SnippetBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    // Use a dark surface regardless of theme so code is always legible.
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark
        ? cs.surfaceContainerHighest
        : const Color(0xFF1E1E2E); // near-black code background
    final Color fg = isDark ? cs.onSurface : const Color(0xFFCDD6F4);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        code,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          height: 1.6,
          color: fg,
        ),
      ),
    );
  }
}
