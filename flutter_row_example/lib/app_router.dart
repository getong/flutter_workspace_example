import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'pages/column_alignment_page.dart';
import 'pages/column_basics_page.dart';
import 'pages/column_nested_page.dart';
import 'pages/not_found_page.dart';
import 'pages/row_alignment_page.dart';
import 'pages/row_basics_page.dart';
import 'pages/row_column_catalog.dart';
import 'pages/row_column_detail_page.dart';
import 'pages/row_column_home_page.dart';
import 'pages/row_expanded_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const RowColumnHomePage();
      },
    ),
    GoRoute(
      path: '/row_basics',
      name: 'row_basics',
      builder: (BuildContext context, GoRouterState state) {
        return const RowBasicsPage();
      },
    ),
    GoRoute(
      path: '/row_alignment',
      name: 'row_alignment',
      builder: (BuildContext context, GoRouterState state) {
        return const RowAlignmentPage();
      },
    ),
    GoRoute(
      path: '/row_expanded',
      name: 'row_expanded',
      builder: (BuildContext context, GoRouterState state) {
        return const RowExpandedPage();
      },
    ),
    GoRoute(
      path: '/column_basics',
      name: 'column_basics',
      builder: (BuildContext context, GoRouterState state) {
        return const ColumnBasicsPage();
      },
    ),
    GoRoute(
      path: '/column_alignment',
      name: 'column_alignment',
      builder: (BuildContext context, GoRouterState state) {
        return const ColumnAlignmentPage();
      },
    ),
    GoRoute(
      path: '/column_nested',
      name: 'column_nested',
      builder: (BuildContext context, GoRouterState state) {
        return const ColumnNestedPage();
      },
    ),
    GoRoute(
      path: '/layouts/:slug',
      name: 'layout',
      builder: (BuildContext context, GoRouterState state) {
        final String slug = state.pathParameters['slug']!;
        final LayoutPageSpec? page = findLayoutPage(slug);
        if (page == null) {
          return NotFoundPage(slug: slug);
        }
        return RowColumnDetailPage(page: page);
      },
    ),
  ],
);
