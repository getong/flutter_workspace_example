import 'package:flutter/widgets.dart';

import 'package:go_router/go_router.dart';

import 'catalog/demo_catalog.dart';
import 'pages/components_page.dart';
import 'pages/demo_detail_page.dart';
import 'pages/not_found_page.dart';
import 'pages/overview_page.dart';
import 'pages/profile_page.dart';
import 'widgets/app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/overview',
  routes: <RouteBase>[
    GoRoute(path: '/', redirect: (_, GoRouterState state) => '/overview'),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AppShell(location: state.uri.toString(), child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/overview',
          name: 'overview',
          builder: (BuildContext context, GoRouterState state) {
            return const OverviewPage();
          },
        ),
        GoRoute(
          path: '/catalog',
          name: 'catalog',
          builder: (BuildContext context, GoRouterState state) {
            return const ComponentsPage();
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfilePage();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/catalog/:slug',
      name: 'demo',
      builder: (BuildContext context, GoRouterState state) {
        final String slug = state.pathParameters['slug']!;
        final DemoSpec? demo = findDemo(slug);

        if (demo == null) {
          return NotFoundPage(path: state.uri.toString());
        }

        return DemoDetailPage(demo: demo);
      },
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return NotFoundPage(path: state.uri.toString());
  },
);
