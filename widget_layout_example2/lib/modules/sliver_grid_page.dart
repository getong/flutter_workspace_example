import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'SliverGridRoute')
class SliverGridPage extends StatelessWidget {
  const SliverGridPage({super.key});

  static const List<({String label, String value, Color color, IconData icon})>
  _dashboardStats =
      <({String label, String value, Color color, IconData icon})>[
        (
          label: 'Users',
          value: '12.4k',
          color: Colors.blue,
          icon: Icons.groups,
        ),
        (
          label: 'Revenue',
          value: '\$84k',
          color: Colors.teal,
          icon: Icons.payments,
        ),
        (
          label: 'Tickets',
          value: '241',
          color: Colors.orange,
          icon: Icons.support_agent,
        ),
        (
          label: 'Deploys',
          value: '18',
          color: Colors.deepPurple,
          icon: Icons.rocket_launch,
        ),
        (
          label: 'Latency',
          value: '124ms',
          color: Colors.indigo,
          icon: Icons.speed,
        ),
        (
          label: 'Errors',
          value: '0.2%',
          color: Colors.red,
          icon: Icons.error_outline,
        ),
      ];

  static const List<
    ({String title, String subtitle, Color color, IconData icon})
  >
  _galleryItems =
      <({String title, String subtitle, Color color, IconData icon})>[
        (
          title: 'Brand Kit',
          subtitle: 'Assets',
          color: Colors.pink,
          icon: Icons.palette,
        ),
        (
          title: 'Analytics',
          subtitle: 'Reports',
          color: Colors.cyan,
          icon: Icons.analytics,
        ),
        (
          title: 'Shipping',
          subtitle: 'Orders',
          color: Colors.lightGreen,
          icon: Icons.local_shipping,
        ),
        (
          title: 'Audio',
          subtitle: 'Media',
          color: Colors.deepOrange,
          icon: Icons.headphones,
        ),
        (
          title: 'Security',
          subtitle: 'Policy',
          color: Colors.indigo,
          icon: Icons.shield,
        ),
        (
          title: 'AI Tools',
          subtitle: 'Automation',
          color: Colors.purple,
          icon: Icons.auto_awesome,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SliverGrid Module')),
      body: SelectionArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _SectionCard(
                  title: 'What SliverGrid Does',
                  child: const Text(
                    'SliverGrid lays out children in a two-dimensional arrangement inside CustomScrollView. It is useful for dashboards, galleries, metrics, shortcuts, and catalog-style surfaces.',
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Text(
                  'Fixed Cross Axis Count',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  final item = _dashboardStats[index];
                  return _StatGridCard(
                    label: item.label,
                    value: item.value,
                    color: item.color,
                    icon: item.icon,
                  );
                }, childCount: _dashboardStats.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Text(
                  'Max Cross Axis Extent',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  final item = _galleryItems[index];
                  return _GalleryCard(
                    title: item.title,
                    subtitle: item.subtitle,
                    color: item.color,
                    icon: item.icon,
                  );
                }, childCount: _galleryItems.length),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
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

class _StatGridCard extends StatelessWidget {
  const _StatGridCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

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
          Icon(icon, color: color),
          const Spacer(),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({
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
        gradient: LinearGradient(
          colors: <Color>[
            color.withValues(alpha: 0.18),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.18),
            child: Icon(icon, color: color),
          ),
          const Spacer(),
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
