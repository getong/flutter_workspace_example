import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SliverExamplesPage extends StatelessWidget {
  const SliverExamplesPage({super.key});

  static const List<_LessonData> _coreLessons = <_LessonData>[
    _LessonData(
      title: 'SliverToBoxAdapter',
      summary:
          'Adapts one normal box widget into the sliver world, which is ideal for headers, hero cards, banners, and one-off explanatory sections.',
      color: Colors.blue,
      code:
          'SliverToBoxAdapter(\n'
          '  child: Padding(\n'
          '    padding: EdgeInsets.all(24),\n'
          '    child: Card(child: Text(\'Header\')),\n'
          '  ),\n'
          ')',
    ),
    _LessonData(
      title: 'SliverList',
      summary:
          'Keeps repeated scrolling content inside the same CustomScrollView instead of nesting a ListView.',
      color: Colors.green,
      code:
          'SliverList(\n'
          '  delegate: SliverChildBuilderDelegate(\n'
          '    (context, index) => ListTile(title: Text(\'Row \$index\')),\n'
          '    childCount: 8,\n'
          '  ),\n'
          ')',
    ),
    _LessonData(
      title: 'SliverPadding',
      summary:
          'Wraps another sliver to give it inset spacing, which is cleaner than padding every item manually.',
      color: Colors.orange,
      code:
          'SliverPadding(\n'
          '  padding: EdgeInsets.symmetric(horizontal: 24),\n'
          '  sliver: SliverList(...),\n'
          ')',
    ),
    _LessonData(
      title: 'SliverFillRemaining',
      summary:
          'Expands the trailing section to fill leftover viewport space when content is short, which is useful for empty states and final CTAs.',
      color: Colors.purple,
      code:
          'SliverFillRemaining(\n'
          '  hasScrollBody: false,\n'
          '  child: Center(child: Text(\'Done\')),\n'
          ')',
    ),
  ];

  static const List<_FeatureRowData> _featureRows = <_FeatureRowData>[
    _FeatureRowData(
      label: 'Hero intro',
      sliver: 'SliverToBoxAdapter',
      color: Colors.blue,
    ),
    _FeatureRowData(
      label: 'Card list',
      sliver: 'SliverList',
      color: Colors.green,
    ),
    _FeatureRowData(
      label: 'Inset sections',
      sliver: 'SliverPadding',
      color: Colors.orange,
    ),
    _FeatureRowData(
      label: 'Footer CTA',
      sliver: 'SliverFillRemaining',
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sliver Widgets Module')),
      body: SelectionArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _HeroCard(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'What This Page Demonstrates',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'This page intentionally uses a single `CustomScrollView` so the requested slivers appear in realistic positions instead of isolated code fragments.',
                      ),
                      SizedBox(height: 16),
                      _SliverMapPreview(),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  final _LessonData lesson = _coreLessons[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == _coreLessons.length - 1 ? 0 : 16,
                    ),
                    child: _LessonCard(index: index, lesson: lesson),
                  );
                }, childCount: _coreLessons.length),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverToBoxAdapter Examples',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'A normal box widget cannot live directly inside `CustomScrollView.slivers`. `SliverToBoxAdapter` is the bridge when you need one-off content.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverToBoxAdapter(\n'
                            '  child: Container(\n'
                            '    padding: EdgeInsets.all(24),\n'
                            '    child: Text(\'Marketing banner\'),\n'
                            '  ),\n'
                            ')',
                      ),
                      SizedBox(height: 16),
                      _PreviewPanel(
                        color: Colors.blue,
                        child: Text(
                          'Header card, banner, stats panel, or explanatory block',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              sliver: SliverList.list(
                children: const <Widget>[
                  _SubsectionCard(
                    title: 'SliverList Builder Pattern',
                    description:
                        'This uses another `SliverList`, but this time as a concrete example list of feed items rather than abstract lesson cards.',
                    code:
                        'SliverList(\n'
                        '  delegate: SliverChildBuilderDelegate(\n'
                        '    (context, index) => FeedCard(item: items[index]),\n'
                        '    childCount: items.length,\n'
                        '  ),\n'
                        ')',
                  ),
                  SizedBox(height: 16),
                  _FeedPreviewRow(
                    title: 'Build rows from data',
                    subtitle:
                        'Keep repeated content in the same sliver scroll surface.',
                    color: Colors.green,
                  ),
                  SizedBox(height: 12),
                  _FeedPreviewRow(
                    title: 'Avoid nested ListView',
                    subtitle:
                        'The scroll physics stay unified under CustomScrollView.',
                    color: Colors.teal,
                  ),
                  SizedBox(height: 12),
                  _FeedPreviewRow(
                    title: 'Supports large lists',
                    subtitle:
                        'Builder delegates stay efficient when item counts grow.',
                    color: Colors.lightGreen,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverPadding Examples',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Padding belongs around a sliver when the spacing should affect the entire sliver section, not just one row.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverPadding(\n'
                            '  padding: EdgeInsets.fromLTRB(24, 16, 24, 0),\n'
                            '  sliver: SliverList(...),\n'
                            ')',
                      ),
                      SizedBox(height: 16),
                      _PaddingPreview(),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverFillRemaining Variants',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Use `hasScrollBody: false` when the child should stretch to the bottom if space remains. This is a strong fit for empty states and final call-to-action panels.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverFillRemaining(\n'
                            '  hasScrollBody: false,\n'
                            '  child: Column(\n'
                            '    mainAxisAlignment: MainAxisAlignment.center,\n'
                            '    children: [...],\n'
                            '  ),\n'
                            ')',
                      ),
                      SizedBox(height: 16),
                      _FillRemainingPreview(),
                    ],
                  ),
                ),
              ),
            ),
            // ── Additional SliverToBoxAdapter Examples ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverToBoxAdapter — Stats Row',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Use `SliverToBoxAdapter` for dashboard-style stat rows that appear once in the scroll view.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverToBoxAdapter(\n'
                            '  child: Row(\n'
                            '    mainAxisAlignment:\n'
                            '        MainAxisAlignment.spaceEvenly,\n'
                            '    children: [\n'
                            '      _StatTile(label: \'Users\', value: \'1.2k\'),\n'
                            '      _StatTile(label: \'Posts\', value: \'847\'),\n'
                            '      _StatTile(label: \'Likes\', value: \'5.3k\'),\n'
                            '    ],\n'
                            '  ),\n'
                            ')',
                        tint: Colors.blue,
                      ),
                      SizedBox(height: 16),
                      _StatsRowPreview(),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverToBoxAdapter — Search Bar',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'A search field that scrolls with the rest of the content. Unlike `SliverAppBar`, this stays inline and does not pin.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverToBoxAdapter(\n'
                            '  child: Padding(\n'
                            '    padding: EdgeInsets.symmetric(\n'
                            '      horizontal: 24, vertical: 8,\n'
                            '    ),\n'
                            '    child: TextField(\n'
                            '      decoration: InputDecoration(\n'
                            '        hintText: \'Search…\',\n'
                            '        prefixIcon: Icon(Icons.search),\n'
                            '        border: OutlineInputBorder(\n'
                            '          borderRadius:\n'
                            '              BorderRadius.circular(16),\n'
                            '        ),\n'
                            '      ),\n'
                            '    ),\n'
                            '  ),\n'
                            ')',
                        tint: Colors.blue,
                      ),
                      SizedBox(height: 16),
                      _SearchBarPreview(),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverToBoxAdapter — Image Banner',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Great for promotional banners or hero images that are not part of a repeating list.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverToBoxAdapter(\n'
                            '  child: ClipRRect(\n'
                            '    borderRadius: BorderRadius.circular(16),\n'
                            '    child: Image.network(\n'
                            '      \'https://picsum.photos/800/300\',\n'
                            '      height: 180,\n'
                            '      width: double.infinity,\n'
                            '      fit: BoxFit.cover,\n'
                            '    ),\n'
                            '  ),\n'
                            ')',
                        tint: Colors.blue,
                      ),
                      SizedBox(height: 16),
                      _ImageBannerPreview(),
                    ],
                  ),
                ),
              ),
            ),

            // ── Additional SliverList Examples ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverList.separated',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Flutter 3.x introduced `SliverList.separated` which automatically inserts a separator widget between each item — no manual index math required.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverList.separated(\n'
                            '  itemCount: 5,\n'
                            '  itemBuilder: (context, index) =>\n'
                            '      ListTile(\n'
                            '        leading: CircleAvatar(\n'
                            '          child: Text(\'\${index + 1}\'),\n'
                            '        ),\n'
                            '        title: Text(\'Item \$index\'),\n'
                            '      ),\n'
                            '  separatorBuilder: (context, index) =>\n'
                            '      const Divider(height: 1),\n'
                            ')',
                        tint: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              sliver: SliverList.separated(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  final List<IconData> icons = <IconData>[
                    Icons.star,
                    Icons.favorite,
                    Icons.bolt,
                    Icons.eco,
                    Icons.palette,
                  ];
                  final List<String> labels = <String>[
                    'Starred',
                    'Favourites',
                    'Quick Actions',
                    'Eco Mode',
                    'Theme Picker',
                  ];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.withValues(alpha: 0.14),
                        child: Icon(icons[index], color: Colors.green),
                      ),
                      title: Text(labels[index]),
                      subtitle: Text('SliverList.separated item $index'),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 4),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverList with Mixed Content',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Use `SliverChildListDelegate` when each child is unique. Ideal for settings screens or onboarding steps.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverList(\n'
                            '  delegate: SliverChildListDelegate([\n'
                            '    SwitchListTile(\n'
                            '      title: Text(\'Dark Mode\'),\n'
                            '      value: true,\n'
                            '      onChanged: (_) {},\n'
                            '    ),\n'
                            '    ListTile(\n'
                            '      title: Text(\'Language\'),\n'
                            '      trailing: Text(\'English\'),\n'
                            '    ),\n'
                            '    AboutListTile(applicationName: \'App\'),\n'
                            '  ]),\n'
                            ')',
                        tint: Colors.green,
                      ),
                      SizedBox(height: 16),
                      _MixedContentPreview(),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverFixedExtentList',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'When every item has the same height, `SliverFixedExtentList` is more efficient because it skips measuring each child.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverFixedExtentList(\n'
                            '  itemExtent: 56.0,\n'
                            '  delegate: SliverChildBuilderDelegate(\n'
                            '    (context, index) => ListTile(\n'
                            '      title: Text(\'Fixed row \$index\'),\n'
                            '    ),\n'
                            '    childCount: 20,\n'
                            '  ),\n'
                            ')',
                        tint: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Additional SliverPadding Examples ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'Nested SliverPadding',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'SliverPadding can wrap another SliverPadding. The outer layer adds horizontal insets while the inner adds vertical spacing.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverPadding(\n'
                            '  padding: EdgeInsets.symmetric(\n'
                            '    horizontal: 24,\n'
                            '  ),\n'
                            '  sliver: SliverPadding(\n'
                            '    padding: EdgeInsets.symmetric(\n'
                            '      vertical: 12,\n'
                            '    ),\n'
                            '    sliver: SliverList(\n'
                            '      delegate: SliverChildBuilderDelegate(\n'
                            '        (ctx, i) => Card(\n'
                            '          child: ListTile(\n'
                            '            title: Text(\'Nested \$i\'),\n'
                            '          ),\n'
                            '        ),\n'
                            '        childCount: 3,\n'
                            '      ),\n'
                            '    ),\n'
                            '  ),\n'
                            ')',
                        tint: Colors.orange,
                      ),
                      SizedBox(height: 16),
                      _NestedPaddingPreview(),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverPadding with SliverGrid',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'SliverPadding works with any sliver child — not just SliverList. Wrapping a grid gives the entire grid consistent page margins.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverPadding(\n'
                            '  padding: EdgeInsets.all(16),\n'
                            '  sliver: SliverGrid(\n'
                            '    gridDelegate:\n'
                            '        SliverGridDelegateWithFixedCrossAxisCount(\n'
                            '      crossAxisCount: 2,\n'
                            '      mainAxisSpacing: 12,\n'
                            '      crossAxisSpacing: 12,\n'
                            '    ),\n'
                            '    delegate: SliverChildBuilderDelegate(\n'
                            '      (ctx, i) => Card(\n'
                            '        child: Center(\n'
                            '          child: Text(\'Tile \$i\'),\n'
                            '        ),\n'
                            '      ),\n'
                            '      childCount: 4,\n'
                            '    ),\n'
                            '  ),\n'
                            ')',
                        tint: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Live SliverPadding + SliverGrid demo
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                ),
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  final List<Color> colors = <Color>[
                    Colors.orange,
                    Colors.deepOrange,
                    Colors.amber,
                    Colors.brown,
                  ];
                  final List<IconData> gridIcons = <IconData>[
                    Icons.grid_view,
                    Icons.dashboard,
                    Icons.widgets,
                    Icons.view_module,
                  ];
                  return Card(
                    color: colors[index].withValues(alpha: 0.12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(gridIcons[index], color: colors[index]),
                        const SizedBox(height: 6),
                        Text(
                          'Grid Tile $index',
                          style: TextStyle(
                            color: colors[index],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }, childCount: 4),
              ),
            ),

            // ── Additional SliverFillRemaining Examples ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverFillRemaining — Empty State',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'When a search or filter returns zero results, SliverFillRemaining centres the empty-state illustration in all remaining viewport space.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverFillRemaining(\n'
                            '  hasScrollBody: false,\n'
                            '  child: Center(\n'
                            '    child: Column(\n'
                            '      mainAxisSize: MainAxisSize.min,\n'
                            '      children: [\n'
                            '        Icon(Icons.search_off, size: 64),\n'
                            '        SizedBox(height: 16),\n'
                            '        Text(\'No results found\'),\n'
                            '        SizedBox(height: 8),\n'
                            '        TextButton(\n'
                            '          onPressed: clearFilters,\n'
                            '          child: Text(\'Clear filters\'),\n'
                            '        ),\n'
                            '      ],\n'
                            '    ),\n'
                            '  ),\n'
                            ')',
                        tint: Colors.purple,
                      ),
                      SizedBox(height: 16),
                      _EmptyStatePreview(),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverFillRemaining — fillOverscroll',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Set `fillOverscroll: true` to make the child stretch beyond the viewport on overscroll (iOS bounce). This gives a polished feel on iOS.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverFillRemaining(\n'
                            '  hasScrollBody: false,\n'
                            '  fillOverscroll: true,\n'
                            '  child: Container(\n'
                            '    color: Colors.indigo.shade50,\n'
                            '    child: Center(\n'
                            '      child: Text(\n'
                            '        \'Stretches on iOS overscroll\',\n'
                            '      ),\n'
                            '    ),\n'
                            '  ),\n'
                            ')',
                        tint: Colors.purple,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'SliverFillRemaining — Scrollable Child',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'When `hasScrollBody: true` (default), the child can contain its own scrollable view, such as a nested list or a `SingleChildScrollView`.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'SliverFillRemaining(\n'
                            '  // hasScrollBody defaults to true\n'
                            '  child: SingleChildScrollView(\n'
                            '    child: Column(\n'
                            '      children: [\n'
                            '        Text(\'Terms & Conditions\'),\n'
                            '        SizedBox(height: 16),\n'
                            '        Text(longLegalText),\n'
                            '      ],\n'
                            '    ),\n'
                            '  ),\n'
                            ')',
                        tint: Colors.purple,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Composed Example ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'Composed Example',
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'A common production arrangement looks like this: one sliver header, one padded list section, then a fill-the-rest footer.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'CustomScrollView(\n'
                            '  slivers: [\n'
                            '    SliverToBoxAdapter(child: HeaderCard()),\n'
                            '    SliverPadding(\n'
                            '      padding: EdgeInsets.all(24),\n'
                            '      sliver: SliverList(delegate: ...),\n'
                            '    ),\n'
                            '    SliverFillRemaining(\n'
                            '      hasScrollBody: false,\n'
                            '      child: FooterPanel(),\n'
                            '    ),\n'
                            '  ],\n'
                            ')',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _SectionCard(
                  title: 'Advanced Composed Example',
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'A richer arrangement with a pinned app bar, a search field, a padded grid, a separated list, and a fill-remaining footer.',
                      ),
                      SizedBox(height: 16),
                      _CodeBlock(
                        code:
                            'CustomScrollView(\n'
                            '  slivers: [\n'
                            '    SliverAppBar(\n'
                            '      pinned: true,\n'
                            '      title: Text(\'Shop\'),\n'
                            '    ),\n'
                            '    SliverToBoxAdapter(\n'
                            '      child: SearchBar(),\n'
                            '    ),\n'
                            '    SliverPadding(\n'
                            '      padding: EdgeInsets.all(16),\n'
                            '      sliver: SliverGrid(\n'
                            '        gridDelegate:\n'
                            '            SliverGridDelegateWith\n'
                            '                FixedCrossAxisCount(\n'
                            '          crossAxisCount: 2,\n'
                            '        ),\n'
                            '        delegate:\n'
                            '            SliverChildBuilderDelegate(\n'
                            '          (ctx, i) => ProductCard(i),\n'
                            '          childCount: products.length,\n'
                            '        ),\n'
                            '      ),\n'
                            '    ),\n'
                            '    SliverPadding(\n'
                            '      padding: EdgeInsets.symmetric(\n'
                            '        horizontal: 16,\n'
                            '      ),\n'
                            '      sliver: SliverList.separated(\n'
                            '        itemCount: reviews.length,\n'
                            '        itemBuilder: (ctx, i) =>\n'
                            '            ReviewTile(reviews[i]),\n'
                            '        separatorBuilder: (_, __) =>\n'
                            '            Divider(),\n'
                            '      ),\n'
                            '    ),\n'
                            '    SliverFillRemaining(\n'
                            '      hasScrollBody: false,\n'
                            '      child: FooterLinks(),\n'
                            '    ),\n'
                            '  ],\n'
                            ')',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _FooterFillCard(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: <Color>[
            Colors.indigo.withValues(alpha: 0.18),
            Colors.cyan.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'SliverToBoxAdapter, SliverList, SliverPadding, SliverFillRemaining',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Text(
            'The goal is not just to name each widget, but to show how these slivers compose into a real scrollable screen with headers, repeated rows, padded sections, and a footer that fills leftover space.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: SliverExamplesPage._featureRows
                .map((_FeatureRowData item) => _PillTag(data: item))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SliverMapPreview extends StatelessWidget {
  const _SliverMapPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _MapRow(label: 'Intro banner', sliver: 'SliverToBoxAdapter'),
          SizedBox(height: 10),
          _MapRow(label: 'Repeated lesson cards', sliver: 'SliverList'),
          SizedBox(height: 10),
          _MapRow(label: 'Section spacing', sliver: 'SliverPadding'),
          SizedBox(height: 10),
          _MapRow(label: 'Bottom fill panel', sliver: 'SliverFillRemaining'),
        ],
      ),
    );
  }
}

class _MapRow extends StatelessWidget {
  const _MapRow({required this.label, required this.sliver});

  final String label;
  final String sliver;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(label)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: Colors.black.withValues(alpha: 0.06),
          ),
          child: Text(sliver),
        ),
      ],
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.index, required this.lesson});

  final int index;
  final _LessonData lesson;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: lesson.color.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: lesson.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lesson.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(lesson.summary),
            const SizedBox(height: 16),
            _CodeBlock(code: lesson.code, tint: lesson.color),
          ],
        ),
      ),
    );
  }
}

