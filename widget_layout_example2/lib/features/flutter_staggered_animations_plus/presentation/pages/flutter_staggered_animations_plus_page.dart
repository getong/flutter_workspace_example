import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations_plus/flutter_staggered_animations_plus.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.flutterStaggeredAnimationsPlus)
class FlutterStaggeredAnimationsPlusPage extends StatefulWidget {
  const FlutterStaggeredAnimationsPlusPage({super.key});

  @override
  State<FlutterStaggeredAnimationsPlusPage> createState() =>
      _FlutterStaggeredAnimationsPlusPageState();
}

class _FlutterStaggeredAnimationsPlusPageState
    extends State<FlutterStaggeredAnimationsPlusPage> {
  int _refreshSeed = 0;

  static const List<_AnimationDemoItem> _listItems = <_AnimationDemoItem>[
    _AnimationDemoItem(
      title: 'Inbox Sync',
      subtitle: 'Slide each row in with a progressive delay.',
      color: Color(0xFF2563EB),
      icon: Icons.inbox_outlined,
    ),
    _AnimationDemoItem(
      title: 'Weekly Review',
      subtitle: 'Fade and movement make sequence easier to parse.',
      color: Color(0xFF0F766E),
      icon: Icons.analytics_outlined,
    ),
    _AnimationDemoItem(
      title: 'Build Queue',
      subtitle: 'Staggering reduces the feeling of abrupt content pop-in.',
      color: Color(0xFF7C3AED),
      icon: Icons.developer_board_outlined,
    ),
    _AnimationDemoItem(
      title: 'Deploy Status',
      subtitle: 'Useful for dashboards, feeds, and cards loaded together.',
      color: Color(0xFFEA580C),
      icon: Icons.cloud_done_outlined,
    ),
  ];

  static const List<_AnimationDemoItem> _gridItems = <_AnimationDemoItem>[
    _AnimationDemoItem(
      title: 'Metrics',
      subtitle: 'Scale + fade grid card',
      color: Color(0xFFBE123C),
      icon: Icons.bar_chart_outlined,
    ),
    _AnimationDemoItem(
      title: 'Revenue',
      subtitle: 'Dual-axis stagger in a grid',
      color: Color(0xFF0891B2),
      icon: Icons.payments_outlined,
    ),
    _AnimationDemoItem(
      title: 'Retention',
      subtitle: 'Useful for dashboard overviews',
      color: Color(0xFF65A30D),
      icon: Icons.favorite_border,
    ),
    _AnimationDemoItem(
      title: 'Traffic',
      subtitle: 'Each card enters in sequence',
      color: Color(0xFFB45309),
      icon: Icons.traffic_outlined,
    ),
    _AnimationDemoItem(
      title: 'Latency',
      subtitle: 'Adds rhythm without custom controllers',
      color: Color(0xFF4338CA),
      icon: Icons.speed_outlined,
    ),
    _AnimationDemoItem(
      title: 'Alerts',
      subtitle: 'Good for alert centers and menus',
      color: Color(0xFFC2410C),
      icon: Icons.notifications_active_outlined,
    ),
  ];

  void _replayAnimations() {
    setState(() {
      _refreshSeed += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_staggered_animations_plus Module'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Replay animations',
            onPressed: _replayAnimations,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SelectionArea(
        child: ListView(
          key: ValueKey<int>(_refreshSeed),
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'flutter_staggered_animations_plus makes list and grid items enter in sequence with minimal setup.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Its job is presentation rhythm: items do not all appear at once, but cascade in with staggered delays. This improves perceived polish and helps users scan newly loaded content.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _SectionCard(
              title: 'What this package is for',
              description:
                  'It wraps `ListView`, `GridView`, `Column`, or `Row` children with ready-made staggered animations like fade, slide, and scale.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  _TagChip(label: 'AnimationLimiter'),
                  _TagChip(label: 'AnimationConfiguration'),
                  _TagChip(label: 'Fade'),
                  _TagChip(label: 'Slide'),
                  _TagChip(label: 'Scale'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '1. Staggered List',
              description:
                  'Each row animates from top to bottom using `AnimationConfiguration.staggeredList`.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AnimationLimiter(
                    child: Column(
                      children: List<Widget>.generate(_listItems.length, (
                        int index,
                      ) {
                        final _AnimationDemoItem item = _listItems[index];

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 450),
                          child: SlideAnimation(
                            verticalOffset: 32,
                            child: FadeInAnimation(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _ListTileCard(item: item),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _CodeBlock(
                    code:
                        'AnimationConfiguration.staggeredList(\n'
                        '  position: index,\n'
                        '  child: SlideAnimation(\n'
                        '    verticalOffset: 32,\n'
                        '    child: FadeInAnimation(child: YourRow()),\n'
                        '  ),\n'
                        ')',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '2. Staggered Grid',
              description:
                  'Grid items can cascade diagonally using `AnimationConfiguration.staggeredGrid` with a column count.',
              child: SizedBox(
                height: 420,
                child: AnimationLimiter(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.15,
                        ),
                    itemCount: _gridItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final _AnimationDemoItem item = _gridItems[index];

                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: 2,
                        duration: const Duration(milliseconds: 500),
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: _GridStatCard(item: item),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '3. Convert existing children',
              description:
                  'For a `Column` or `Row`, `AnimationConfiguration.toStaggeredList` helps apply the same pattern without manually wrapping each widget.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 380),
                  childAnimationBuilder: (Widget widget) => SlideAnimation(
                    horizontalOffset: 24,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: const <Widget>[
                    _BulletLine(
                      text:
                          'Use `AnimationLimiter` as the direct parent of a scrollable list.',
                    ),
                    _BulletLine(
                      text:
                          'Use `staggeredList` for one-dimensional sequences like feeds and menus.',
                    ),
                    _BulletLine(
                      text:
                          'Use `staggeredGrid` for dashboard cards, catalogs, and icon grids.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _SectionCard(
              title: 'When to choose it',
              description:
                  'Use it when content appears in batches and you want a quick way to add motion without writing your own `AnimationController` orchestration.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Good fit: feed items, dashboards, menus, onboarding steps, quick action grids.',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Less necessary: isolated one-off animations where a single implicit animation is enough.',
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

class _AnimationDemoItem {
  const _AnimationDemoItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color color;
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

class _ListTileCard extends StatelessWidget {
  const _ListTileCard({required this.item});

  final _AnimationDemoItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.color.withValues(alpha: 0.22)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(item.subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridStatCard extends StatelessWidget {
  const _GridStatCard({required this.item});

  final _AnimationDemoItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[item.color, item.color.withValues(alpha: 0.72)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(item.icon, color: Colors.white, size: 28),
          const Spacer(),
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
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
