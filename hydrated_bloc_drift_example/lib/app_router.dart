import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'data/repositories/fetch_history_repository.dart';
import 'presentation/pages/layout_detail_page.dart';
import 'presentation/pages/layout_home_page.dart';
import 'presentation/pages/fetch_history_detail_page.dart';
import 'presentation/pages/fetch_history_page.dart';
import 'presentation/pages/fetch_home_page.dart';
import 'presentation/pages/not_found_page.dart';

GoRouter buildAppRouter({
  required FetchHistoryRepository fetchHistoryRepository,
}) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const LayoutHomePage();
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
      GoRoute(
        path: '/fetch',
        name: 'fetch',
        builder: (BuildContext context, GoRouterState state) {
          return const FetchHomePage();
        },
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (BuildContext context, GoRouterState state) {
          return FetchHistoryPage(repository: fetchHistoryRepository);
        },
      ),
      GoRoute(
        path: '/history/:id',
        name: 'history-detail',
        builder: (BuildContext context, GoRouterState state) {
          final int? historyId = int.tryParse(state.pathParameters['id'] ?? '');
          if (historyId == null) {
            return NotFoundPage(slug: state.uri.toString());
          }
          return FetchHistoryDetailPage(
            historyId: historyId,
            repository: fetchHistoryRepository,
          );
        },
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return NotFoundPage(slug: state.uri.toString());
    },
  );
}
