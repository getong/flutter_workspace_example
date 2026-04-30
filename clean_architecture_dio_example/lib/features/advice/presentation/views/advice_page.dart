import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_router.dart';
import '../../../../core/di/di.dart';
import '../../domain/repositories/advice_repository.dart';
import '../bloc/advice_bloc.dart';

@RoutePage(name: 'AdviceRouteShellRoute')
class AdvicePage extends StatelessWidget {
  const AdvicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AdviceRepository>.value(
      value: getIt<AdviceRepository>(),
      child: BlocProvider(
        create: (_) => getIt<AdviceBloc>()..add(const FetchAdviceEvent()),
        child: AutoTabsScaffold(
          routes: const [AdviceFetchTabRoute(), AdviceHistoryTabRoute()],
          navigatorObservers: () => [AutoRouteObserver()],
          appBarBuilder: (context, tabsRouter) {
            final titles = ['Advice Generator', 'Fetched Advice'];
            return AppBar(title: Text(titles[tabsRouter.activeIndex]));
          },
          bottomNavigationBuilder: (context, tabsRouter) {
            return NavigationBar(
              selectedIndex: tabsRouter.activeIndex,
              onDestinationSelected: tabsRouter.setActiveIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.tips_and_updates_outlined),
                  label: 'Fetch',
                ),
                NavigationDestination(
                  icon: Icon(Icons.list_alt_outlined),
                  label: 'History',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
