import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

import '../models.dart';
import '../screens/chat_detail_screen.dart';
import '../screens/home_shell.dart';
import '../screens/login_screen.dart';
import '../screens/sign_up_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, initial: true),
    CustomRoute(
      page: SignUpRoute.page,
      duration: const Duration(milliseconds: 260),
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
    AutoRoute(page: HomeShellRoute.page),
    CustomRoute(
      page: ChatDetailRoute.page,
      duration: const Duration(milliseconds: 280),
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
  ];
}
