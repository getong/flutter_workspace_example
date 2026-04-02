import 'package:auto_route/auto_route.dart';

import 'package:widget_layout_example2/home_page.dart';
import 'package:widget_layout_example2/modules/align_page.dart';
import 'package:widget_layout_example2/modules/animated_default_text_style_page.dart';
import 'package:widget_layout_example2/modules/animated_switcher_page.dart';
import 'package:widget_layout_example2/modules/animation_controller_page.dart';
import 'package:widget_layout_example2/modules/center_box_page.dart';
import 'package:widget_layout_example2/modules/column_page.dart';
import 'package:widget_layout_example2/modules/column_saved_page.dart';
import 'package:widget_layout_example2/modules/constrained_box_page.dart';
import 'package:widget_layout_example2/modules/custom_paint_page.dart';
import 'package:widget_layout_example2/modules/data_table_page.dart';
import 'package:widget_layout_example2/modules/decorated_box_page.dart';
import 'package:widget_layout_example2/modules/exclude_semantics_page.dart';
import 'package:widget_layout_example2/modules/filled_button_page.dart';
import 'package:widget_layout_example2/modules/fl_chart_page.dart';
import 'package:widget_layout_example2/modules/flutter_svg_page.dart';
import 'package:widget_layout_example2/modules/font_awesome_flutter_page.dart';
import 'package:widget_layout_example2/modules/gesturedetector.dart';
import 'package:widget_layout_example2/modules/image_widget_page.dart';
import 'package:widget_layout_example2/modules/intl_page.dart';
import 'package:widget_layout_example2/modules/media_query_page.dart';
import 'package:widget_layout_example2/modules/merge_semantics_page.dart';
import 'package:widget_layout_example2/modules/padding_page.dart';
import 'package:widget_layout_example2/modules/positioned_page.dart';
import 'package:widget_layout_example2/modules/row_expanded_page.dart';
import 'package:widget_layout_example2/modules/scrollbar_page.dart';
import 'package:widget_layout_example2/modules/semantics_page.dart';
import 'package:widget_layout_example2/modules/shared_preferences_page.dart';
import 'package:widget_layout_example2/modules/single_child_scroll_view_page.dart';
import 'package:widget_layout_example2/modules/single_ticker_provider_state_mixin_page.dart';
import 'package:widget_layout_example2/modules/sliver_examples_page.dart';
import 'package:widget_layout_example2/modules/table_page.dart';
import 'package:widget_layout_example2/modules/text_field_controller_page.dart';
import 'package:widget_layout_example2/modules/text_rich_page.dart';
import 'package:widget_layout_example2/modules/tween_animation_builder_page.dart';
import 'package:widget_layout_example2/modules/tween_page.dart';
import 'package:widget_layout_example2/modules/tween_sequence_interval_page.dart';

