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

  String routeWithParams({required Map<String, String> params}) {
    var path = this.path;
    params.forEach((key, value) {
      path = path.replaceAll(':$key', value);
    });
    return path;
  }
}

final router = GoRouter(
  routes: [
    GoRoute(path: AppRoute.home.path, builder: (context, state) => HomePage()),
    GoRoute(
      path: AppRoute.userDetails.path,
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return UserDetailsPage(userId: userId);
      },
    ),
  ],
);