class _SubsectionCard extends StatelessWidget {
  const _SubsectionCard({
    required this.title,
    required this.description,
    required this.code,
  });

  final String title;
  final String description;
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
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            _CodeBlock(code: code),
          ],
        ),
      ),
    );
  }
}

class _FeedPreviewRow extends StatelessWidget {
  const _FeedPreviewRow({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.view_stream, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class _PaddingPreview extends StatelessWidget {
  const _PaddingPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Think of it as margin for an entire sliver section:'),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Outer page inset comes from SliverPadding'),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Each row stays simple because the sliver owns the inset',
            ),
          ),
        ],
      ),
    );
  }
}

class _FillRemainingPreview extends StatelessWidget {
  const _FillRemainingPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.purple.withValues(alpha: 0.10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Common uses:'),
          SizedBox(height: 10),
          Text('• Empty state after filters'),
          Text('• Final purchase or confirmation panel'),
          Text('• Summary area pinned to the viewport bottom'),
        ],
      ),
    );
  }
}

class _FooterFillCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: <Color>[
            Colors.indigo.withValues(alpha: 0.16),
            Colors.purple.withValues(alpha: 0.10),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.vertical_align_bottom_outlined,
                size: 44,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'This footer is rendered by SliverFillRemaining',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              const Text(
                'If the earlier slivers do not consume the full viewport height, this panel expands to occupy the remaining space instead of leaving empty scroll area.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.code),
                label: const Text('Inspect Sliver Pattern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
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
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code, this.tint});

  final String code;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final Color background =
        (tint ?? Theme.of(context).colorScheme.surfaceContainerHighest)
            .withValues(alpha: tint == null ? 0.45 : 0.10);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: tint == null
            ? null
            : Border.all(color: tint!.withValues(alpha: 0.18)),
      ),
      child: Text(
        code,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace', height: 1.5),
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
        child: child,
      ),
    );
  }
}

