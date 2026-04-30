import 'package:auto_route/auto_route.dart';

import 'features/advice/presentation/views/advice_history_tab_page.dart';
import 'features/advice/presentation/views/advice_page.dart';
import 'features/advice/presentation/views/advice_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: AdviceRouteShellRoute.page,
      initial: true,
      children: [
        AutoRoute(path: 'fetch', page: AdviceFetchTabRoute.page, initial: true),
        AutoRoute(path: 'history', page: AdviceHistoryTabRoute.page),
      ],
    ),
  ];
}
