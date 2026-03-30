import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'data/local/drift_hydrated_storage.dart';
import 'presentation/pages/layout_detail_page.dart';
import 'presentation/pages/layout_home_page.dart';
import 'presentation/pages/not_found_page.dart';

GoRouter buildAppRouter({required DriftHydratedStorage hydratedStorage}) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return LayoutHomePage(hydratedStorage: hydratedStorage);
        },
      ),
      GoRoute(
        path: '/layouts/:slug',
        name: 'layout',
        builder: (BuildContext context, GoRouterState state) {
          final String slug = state.pathParameters['slug'] ?? '';
          return LayoutDetailPage(slug: slug);
        },
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return NotFoundPage(slug: state.uri.toString());
    },
  );
}
