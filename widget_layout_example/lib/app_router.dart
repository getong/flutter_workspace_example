import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:widget_layout_example/modules/center_box_page.dart';
import 'package:widget_layout_example/modules/constrained_box_page.dart';
import 'package:widget_layout_example/modules/row_expanded_page.dart';
import 'package:widget_layout_example/modules/gesturedetector.dart';
import 'package:widget_layout_example/home_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'center-box',
            builder: (BuildContext context, GoRouterState state) {
              return const CenterBoxPage();
            },
          ),

          GoRoute(
            path: 'constrained-box',
            builder: (BuildContext context, GoRouterState state) {
              return const ConstrainedBoxPage();
            },
          ),

          GoRoute(
            path: 'row-expand-page',
            builder: (BuildContext context, GoRouterState state) {
              return const RowExpandedPage();
            },
          ),

          GoRoute(
            path: 'gesturedector-page',
            builder: (BuildContext context, GoRouterState state) {
              return const GesturedetectorPage();
            },
          ),
        ],
      ),
    ],
  );

  const AppRouter._();
}
