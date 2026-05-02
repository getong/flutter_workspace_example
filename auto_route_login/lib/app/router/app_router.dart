import 'package:auto_route/auto_route.dart';
import 'package:auto_route_login/features/auth/presentation/pages/login_page.dart';
import 'package:auto_route_login/features/auth/presentation/pages/signup_page.dart';
import 'package:auto_route_login/features/auth/domain/entities/user.dart';
import 'package:auto_route_login/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(page: LoginRoute.page, path: '/', initial: true),
        AutoRoute(page: SignupRoute.page, path: '/signup'),
        AutoRoute(page: HomeRoute.page, path: '/home'),
      ];
}
