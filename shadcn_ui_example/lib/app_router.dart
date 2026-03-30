import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'demo_catalog.dart';
import 'pages/home_page.dart';
import 'pages/not_found_page.dart';
import 'pages/settings_page.dart';
import 'pages/showcase_detail_page.dart';
import 'pages/showcase_list_page.dart';
import 'widgets/app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (BuildContext context, GoRouterState state) {
    return NotFoundPage(path: state.uri.toString());
  },
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AppShell(state: state, child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: '/examples',
          name: 'examples',
          builder: (BuildContext context, GoRouterState state) {
            return const ShowcaseListPage();
          },
        ),
        GoRoute(
          path: '/layouts/:slug',
          name: 'layout',
          builder: (BuildContext context, GoRouterState state) {
            final String slug = state.pathParameters['slug']!;
            final ShowcaseSpec? spec = findShowcase(slug);
            if (spec == null) {
              return NotFoundPage(path: state.uri.toString());
            }
            return ShowcaseDetailPage(spec: spec);
          },
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsPage();
          },
        ),
      ],
    ),
  ],
);
