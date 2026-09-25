import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/state/travel_scope.dart';
import 'package:mai_ui_demo/core/theme/app_colors.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});
  @override
  Widget build(BuildContext context) => AutoTabsRouter(
    routes: const [
      NamedRoute('HomeRoute'),
      NamedRoute('TripsRoute'),
      NamedRoute('SavedRoute'),
      NamedRoute('ProfileRoute'),
    ],
    builder: (context, child) {
      final tabs = AutoTabsRouter.of(context);
      final store = TravelScope.of(context);
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                children: [
                  if (store.saveError case final String error)
                    MaterialBanner(
                      content: Text(error),
                      actions: [
                        TextButton(
                          onPressed: store.dismissError,
                          child: const Text('知道了'),
                        ),
                      ],
                    ),
                  Expanded(child: child),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: line)),
                    ),
                    child: NavigationBar(
                      selectedIndex: tabs.activeIndex,
                      onDestinationSelected: tabs.setActiveIndex,
                      backgroundColor: paper,
                      indicatorColor: paleGreen,
                      elevation: 0,
                      height: 76,
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home_rounded, color: forest),
                          label: '首页',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.map_outlined),
                          selectedIcon: Icon(Icons.map, color: forest),
                          label: '行程',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.favorite_border),
                          selectedIcon: Icon(Icons.favorite, color: orange),
                          label: '收藏',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.person_outline),
                          selectedIcon: Icon(Icons.person, color: forest),
                          label: '我的',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