class _PillTag extends StatelessWidget {
  const _PillTag({required this.data});

  final _FeatureRowData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${data.label} • ${data.sliver}',
        style: TextStyle(color: data.color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── New preview widgets for additional examples ──

class _StatsRowPreview extends StatelessWidget {
  const _StatsRowPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const <Widget>[
          _StatTile(label: 'Users', value: '1.2k', icon: Icons.people),
          _StatTile(label: 'Posts', value: '847', icon: Icons.article),
          _StatTile(label: 'Likes', value: '5.3k', icon: Icons.favorite),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: Colors.blue, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _SearchBarPreview extends StatelessWidget {
  const _SearchBarPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.search, color: Colors.blue.withValues(alpha: 0.6)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search products, categories…',
              style: TextStyle(
                color: Colors.blue.withValues(alpha: 0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Icon(Icons.tune, color: Colors.blue.withValues(alpha: 0.4)),
        ],
      ),
    );
  }
}

class _ImageBannerPreview extends StatelessWidget {
  const _ImageBannerPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: <Color>[
            Colors.blue.withValues(alpha: 0.25),
            Colors.cyan.withValues(alpha: 0.15),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.image_outlined,
              size: 40,
              color: Colors.blue.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 8),
            Text(
              'Image / Promo Banner Placeholder',
              style: TextStyle(
                color: Colors.blue.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MixedContentPreview extends StatelessWidget {
  const _MixedContentPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.dark_mode, color: Colors.green, size: 20),
              const SizedBox(width: 12),
              const Expanded(child: Text('Dark Mode')),
              Container(
                width: 42,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(2),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: const <Widget>[
              Icon(Icons.language, color: Colors.green, size: 20),
              SizedBox(width: 12),
              Expanded(child: Text('Language')),
              Text('English', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: const <Widget>[
              Icon(Icons.info_outline, color: Colors.green, size: 20),
              SizedBox(width: 12),
              Expanded(child: Text('About')),
              Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class _NestedPaddingPreview extends StatelessWidget {
  const _NestedPaddingPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: const Text(
              'Outer SliverPadding → horizontal: 24',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Inner SliverPadding → vertical: 12',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List<Widget>.generate(3, (int i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('List item $i'),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _EmptyStatePreview extends StatelessWidget {
  const _EmptyStatePreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.search_off,
            size: 48,
            color: Colors.purple.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try adjusting your search or filter criteria',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Clear filters',
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonData {
  const _LessonData({
    required this.title,
    required this.summary,
    required this.color,
    required this.code,
  });

  final String title;
  final String summary;
  final Color color;
  final String code;
}

class _FeatureRowData {
  const _FeatureRowData({
    required this.label,
    required this.sliver,
    required this.color,
  });

  final String label;
  final String sliver;
  final Color color;
}
