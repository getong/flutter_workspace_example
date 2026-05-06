import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.flutterStaggeredGridView)
class FlutterStaggeredGridViewPage extends StatelessWidget {
  const FlutterStaggeredGridViewPage({super.key});

  static const List<_GridDemoItem> _items = <_GridDemoItem>[
    _GridDemoItem(
      title: 'Hero Banner',
      subtitle: 'Highlights a featured item with extra visual weight.',
      color: Color(0xFF2563EB),
      height: 180,
      icon: Icons.dashboard_customize,
    ),
    _GridDemoItem(
      title: 'Compact Card',
      subtitle: 'Useful for small actions or metadata.',
      color: Color(0xFF0F766E),
      height: 110,
      icon: Icons.tune,
    ),
    _GridDemoItem(
      title: 'Photo Tile',
      subtitle: 'Different heights create a Pinterest-like scan pattern.',
      color: Color(0xFFEA580C),
      height: 150,
      icon: Icons.photo_library_outlined,
    ),
    _GridDemoItem(
      title: 'Status Tile',
      subtitle:
          'Masonry layouts preserve child height instead of forcing a fixed ratio.',
      color: Color(0xFF7C3AED),
      height: 200,
      icon: Icons.monitor_heart_outlined,
    ),
    _GridDemoItem(
      title: 'Wide Insight',
      subtitle:
          'Quilted layouts help establish hierarchy in dashboards and galleries.',
      color: Color(0xFFBE123C),
      height: 140,
      icon: Icons.insights_outlined,
    ),
    _GridDemoItem(
      title: 'Small Note',
      subtitle:
          'Short content can remain compact without wasting vertical space.',
      color: Color(0xFF0891B2),
      height: 100,
      icon: Icons.sticky_note_2_outlined,
    ),
    _GridDemoItem(
      title: 'Product Block',
      subtitle: 'Staggered tiles can make featured products stand out.',
      color: Color(0xFF65A30D),
      height: 170,
      icon: Icons.shopping_bag_outlined,
    ),
    _GridDemoItem(
      title: 'Feed Card',
      subtitle: 'Mixed heights improve density for content collections.',
      color: Color(0xFFB45309),
      height: 130,
      icon: Icons.view_stream_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_staggered_grid_view Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'flutter_staggered_grid_view provides grid layouts that break out of a fixed, uniform tile pattern.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'It is useful when some content should be larger, when child heights differ naturally, or when you want a denser, more editorial layout than a regular GridView.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _SectionCard(
              title: 'What this package is for',
              description:
                  'Use it for galleries, dashboards, product feeds, editorial cards, or any UI where equal-sized cells feel too rigid.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  _TagChip(label: 'Masonry'),
                  _TagChip(label: 'Staggered'),
                  _TagChip(label: 'Quilted'),
                  _TagChip(label: 'Variable heights'),
                  _TagChip(label: 'Visual hierarchy'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '1. StaggeredGrid',
              description:
                  'A small, non-scrollable grid where each tile can occupy a different number of cells. This is useful for featured content blocks.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StaggeredGrid.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: <Widget>[
                      StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 2,
                        child: _FeatureTile(item: _items[0]),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 1,
                        child: _FeatureTile(item: _items[1]),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: _FeatureTile(item: _items[2]),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: _FeatureTile(item: _items[5]),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 4,
                        mainAxisCellCount: 1,
                        child: _FeatureTile(item: _items[4]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _CodeBlock(
                    code:
                        'StaggeredGrid.count(\n'
                        '  crossAxisCount: 4,\n'
                        '  children: [\n'
                        '    StaggeredGridTile.count(\n'
                        '      crossAxisCellCount: 2,\n'
                        '      mainAxisCellCount: 2,\n'
                        '      child: YourTile(),\n'
                        '    ),\n'
                        '  ],\n'
                        ')',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '2. MasonryGridView',
              description:
                  'Masonry layouts are ideal when item heights come from the child itself, such as images, cards, or dynamic text content.',
              child: SizedBox(
                height: 520,
                child: MasonryGridView.count(
                  crossAxisCount: MediaQuery.sizeOf(context).width > 800
                      ? 4
                      : 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: _items.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return _MasonryTile(item: _items[index]);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '3. Quilted Grid Delegate',
              description:
                  'Quilted patterns sit on top of the built-in GridView API and repeat a tile pattern to emphasize some items over others.',
              child: SizedBox(
                height: 420,
                child: GridView.custom(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: const <QuiltedGridTile>[
                      QuiltedGridTile(2, 2),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 2),
                    ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    return _FeatureTile(item: _items[index % _items.length]);
                  }, childCount: 8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _SectionCard(
              title: 'When to choose it',
              description:
                  'Pick a regular GridView when every item should feel equal. Pick this package when you need mixed emphasis, variable heights, or a more magazine-like visual rhythm.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '`StaggeredGrid`: small handcrafted layouts with explicit tile spans.',
                  ),
                  SizedBox(height: 8),
                  Text(
                    '`MasonryGridView`: long feeds where child height varies naturally.',
                  ),
                  SizedBox(height: 8),
                  Text(
                    '`SliverQuiltedGridDelegate`: repeating highlight patterns inside GridView.',
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

class _GridDemoItem {
  const _GridDemoItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.height,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color color;
  final double height;
  final IconData icon;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
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

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.item});

  final _GridDemoItem item;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompact =
            constraints.maxWidth < 150 || constraints.maxHeight < 150;
        final bool showSubtitle =
            constraints.maxWidth >= 140 && constraints.maxHeight >= 150;
        final double padding = isCompact ? 12 : 16;
        final double iconSize = isCompact ? 22 : 28;
        final double titleSize = isCompact ? 15 : 18;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[item.color, item.color.withValues(alpha: 0.72)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(item.icon, color: Colors.white, size: iconSize),
              const Spacer(),
              Text(
                item.title,
                maxLines: isCompact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: titleSize,
                ),
              ),
              if (showSubtitle) ...<Widget>[
                SizedBox(height: isCompact ? 4 : 8),
                Text(
                  item.subtitle,
                  maxLines: isCompact ? 1 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _MasonryTile extends StatelessWidget {
  const _MasonryTile({required this.item});

  final _GridDemoItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: item.height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isShort = constraints.maxHeight < 155;
          final bool isMedium = constraints.maxHeight < 185;
          final bool showSubtitle = !isShort;
          final bool showFooter = !isMedium;
          final double padding = isShort ? 10 : 16;
          final double titleSize = isShort ? 14 : 17;
          final double badgeHorizontalPadding = isShort ? 8 : 10;
          final double badgeVerticalPadding = isShort ? 3 : 6;
          final double headerGap = isShort ? 8 : 16;

          return Container(
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: item.color.withValues(alpha: 0.28)),
            ),
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(item.icon, color: item.color, size: isShort ? 20 : 24),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: badgeHorizontalPadding,
                        vertical: badgeVerticalPadding,
                      ),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${item.height.toInt()}px',
                        style: TextStyle(
                          color: item.color,
                          fontWeight: FontWeight.w600,
                          fontSize: isShort ? 11 : 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: headerGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        maxLines: isShort ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: titleSize,
                            ),
                      ),
                      if (showSubtitle) ...<Widget>[
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            item.subtitle,
                            maxLines: showFooter ? 3 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                      if (showFooter) ...<Widget>[
                        const SizedBox(height: 8),
                        Text(
                          'Height comes from the child, not a fixed aspect ratio.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          color: Colors.white,
          height: 1.5,
        ),
      ),
    );
  }
}
