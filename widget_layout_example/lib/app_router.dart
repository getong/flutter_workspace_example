import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:widget_layout_example/modules/animation_controller_page.dart';
import 'package:widget_layout_example/modules/animated_default_text_style_page.dart';
import 'package:widget_layout_example/modules/center_box_page.dart';
import 'package:widget_layout_example/modules/animated_switcher_page.dart';
import 'package:widget_layout_example/modules/custom_paint_page.dart';
import 'package:widget_layout_example/modules/data_table_page.dart';
import 'package:widget_layout_example/modules/decorated_box_page.dart';
import 'package:widget_layout_example/modules/exclude_semantics_page.dart';
import 'package:widget_layout_example/modules/filled_button_page.dart';
import 'package:widget_layout_example/modules/fl_chart_page.dart';
import 'package:widget_layout_example/modules/constrained_box_page.dart';
import 'package:widget_layout_example/modules/row_expanded_page.dart';
import 'package:widget_layout_example/modules/gesturedetector.dart';
import 'package:widget_layout_example/modules/column_page.dart';
import 'package:widget_layout_example/modules/column_saved_page.dart';
import 'package:widget_layout_example/modules/intl_page.dart';
import 'package:widget_layout_example/modules/merge_semantics_page.dart';
import 'package:widget_layout_example/modules/padding_page.dart';
import 'package:widget_layout_example/modules/scrollbar_page.dart';
import 'package:widget_layout_example/modules/semantics_page.dart';
import 'package:widget_layout_example/modules/shared_preferences_page.dart';
import 'package:widget_layout_example/modules/single_child_scroll_view_page.dart';
import 'package:widget_layout_example/modules/single_ticker_provider_state_mixin_page.dart';
import 'package:widget_layout_example/modules/table_page.dart';
import 'package:widget_layout_example/modules/text_field_controller_page.dart';
import 'package:widget_layout_example/modules/text_rich_page.dart';
import 'package:widget_layout_example/modules/tween_animation_builder_page.dart';
import 'package:widget_layout_example/modules/tween_page.dart';
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

          GoRoute(
            path: 'scrollbar-page',
            builder: (BuildContext context, GoRouterState state) {
              return const ScrollbarPage();
            },
          ),

          GoRoute(
            path: 'filled-button-page',
            builder: (BuildContext context, GoRouterState state) {
              return const FilledButtonPage();
            },
          ),

          GoRoute(
            path: 'decorated-box-page',
            builder: (BuildContext context, GoRouterState state) {
              return const DecoratedBoxPage();
            },
          ),

          GoRoute(
            path: 'semantics-page',
            builder: (BuildContext context, GoRouterState state) {
              return const SemanticsPage();
            },
          ),

          GoRoute(
            path: 'exclude-semantics-page',
            builder: (BuildContext context, GoRouterState state) {
              return const ExcludeSemanticsPage();
            },
          ),

          GoRoute(
            path: 'merge-semantics-page',
            builder: (BuildContext context, GoRouterState state) {
              return const MergeSemanticsPage();
            },
          ),

          GoRoute(
            path: 'shared-preferences-page',
            builder: (BuildContext context, GoRouterState state) {
              return const SharedPreferencesPage();
            },
          ),

          GoRoute(
            path: 'text-field-controller-page',
            builder: (BuildContext context, GoRouterState state) {
              return const TextFieldControllerPage();
            },
          ),

          GoRoute(
            path: 'data-table-page',
            builder: (BuildContext context, GoRouterState state) {
              return const DataTablePage();
            },
          ),

          GoRoute(
            path: 'fl-chart-page',
            builder: (BuildContext context, GoRouterState state) {
              return const FlChartPage();
            },
          ),

          GoRoute(
            path: 'animated-switcher-page',
            builder: (BuildContext context, GoRouterState state) {
              return const AnimatedSwitcherPage();
            },
          ),

          GoRoute(
            path: 'animated-default-text-style-page',
            builder: (BuildContext context, GoRouterState state) {
              return const AnimatedDefaultTextStylePage();
            },
          ),

          GoRoute(
            path: 'custom-paint-page',
            builder: (BuildContext context, GoRouterState state) {
              return const CustomPaintPage();
            },
          ),

          GoRoute(
            path: 'tween-animation-builder-page',
            builder: (BuildContext context, GoRouterState state) {
              return const TweenAnimationBuilderPage();
            },
          ),

          GoRoute(
            path: 'animation-controller-page',
            builder: (BuildContext context, GoRouterState state) {
              return const AnimationControllerPage();
            },
          ),

          GoRoute(
            path: 'single-ticker-provider-state-mixin-page',
            builder: (BuildContext context, GoRouterState state) {
              return const SingleTickerProviderStateMixinPage();
            },
          ),

          GoRoute(
            path: 'tween-page',
            builder: (BuildContext context, GoRouterState state) {
              return const TweenPage();
            },
          ),
        ],
      ),
    ],
  );

  const AppRouter._();
}