class AppRouter {
  static final RootStackRouter router = RootStackRouter.build(
    defaultRouteType: RouteType.material(),
    routes: <AutoRoute>[
      NamedRouteDef(
        name: 'HomeRoute',
        path: '/',
        builder: (context, data) => const HomePage(),
      ),
      NamedRouteDef(
        name: 'CenterBoxRoute',
        path: '/center-box',
        builder: (context, data) => const CenterBoxPage(),
      ),
      NamedRouteDef(
        name: 'ConstrainedBoxRoute',
        path: '/constrained-box',
        builder: (context, data) => const ConstrainedBoxPage(),
      ),
      NamedRouteDef(
        name: 'RowExpandedRoute',
        path: '/row-expand-page',
        builder: (context, data) => const RowExpandedPage(),
      ),
      NamedRouteDef(
        name: 'GesturedetectorRoute',
        path: '/gesturedector-page',
        builder: (context, data) => const GesturedetectorPage(),
      ),
      NamedRouteDef(
        name: 'ColumnRoute',
        path: '/column-page',
        builder: (context, data) => const ColumnPage(),
      ),
      NamedRouteDef(
        name: 'ColumnSavedRoute',
        path: '/column-saved-page',
        builder: (context, data) => const ColumnSavedPage(),
      ),
      NamedRouteDef(
        name: 'PaddingRoute',
        path: '/padding-page',
        builder: (context, data) => const PaddingPage(),
      ),
      NamedRouteDef(
        name: 'PositionedRoute',
        path: '/positioned-page',
        builder: (context, data) => const PositionedPage(),
      ),
      NamedRouteDef(
        name: 'AlignRoute',
        path: '/align-page',
        builder: (context, data) => const AlignPage(),
      ),
      NamedRouteDef(
        name: 'TableRoute',
        path: '/table-page',
        builder: (context, data) => const TablePage(),
      ),
      NamedRouteDef(
        name: 'IntlRoute',
        path: '/intl-page',
        builder: (context, data) => const IntlPage(),
      ),
      NamedRouteDef(
        name: 'MediaQueryRoute',
        path: '/media-query-page',
        builder: (context, data) => const MediaQueryPage(),
      ),
      NamedRouteDef(
        name: 'TextRichRoute',
        path: '/text-rich-page',
        builder: (context, data) => const TextRichPage(),
      ),
      NamedRouteDef(
        name: 'SingleChildScrollViewRoute',
        path: '/single-child-scroll-view-page',
        builder: (context, data) => const SingleChildScrollViewPage(),
      ),
      NamedRouteDef(
        name: 'SliverExamplesRoute',
        path: '/sliver-widgets-page',
        builder: (context, data) => const SliverExamplesPage(),
      ),
      NamedRouteDef(
        name: 'ScrollbarRoute',
        path: '/scrollbar-page',
        builder: (context, data) => const ScrollbarPage(),
      ),
      NamedRouteDef(
        name: 'FilledButtonRoute',
        path: '/filled-button-page',
        builder: (context, data) => const FilledButtonPage(),
      ),
      NamedRouteDef(
        name: 'DecoratedBoxRoute',
        path: '/decorated-box-page',
        builder: (context, data) => const DecoratedBoxPage(),
      ),
      NamedRouteDef(
        name: 'SemanticsRoute',
        path: '/semantics-page',
        builder: (context, data) => const SemanticsPage(),
      ),
      NamedRouteDef(
        name: 'ExcludeSemanticsRoute',
        path: '/exclude-semantics-page',
        builder: (context, data) => const ExcludeSemanticsPage(),
      ),
      NamedRouteDef(
        name: 'MergeSemanticsRoute',
        path: '/merge-semantics-page',
        builder: (context, data) => const MergeSemanticsPage(),
      ),
      NamedRouteDef(
        name: 'SharedPreferencesRoute',
        path: '/shared-preferences-page',
        builder: (context, data) => const SharedPreferencesPage(),
      ),
      NamedRouteDef(
        name: 'TextFieldControllerRoute',
        path: '/text-field-controller-page',
        builder: (context, data) => const TextFieldControllerPage(),
      ),
      NamedRouteDef(
        name: 'DataTableRoute',
        path: '/data-table-page',
        builder: (context, data) => const DataTablePage(),
      ),
      NamedRouteDef(
        name: 'FlChartRoute',
        path: '/fl-chart-page',
        builder: (context, data) => const FlChartPage(),
      ),
      NamedRouteDef(
        name: 'FontAwesomeFlutterRoute',
        path: '/font-awesome-flutter-page',
        builder: (context, data) => const FontAwesomeFlutterPage(),
      ),
      NamedRouteDef(
        name: 'ImageWidgetRoute',
        path: '/image-widget-page',
        builder: (context, data) => const ImageWidgetPage(),
      ),
      NamedRouteDef(
        name: 'AnimatedSwitcherRoute',
        path: '/animated-switcher-page',
        builder: (context, data) => const AnimatedSwitcherPage(),
      ),
      NamedRouteDef(
        name: 'AnimatedDefaultTextStyleRoute',
        path: '/animated-default-text-style-page',
        builder: (context, data) => const AnimatedDefaultTextStylePage(),
      ),
      NamedRouteDef(
        name: 'CustomPaintRoute',
        path: '/custom-paint-page',
        builder: (context, data) => const CustomPaintPage(),
      ),
      NamedRouteDef(
        name: 'TweenAnimationBuilderRoute',
        path: '/tween-animation-builder-page',
        builder: (context, data) => const TweenAnimationBuilderPage(),
      ),
      NamedRouteDef(
        name: 'AnimationControllerRoute',
        path: '/animation-controller-page',
        builder: (context, data) => const AnimationControllerPage(),
      ),
      NamedRouteDef(
        name: 'SingleTickerProviderStateMixinRoute',
        path: '/single-ticker-provider-state-mixin-page',
        builder: (context, data) => const SingleTickerProviderStateMixinPage(),
      ),
      NamedRouteDef(
        name: 'TweenRoute',
        path: '/tween-page',
        builder: (context, data) => const TweenPage(),
      ),
      NamedRouteDef(
        name: 'TweenSequenceIntervalRoute',
        path: '/tween-sequence-interval-page',
        builder: (context, data) => const TweenSequenceIntervalPage(),
      ),
      NamedRouteDef(
        name: 'FlutterSvgRoute',
        path: '/flutter-svg-page',
        builder: (context, data) => const FlutterSvgPage(),
      ),
    ],
  );

  const AppRouter._();
}
