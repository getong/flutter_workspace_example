import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'pages/container_catalog.dart';
import 'pages/container_detail_page.dart';
import 'pages/container_home_page.dart';
import 'pages/button_container.dart';
import 'pages/not_found_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const ContainerHomePage();
      },
    ),
    GoRoute(
      path: '/containers/:slug',
      name: 'container',
      builder: (BuildContext context, GoRouterState state) {
        final String slug = state.pathParameters['slug']!;
        final ContainerPageSpec? page = findContainerPage(slug);
        if (page == null) {
          return NotFoundPage(slug: slug);
        }
        return ContainerDetailPage(page: page);
      },
    ),
    GoRoute(
      path: '/button_container',
      name: 'button_container',
      builder: (BuildContext context, GoRouterState state) {
        return const ButtonContainer();
      },
    ),
  ],
);
