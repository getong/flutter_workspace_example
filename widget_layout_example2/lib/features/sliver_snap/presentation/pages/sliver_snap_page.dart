import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sliver_snap/sliver_snap.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.sliverSnap)
class SliverSnapPage extends StatefulWidget {
  const SliverSnapPage({super.key});

  @override
  State<SliverSnapPage> createState() => _SliverSnapPageState();
}

class _SliverSnapPageState extends State<SliverSnapPage> {
  bool _pinned = true;
  bool _floating = true;
  bool _snap = true;
  bool _stretch = false;
  bool _isCollapsed = false;
  double _scrollFraction = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SliverSnap(
        pinned: _pinned,
        floating: _floating,
        snap: _floating && _snap,
        stretch: _stretch,
        expandedContentHeight: 320,
        collapsedBarHeight: 72,
        collapsedBackgroundColor: theme.colorScheme.surface,
        expandedBackgroundColor: Colors.transparent,
        forceElevated: _isCollapsed,
        elevation: 2,
        actions: <Widget>[
          IconButton(
            tooltip: 'Reset demo',
            onPressed: () {
              setState(() {
                _pinned = true;
                _floating = true;
                _snap = true;
                _stretch = false;
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Show tips',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Toggle pinned, floating, snap, and stretch. Then scroll to compare the behavior.',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _MetricChip(
                  label: _isCollapsed ? 'State: collapsed' : 'State: expanded',
                ),
                _MetricChip(
                  label: 'Progress: ${(_scrollFraction * 100).round()}%',
                ),
                _MetricChip(
                  label: 'Snap: ${_floating && _snap ? 'active' : 'off'}',
                ),
              ],
            ),
          ),
        ),
        backdropWidget: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                theme.colorScheme.primaryContainer,
                theme.colorScheme.secondaryContainer,
                theme.colorScheme.surface,
              ],
            ),
          ),
        ),
        expandedContent: ExpandedContent(
          leading: IconButton(
            onPressed: () => context.router.maybePop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'sliver_snap package demo',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'SliverSnap Module',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'This package wraps a snapping SliverAppBar pattern with dedicated expanded and collapsed content, plus callbacks for collapse state changes.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const <Widget>[
                      _HeroBadge(
                        icon: Icons.layers_outlined,
                        label: 'Expanded + collapsed content',
                      ),
                      _HeroBadge(
                        icon: Icons.swipe_vertical_outlined,
                        label: 'Snapping scroll behavior',
                      ),
                      _HeroBadge(
                        icon: Icons.monitor_heart_outlined,
                        label: 'State callback feedback',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        collapsedContent: CollapsedAppBarContent(
          title: Text(
            'SliverSnap Module',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              _isCollapsed ? 'Collapsed' : 'Expanded',
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        onCollapseStateChanged:
            (bool isCollapsed, double scrollingOffset, double maxExtent) {
              final double nextFraction = maxExtent == 0
                  ? 0
                  : (scrollingOffset / maxExtent).clamp(0.0, 1.0);
              if (nextFraction == _scrollFraction &&
                  isCollapsed == _isCollapsed) {
                return;
              }
              setState(() {
                _isCollapsed = isCollapsed;
                _scrollFraction = nextFraction;
              });
            },
        body: Material(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SectionCard(
                  title: 'Why Use SliverSnap',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Use it when your page needs a more opinionated, content-rich sliver header than a plain SliverAppBar. The package gives you separate expanded and collapsed widgets, built-in snapping behavior, and a collapse callback.',
                      ),
                      SizedBox(height: 12),
                      Text(
                        'This demo also uses backdropWidget, bottom, actions, expandedContentHeight, collapsedBarHeight, forceElevated, and onCollapseStateChanged to cover more of the package surface.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Behavior Controls',
                  child: Column(
                    children: <Widget>[
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Pinned'),
                        subtitle: const Text(
                          'Keep the collapsed toolbar visible at the top while body content scrolls underneath.',
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
                        title: const Text('Floating'),
                        subtitle: const Text(
                          'Allow the toolbar to reappear as soon as scrolling reverses upward.',
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
                        title: const Text('Snap'),
                        subtitle: const Text(
                          'When floating is enabled, jump the app bar fully into or out of view.',
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
                        title: const Text('Stretch'),
                        subtitle: const Text(
                          'Forward overscroll stretch behavior to the internal SliverAppBar.',
                        ),
                        value: _stretch,
                        onChanged: (bool value) {
                          setState(() {
                            _stretch = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Status Summary',
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      _MetricChip(label: 'Pinned: ${_pinned ? 'yes' : 'no'}'),
                      _MetricChip(
                        label: 'Floating: ${_floating ? 'yes' : 'no'}',
                      ),
                      _MetricChip(label: 'Stretch: ${_stretch ? 'yes' : 'no'}'),
                      _MetricChip(
                        label: 'Collapsed: ${_isCollapsed ? 'yes' : 'no'}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'AppBar Code Examples',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'These snippets focus on app-bar composition, because `sliver_snap` is mainly about building richer app-bar behavior around expanded and collapsed states.',
                      ),
                      SizedBox(height: 12),
                      _CodeSnippet(
                        code:
                            'SliverSnap(\n'
                            '  pinned: true,\n'
                            '  floating: true,\n'
                            '  snap: true,\n'
                            '  expandedContentHeight: 280,\n'
                            '  expandedContent: ExpandedContent(\n'
                            '    leading: BackButton(color: Colors.white),\n'
                            '    child: YourExpandedHeader(),\n'
                            '  ),\n'
                            '  collapsedContent: CollapsedAppBarContent(\n'
                            '    title: Text(\'Library\'),\n'
                            '    trailing: Icon(Icons.search),\n'
                            '  ),\n'
                            '  body: YourScrollBody(),\n'
                            ')',
                      ),
                      SizedBox(height: 12),
                      _CodeSnippet(
                        code:
                            'SliverSnap(\n'
                            '  actions: <Widget>[\n'
                            '    IconButton(\n'
                            '      icon: const Icon(Icons.share),\n'
                            '      onPressed: shareArticle,\n'
                            '    ),\n'
                            '    IconButton(\n'
                            '      icon: const Icon(Icons.bookmark_border),\n'
                            '      onPressed: saveArticle,\n'
                            '    ),\n'
                            '  ],\n'
                            '  bottom: PreferredSize(\n'
                            '    preferredSize: const Size.fromHeight(44),\n'
                            '    child: CategoryTabs(),\n'
                            '  ),\n'
                            '  body: ArticleList(),\n'
                            ')',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...List<Widget>.generate(6, (int index) {
                  final Color color = <Color>[
                    Colors.indigo,
                    Colors.teal,
                    Colors.orange,
                    Colors.deepPurple,
                    Colors.blue,
                    Colors.red,
                  ][index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == 5 ? 0 : 16),
                    child: _FeedCard(
                      title: 'Scroll section ${index + 1}',
                      subtitle:
                          'Keep scrolling after changing the switches above. This long body is here so you can feel how the header collapses, floats back in, and snaps.',
                      color: color,
                    ),
                  );
                }),
              ],
            ),
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

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.18),
              child: Icon(Icons.auto_awesome_motion, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(subtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeSnippet extends StatelessWidget {
  const _CodeSnippet({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        code,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace', height: 1.45),
      ),
    );
  }
}
