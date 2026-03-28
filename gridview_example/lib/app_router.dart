import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'pages/grid_basics_page.dart';
import 'pages/grid_builder_page.dart';
import 'pages/grid_catalog.dart';
import 'pages/grid_detail_page.dart';
import 'pages/grid_extent_page.dart';
import 'pages/grid_home_page.dart';
import 'pages/grid_interactive_module_page.dart';
import 'pages/not_found_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const GridHomePage();
      },
    ),
    GoRoute(
      path: '/grid_basics',
      name: 'grid_basics',
      builder: (BuildContext context, GoRouterState state) {
        return const GridBasicsPage();
      },
    ),
    GoRoute(
      path: '/grid_builder',
      name: 'grid_builder',
      builder: (BuildContext context, GoRouterState state) {
        return const GridBuilderPage();
      },
    ),
    GoRoute(
      path: '/grid_extent',
      name: 'grid_extent',
      builder: (BuildContext context, GoRouterState state) {
        return const GridExtentPage();
      },
    ),
    GoRoute(
      path: '/grid_interactive_module',
      name: 'grid_interactive_module',
      builder: (BuildContext context, GoRouterState state) {
        return const GridInteractiveModulePage();
      },
    ),
    GoRoute(
      path: '/grids/:slug',
      name: 'grid_preview',
      builder: (BuildContext context, GoRouterState state) {
        final String slug = state.pathParameters['slug']!;
        final GridPageSpec? page = findGridPage(slug);
        if (page == null) {
          return NotFoundPage(slug: slug);
        }
        return GridDetailPage(page: page);
      },
    ),
  ],
);
