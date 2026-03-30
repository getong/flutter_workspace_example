import 'package:flutter/material.dart';

import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  static const List<_NavDestination> _destinations = <_NavDestination>[
    _NavDestination(
      path: '/overview',
      title: 'Forui Router Demo',
      label: 'Overview',
      icon: FIcons.house,
    ),
    _NavDestination(
      path: '/catalog',
      title: 'Component Catalog',
      label: 'Catalog',
      icon: FIcons.layoutGrid,
    ),
    _NavDestination(
      path: '/profile',
      title: 'Workspace Settings',
      label: 'Profile',
      icon: FIcons.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final int index = _indexForLocation(location);
    final _NavDestination destination = _destinations[index];

    return FScaffold(
      header: FHeader(
        title: Text(destination.title),
        suffixes: <Widget>[
          FHeaderAction(
            icon: const Icon(FIcons.house),
            onPress: index == 0 ? null : () => context.go('/overview'),
          ),
          FHeaderAction(
            icon: const Icon(FIcons.layoutGrid),
            onPress: index == 1 ? null : () => context.go('/catalog'),
          ),
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: index == 2 ? null : () => context.go('/profile'),
          ),
        ],
      ),
      footer: FBottomNavigationBar(
        index: index,
        onChange: (int nextIndex) => context.go(_destinations[nextIndex].path),
        children: const <Widget>[
          FBottomNavigationBarItem(
            icon: Icon(FIcons.house),
            label: Text('Overview'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.layoutGrid),
            label: Text('Catalog'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.settings),
            label: Text('Profile'),
          ),
        ],
      ),
      child: child,
    );
  }

  int _indexForLocation(String currentLocation) {
    if (currentLocation.startsWith('/catalog')) {
      return 1;
    }
    if (currentLocation.startsWith('/profile')) {
      return 2;
    }
    return 0;
  }
}

class _NavDestination {
  const _NavDestination({
    required this.path,
    required this.title,
    required this.label,
    required this.icon,
  });

  final String path;
  final String title;
  final String label;
  final IconData icon;
}
