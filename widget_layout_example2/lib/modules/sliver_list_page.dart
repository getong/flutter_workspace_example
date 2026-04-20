import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SliverListPage extends StatelessWidget {
  const SliverListPage({super.key});

  static const List<
    ({String title, String subtitle, Color color, IconData icon})
  >
  _roadmapItems =
      <({String title, String subtitle, Color color, IconData icon})>[
        (
          title: 'Research the widget',
          subtitle: 'Review existing patterns before implementation starts.',
          color: Colors.blue,
          icon: Icons.search,
        ),
        (
          title: 'Implement examples',
          subtitle: 'Write focused demos with state where it adds value.',
          color: Colors.teal,
          icon: Icons.code,
        ),
        (
          title: 'Add routing',
          subtitle: 'Register the page and expose it from the home tab.',
          color: Colors.orange,
          icon: Icons.route,
        ),
        (
          title: 'Verify behavior',
          subtitle: 'Run generated code and analyzer checks afterward.',
          color: Colors.deepPurple,
          icon: Icons.verified,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SliverList Module')),
      body: SelectionArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _SectionCard(
                  title: 'What SliverList Does',
                  child: const Text(
                    'SliverList lays out a linear sequence of children inside a CustomScrollView. It is the sliver-native alternative to nesting a ListView inside another scrollable.',
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Text(
                  'Builder Delegate Example',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  final item = _roadmapItems[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == _roadmapItems.length - 1 ? 0 : 12,
                    ),
                    child: _RoadmapTile(
                      title: item.title,
                      subtitle: item.subtitle,
                      color: item.color,
                      icon: item.icon,
                    ),
                  );
                }, childCount: _roadmapItems.length),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Text(
                  'Static Children Example',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList.list(
                children: const <Widget>[
                  _HighlightCard(
                    title: 'Why use SliverList?',
                    body:
                        'It keeps all repeated rows inside the same sliver scroll surface, so scroll physics, app bars, and other slivers cooperate naturally.',
                    color: Colors.green,
                  ),
                  SizedBox(height: 12),
                  _HighlightCard(
                    title: 'Common production usage',
                    body:
                        'Feed screens, settings pages, dashboards, inboxes, activity timelines, and any long vertical section that belongs under a CustomScrollView.',
                    color: Colors.indigo,
                  ),
                  SizedBox(height: 12),
                  _HighlightCard(
                    title: 'Typical delegate choice',
                    body:
                        'Use SliverChildBuilderDelegate for data-driven rows and SliverList.list when you already have a short fixed set of widgets.',
                    color: Colors.deepOrange,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Text(
                  'Mixed Content Example',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              sliver: SliverList.list(
                children: const <Widget>[
                  _PreviewPanel(
                    color: Colors.blue,
                    title: 'Header row',
                    subtitle: 'One list can contain different row shapes.',
                  ),
                  SizedBox(height: 12),
                  _PreviewPanel(
                    color: Colors.teal,
                    title: 'Status card',
                    subtitle:
                        'Cards, banners, and form fields can all live in the same SliverList.',
                  ),
                  SizedBox(height: 12),
                  _PreviewPanel(
                    color: Colors.purple,
                    title: 'Final row',
                    subtitle:
                        'That flexibility makes SliverList a strong default for vertical sliver content.',
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

class _RoadmapTile extends StatelessWidget {
  const _RoadmapTile({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.title,
    required this.body,
    required this.color,
  });

  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(body),
        ],
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            color.withValues(alpha: 0.18),
            color.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(subtitle),
        ],
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
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
