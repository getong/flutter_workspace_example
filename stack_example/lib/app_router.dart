import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'pages/not_found_page.dart';
import 'pages/stack_alignment_page.dart';
import 'pages/stack_badge_module_page.dart';
import 'pages/stack_basics_page.dart';
import 'pages/stack_catalog.dart';
import 'pages/stack_detail_page.dart';
import 'pages/stack_home_page.dart';
import 'pages/stack_interactive_module_page.dart';
import 'pages/stack_layers_module_page.dart';
import 'pages/stack_positioned_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const StackHomePage();
      },
    ),
    GoRoute(
      path: '/stack_basics',
      name: 'stack_basics',
      builder: (BuildContext context, GoRouterState state) {
        return const StackBasicsPage();
      },
    ),
    GoRoute(
      path: '/stack_alignment',
      name: 'stack_alignment',
      builder: (BuildContext context, GoRouterState state) {
        return const StackAlignmentPage();
      },
    ),
    GoRoute(
      path: '/stack_positioned',
      name: 'stack_positioned',
      builder: (BuildContext context, GoRouterState state) {
        return const StackPositionedPage();
      },
    ),
    GoRoute(
      path: '/stack_layers_module',
      name: 'stack_layers_module',
      builder: (BuildContext context, GoRouterState state) {
        return const StackLayersModulePage();
      },
    ),
    GoRoute(
      path: '/stack_badge_module',
      name: 'stack_badge_module',
      builder: (BuildContext context, GoRouterState state) {
        return const StackBadgeModulePage();
      },
    ),
    GoRoute(
      path: '/stack_interactive_module',
      name: 'stack_interactive_module',
      builder: (BuildContext context, GoRouterState state) {
        return const StackInteractiveModulePage();
      },
    ),
    GoRoute(
      path: '/layouts/:slug',
      name: 'layout',
      builder: (BuildContext context, GoRouterState state) {
        final String slug = state.pathParameters['slug']!;
        final StackPageSpec? page = findStackPage(slug);
        if (page == null) {
          return NotFoundPage(slug: slug);
        }
        return StackDetailPage(page: page);
      },
    ),
  ],
);
