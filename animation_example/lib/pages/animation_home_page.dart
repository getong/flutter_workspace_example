import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/go_back_icon_button.dart';

class AnimationHomePage extends StatelessWidget {
  const AnimationHomePage({super.key});

  static const List<_DemoRouteSpec> _demoRoutes = <_DemoRouteSpec>[
    _DemoRouteSpec(
      path: '/ticker-provider',
      title: 'TickerProvider + AnimationController',
      subtitle: 'SingleTickerProviderStateMixin and controller lifecycle.',
      icon: Icons.motion_photos_on,
    ),
    _DemoRouteSpec(
      path: '/raw-ticker',
      title: 'Raw Ticker',
      subtitle: 'Use Ticker directly for frame-level callbacks.',
      icon: Icons.timer,
    ),
    _DemoRouteSpec(
      path: '/curved-animation',
      title: 'CurvedAnimation',
      subtitle: 'Apply easing curve and reverseCurve to motion.',
      icon: Icons.show_chart,
    ),
    _DemoRouteSpec(
      path: '/tween',
      title: 'Tween + TweenSequence',
      subtitle: 'Map controller value to style and layout values.',
      icon: Icons.tune,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const GoBackIconButton(),
        title: const Text('Flutter Animation Router Demos'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _demoRoutes.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (BuildContext context, int index) {
          final _DemoRouteSpec route = _demoRoutes[index];
          return Card(
            child: ListTile(
              leading: Icon(route.icon),
              title: Text(route.title),
              subtitle: Text(route.subtitle),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.go(route.path),
            ),
          );
        },
      ),
    );
  }
}

class _DemoRouteSpec {
  const _DemoRouteSpec({
    required this.path,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String path;
  final String title;
  final String subtitle;
  final IconData icon;
}
