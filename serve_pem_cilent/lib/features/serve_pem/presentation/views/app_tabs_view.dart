import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/routing/app_router.dart';

@RoutePage()
class AppTabsView extends StatelessWidget {
  const AppTabsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [AdviceRoute(), HomeRoute()],
      bottomNavigationBuilder: (context, tabsRouter) {
        return NavigationBar(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: tabsRouter.setActiveIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.tips_and_updates_outlined),
              label: 'Advice',
            ),
            NavigationDestination(
              icon: Icon(Icons.lock_outline),
              label: 'Serve PEM',
            ),
          ],
        );
      },
    );
  }
}
