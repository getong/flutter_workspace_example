import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:widget_layout_example/modules/center_box_page.dart';
import 'package:widget_layout_example/modules/constrained_box_page.dart';
import 'package:widget_layout_example/modules/row_expanded_page.dart';
import 'package:widget_layout_example/modules/gesturedetector.dart';
import 'package:widget_layout_example/modules/column_page.dart';
import 'package:widget_layout_example/modules/column_saved_page.dart';
import 'package:widget_layout_example/modules/intl_page.dart';
import 'package:widget_layout_example/modules/padding_page.dart';
import 'package:widget_layout_example/modules/single_child_scroll_view_page.dart';
import 'package:widget_layout_example/modules/table_page.dart';
import 'package:widget_layout_example/modules/text_rich_page.dart';
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

          GoRoute(
            path: 'column-page',
            builder: (BuildContext context, GoRouterState state) {
              return const ColumnPage();
            },
          ),

          GoRoute(
            path: 'column-saved-page',
            builder: (BuildContext context, GoRouterState state) {
              return const ColumnSavedPage();
            },
          ),

          GoRoute(
            path: 'padding-page',
            builder: (BuildContext context, GoRouterState state) {
              return const PaddingPage();
            },
          ),

          GoRoute(
            path: 'table-page',
            builder: (BuildContext context, GoRouterState state) {
              return const TablePage();
            },
          ),

          GoRoute(
            path: 'intl-page',
            builder: (BuildContext context, GoRouterState state) {
              return const IntlPage();
            },
          ),

          GoRoute(
            path: 'text-rich-page',
            builder: (BuildContext context, GoRouterState state) {
              return const TextRichPage();
            },
          ),

          GoRoute(
            path: 'single-child-scroll-view-page',
            builder: (BuildContext context, GoRouterState state) {
              return const SingleChildScrollViewPage();
            },
          ),
        ],
      ),
    ],
  );

  const AppRouter._();
}
