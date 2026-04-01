import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'pages/not_found_page.dart';
import 'pages/provider_catalog.dart';
import 'pages/provider_detail_page.dart';
import 'pages/provider_home_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const ProviderHomePage();
      },
    ),
    GoRoute(
      path: '/examples/:slug',
      name: 'example',
      builder: (BuildContext context, GoRouterState state) {
        final String slug = state.pathParameters['slug']!;
        final ProviderDemoSpec? demo = findProviderDemo(slug);
        if (demo == null) {
          return NotFoundPage(slug: slug);
        }
        return ProviderDetailPage(demo: demo);
      },
    ),
  ],
);
