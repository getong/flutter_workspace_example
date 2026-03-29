import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'data/app_database.dart';
import 'pages/not_found_page.dart';
import 'pages/todo_detail_page.dart';
import 'pages/todo_form_page.dart';
import 'pages/todo_home_page.dart';

GoRouter createAppRouter(AppDatabase database) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return TodoHomePage(database: database);
        },
      ),
      GoRoute(
        path: '/todos/new',
        name: 'todo_new',
        builder: (BuildContext context, GoRouterState state) {
          return TodoFormPage(database: database);
        },
      ),
      GoRoute(
        path: '/todos/:id',
        name: 'todo_detail',
        builder: (BuildContext context, GoRouterState state) {
          final int? id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            return const NotFoundPage(message: 'Invalid todo id.');
          }
          return TodoDetailPage(database: database, todoId: id);
        },
      ),
      GoRoute(
        path: '/todos/:id/edit',
        name: 'todo_edit',
        builder: (BuildContext context, GoRouterState state) {
          final int? id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            return const NotFoundPage(message: 'Invalid todo id.');
          }
          return TodoFormPage(database: database, todoId: id);
        },
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return NotFoundPage(message: state.error.toString());
    },
  );
}
