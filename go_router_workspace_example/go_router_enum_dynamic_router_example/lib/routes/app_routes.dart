import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/user_details_page.dart';

enum AppRoute { home, userDetails }

extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.home:
        return '/';
      case AppRoute.userDetails:
        return '/user/:id';
    }
  }

  Widget Function(BuildContext, GoRouterState) get builder {
    switch (this) {
      case AppRoute.home:
        return (context, state) => HomePage();
      case AppRoute.userDetails:
        return (context, state) {
          final userId = state.pathParameters['id']!;
          return UserDetailsPage(userId: userId);
        };
    }
  }

  String routeWithParams({required Map<String, String> params}) {
    var path = this.path;
    params.forEach((key, value) {
      path = path.replaceAll(':$key', value);
    });
    return path;
  }
}

final router = GoRouter(
  routes: AppRoute.values
      .map((route) => GoRoute(path: route.path, builder: route.builder))
      .toList(),
);
