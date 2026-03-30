import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'pages/box_pad_page.dart';
import 'pages/column_super_page.dart';
import 'pages/home_page.dart';
import 'pages/not_found_page.dart';
import 'pages/row_super_page.dart';
import 'pages/story_detail_page.dart';
import 'pages/text_fitting_page.dart';
import 'pages/wrap_super_page.dart';
import 'story_catalog.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/box-pad',
      name: 'box-pad',
      builder: (BuildContext context, GoRouterState state) {
        return const BoxPadPage();
      },
    ),
    GoRoute(
      path: '/row-super',
      name: 'row-super',
      builder: (BuildContext context, GoRouterState state) {
        return const RowSuperPage();
      },
    ),
    GoRoute(
      path: '/column-super',
      name: 'column-super',
      builder: (BuildContext context, GoRouterState state) {
        return const ColumnSuperPage();
      },
    ),
    GoRoute(
      path: '/wrap-super',
      name: 'wrap-super',
      builder: (BuildContext context, GoRouterState state) {
        return const WrapSuperPage();
      },
    ),
    GoRoute(
      path: '/text-fitting',
      name: 'text-fitting',
      builder: (BuildContext context, GoRouterState state) {
        return const TextFittingPage();
      },
    ),
    GoRoute(
      path: '/stories/:slug',
      name: 'story',
      builder: (BuildContext context, GoRouterState state) {
        final String slug = state.pathParameters['slug']!;
        final StorySpec? story = findStoryBySlug(slug);

        if (story == null) {
          return NotFoundPage(label: '/stories/$slug');
        }

        return StoryDetailPage(story: story);
      },
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return NotFoundPage(label: state.uri.toString());
  },
);
