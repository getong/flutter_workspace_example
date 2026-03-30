import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../story_catalog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<_DemoRoute> _demoRoutes = <_DemoRoute>[
    _DemoRoute(
      path: '/box-pad',
      title: 'Box + Pad',
      subtitle:
          'Const-friendly boxes, compact spacing, and conditional padding.',
      icon: Icons.crop_square_outlined,
      color: Color(0xFF0F766E),
    ),
    _DemoRoute(
      path: '/row-super',
      title: 'RowSuper',
      subtitle:
          'Overlap, separators, fill, and shrink behavior in horizontal layouts.',
      icon: Icons.view_week_outlined,
      color: Color(0xFF1D4ED8),
    ),
    _DemoRoute(
      path: '/column-super',
      title: 'ColumnSuper',
      subtitle: 'Vertical stacking with overlaps and separator-aware spacing.',
      icon: Icons.view_agenda_outlined,
      color: Color(0xFF7C3AED),
    ),
    _DemoRoute(
      path: '/wrap-super',
      title: 'WrapSuper',
      subtitle:
          'Balanced line breaks and width fitting for collections of chips.',
      icon: Icons.wrap_text,
      color: Color(0xFFEA580C),
    ),
    _DemoRoute(
      path: '/text-fitting',
      title: 'SideBySide + FitHorizontally',
      subtitle:
          'Tight-width title bars and single-line text that shrinks gracefully.',
      icon: Icons.fit_screen_outlined,
      color: Color(0xFFBE123C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assorted Layout Widgets')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFF2E8DC), Color(0xFFF7F2EA)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                children: <Widget>[
                  _HeroHeader(routeCount: _demoRoutes.length),
                  const SizedBox(height: 24),
                  Text(
                    'Core Widget Demos',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Static routes for each widget family, plus dynamic story pages below.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ..._demoRoutes.map(
                    (_DemoRoute route) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RouteCard(
                        icon: route.icon,
                        title: route.title,
                        subtitle: route.subtitle,
                        location: route.path,
                        color: route.color,
                        onTap: () => context.go(route.path),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Dynamic Story Routes',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'These pages are all served from `/stories/:slug` using the same route.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ...storySpecs.map(
                    (StorySpec story) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RouteCard(
                        icon: story.icon,
                        title: story.title,
                        subtitle: story.subtitle,
                        location: '/stories/${story.slug}',
                        color: story.color,
                        onTap: () => context.go('/stories/${story.slug}'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.routeCount});

  final int routeCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: const Color(0xFF102A43),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Multi-page `go_router` example',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'This app mirrors the page-based structure from the reference project, '
            'but focuses on `assorted_layout_widgets` with dedicated demos and '
            'dynamic route-driven case studies.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
          const SizedBox(height: 20),
          RowSuper(
            innerDistance: 12,
            mainAxisSize: MainAxisSize.max,
            fill: true,
            children: <Widget>[
              _StatBox(
                label: 'Pages',
                value: '${routeCount + storySpecs.length + 1}',
                color: const Color(0xFF0F766E),
              ),
              _StatBox(
                label: 'Package Widgets',
                value: '6',
                color: const Color(0xFFEA580C),
              ),
              _StatBox(
                label: 'Dynamic Route',
                value: '/stories/:slug',
                color: const Color(0xFF7C3AED),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Box(
            color: Colors.white.withValues(alpha: 0.08),
            padding: const Pad(all: 16),
            child: WrapSuper(
              spacing: 10,
              lineSpacing: 10,
              wrapType: WrapType.balanced,
              wrapFit: WrapFit.larger,
              children: <Widget>[
                _teaserChip('Box'),
                _teaserChip('Pad'),
                _teaserChip('RowSuper'),
                _teaserChip('ColumnSuper'),
                _teaserChip('WrapSuper'),
                _teaserChip('SideBySide'),
                _teaserChip('FitHorizontally'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _teaserChip(String label) {
    return Box(
      color: Colors.white,
      padding: const Pad(horizontal: 14, vertical: 10),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Box(
      color: color.withValues(alpha: 0.22),
      padding: const Pad(all: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String location;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SideBySide(
            minEndChildWidth: 56,
            gaps: const <double>[16, 12],
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: color),
              ),
              Box(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
                    const SizedBox(height: 8),
                    Text(
                      location,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward_ios_rounded, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoRoute {
  const _DemoRoute({
    required this.path,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String path;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}
