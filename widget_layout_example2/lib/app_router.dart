import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/auto_route_demo_support.dart';
import 'package:widget_layout_example2/home_page.dart';
import 'package:widget_layout_example2/modules/align_page.dart';
import 'package:widget_layout_example2/modules/animated_default_text_style_page.dart';
import 'package:widget_layout_example2/modules/animated_switcher_page.dart';
import 'package:widget_layout_example2/modules/animated_toggle_switch_page.dart';
import 'package:widget_layout_example2/modules/animation_controller_page.dart';
import 'package:widget_layout_example2/modules/alert_dialog_page.dart';
import 'package:widget_layout_example2/modules/auto_route_usage_page.dart';
import 'package:widget_layout_example2/modules/action_chip_page.dart';
import 'package:widget_layout_example2/modules/center_box_page.dart';
import 'package:widget_layout_example2/modules/cached_network_image_ce_page.dart';
import 'package:widget_layout_example2/modules/checkbox_page.dart';
import 'package:widget_layout_example2/modules/button_showcase_page.dart';
import 'package:widget_layout_example2/modules/bottom_navigation_bar_page.dart';
import 'package:widget_layout_example2/modules/circular_progress_indicator_page.dart';
import 'package:widget_layout_example2/modules/clip_oval_page.dart';
import 'package:widget_layout_example2/modules/clip_path_page.dart';
import 'package:widget_layout_example2/modules/clip_r_rect_page.dart';
import 'package:widget_layout_example2/modules/clip_rect_page.dart';
import 'package:widget_layout_example2/modules/column_page.dart';
import 'package:widget_layout_example2/modules/column_saved_page.dart';
import 'package:widget_layout_example2/modules/constrained_box_page.dart';
import 'package:widget_layout_example2/modules/custom_clipper_page.dart';
import 'package:widget_layout_example2/modules/custom_paint_page.dart';
import 'package:widget_layout_example2/modules/data_table_page.dart';
import 'package:widget_layout_example2/modules/decorated_box_page.dart';
import 'package:widget_layout_example2/modules/dialog_page.dart';
import 'package:widget_layout_example2/modules/draggable_page.dart';
import 'package:widget_layout_example2/modules/drag_target_page.dart';
import 'package:widget_layout_example2/modules/drift_flutter_page.dart';
import 'package:widget_layout_example2/modules/date_picker_page.dart';
import 'package:widget_layout_example2/modules/exclude_semantics_page.dart';
import 'package:widget_layout_example2/modules/filled_button_page.dart';
import 'package:widget_layout_example2/modules/filter_chip_page.dart';
import 'package:widget_layout_example2/modules/fl_chart_page.dart';
import 'package:widget_layout_example2/modules/flexible_page.dart';
import 'package:widget_layout_example2/modules/floating_action_button_page.dart';
import 'package:widget_layout_example2/modules/flow_page.dart';
import 'package:widget_layout_example2/modules/flutter_svg_page.dart';
import 'package:widget_layout_example2/modules/flutter_auto_size_text_page.dart';
import 'package:widget_layout_example2/modules/font_awesome_flutter_page.dart';
import 'package:widget_layout_example2/modules/form_page.dart';
import 'package:widget_layout_example2/modules/form_field_page.dart';
import 'package:widget_layout_example2/modules/future_builder_page.dart';
import 'package:widget_layout_example2/modules/gesturedetector.dart';
import 'package:widget_layout_example2/modules/image_widget_page.dart';
import 'package:widget_layout_example2/modules/ink_widgets_page.dart';
import 'package:widget_layout_example2/modules/input_chip_page.dart';
import 'package:widget_layout_example2/modules/intl_page.dart';
import 'package:widget_layout_example2/modules/keyboard_listener_page.dart';
import 'package:widget_layout_example2/modules/layout_builder_page.dart';
import 'package:widget_layout_example2/modules/linear_progress_indicator_page.dart';
import 'package:widget_layout_example2/modules/material_symbols_icons_page.dart';
import 'package:widget_layout_example2/modules/media_query_page.dart';
import 'package:widget_layout_example2/modules/merge_semantics_page.dart';
import 'package:widget_layout_example2/modules/padding_page.dart';
import 'package:widget_layout_example2/modules/positioned_page.dart';
import 'package:widget_layout_example2/modules/radio_page.dart';
import 'package:widget_layout_example2/modules/rich_text_page.dart';
import 'package:widget_layout_example2/modules/row_expanded_page.dart';
import 'package:widget_layout_example2/modules/rotated_box_page.dart';
import 'package:widget_layout_example2/modules/safe_area_page.dart';
import 'package:widget_layout_example2/modules/scrollbar_page.dart';
import 'package:widget_layout_example2/modules/semantics_page.dart';
import 'package:widget_layout_example2/modules/shared_preferences_page.dart';
import 'package:widget_layout_example2/modules/show_dialog_page.dart';
import 'package:widget_layout_example2/modules/single_child_scroll_view_page.dart';
import 'package:widget_layout_example2/modules/single_ticker_provider_state_mixin_page.dart';
import 'package:widget_layout_example2/modules/simple_dialog_page.dart';
import 'package:widget_layout_example2/modules/slider_page.dart';
import 'package:widget_layout_example2/modules/sliver_examples_page.dart';
import 'package:widget_layout_example2/modules/snack_bar_page.dart';
import 'package:widget_layout_example2/modules/stream_builder_page.dart';
import 'package:widget_layout_example2/modules/switch_page.dart';
import 'package:widget_layout_example2/modules/table_page.dart';
import 'package:widget_layout_example2/modules/text_field_controller_page.dart';
import 'package:widget_layout_example2/modules/text_rich_page.dart';
import 'package:widget_layout_example2/modules/text_style_page.dart';
import 'package:widget_layout_example2/modules/time_picker_page.dart';
import 'package:widget_layout_example2/modules/transform_page.dart';
import 'package:widget_layout_example2/modules/tween_animation_builder_page.dart';
import 'package:widget_layout_example2/modules/tween_page.dart';
import 'package:widget_layout_example2/modules/tween_sequence_interval_page.dart';
import 'package:widget_layout_example2/modules/unconstrained_box_page.dart';
import 'package:widget_layout_example2/modules/wrap_page.dart';
import 'package:widget_layout_example2/modules/choice_chip_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  late final List<AutoRouteGuard> guards = <AutoRouteGuard>[
    AutoRouteGuard.simple((NavigationResolver resolver, StackRouter router) {
      if (resolver.routeName != AutoRouteGlobalProtectedRoute.name ||
          demoAuthController.isLoggedIn ||
          resolver.routeName == AutoRouteLoginRoute.name) {
        resolver.next();
        return;
      }

      demoNavigationLog.add('global guard blocked ${resolver.routeName}');
      resolver.redirectUntil(
        AutoRouteLoginRoute(
          onResult: (bool didLogin) {
            demoNavigationLog.add(
              'global guard resume ${resolver.routeName}: $didLogin',
            );
            resolver.resolveNext(didLogin, reevaluateNext: false);
          },
        ),
      );
    }, debugLabel: 'DemoGlobalGuard'),
  ];

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(
      page: HomeRoute.page,
      path: '/',
      children: <AutoRoute>[
        AutoRoute(page: LayoutTabRoute.page, path: 'layout', initial: true),
        AutoRoute(page: ContentTabRoute.page, path: 'content'),
        AutoRoute(page: AnimationTabRoute.page, path: 'animation'),
      ],
    ),
    AutoRoute(page: CenterBoxRoute.page, path: '/center-box'),
    AutoRoute(page: ConstrainedBoxRoute.page, path: '/constrained-box'),
    AutoRoute(
      page: UnconstrainedBoxExampleRoute.page,
      path: '/unconstrained-box-page',
    ),
    AutoRoute(page: RowExpandedRoute.page, path: '/row-expand-page'),
    AutoRoute(page: FlexibleRoute.page, path: '/flexible-page'),
    AutoRoute(page: GesturedetectorRoute.page, path: '/gesturedector-page'),
    AutoRoute(page: ColumnRoute.page, path: '/column-page'),
    AutoRoute(page: ColumnSavedRoute.page, path: '/column-saved-page'),
    AutoRoute(page: FlowExampleRoute.page, path: '/flow-page'),
    AutoRoute(
      page: LayoutBuilderExampleRoute.page,
      path: '/layout-builder-page',
    ),
    AutoRoute(page: PaddingRoute.page, path: '/padding-page'),
    AutoRoute(page: WrapRoute.page, path: '/wrap-page'),
    AutoRoute(page: PositionedRoute.page, path: '/positioned-page'),
    AutoRoute(page: AlignRoute.page, path: '/align-page'),
    AutoRoute(page: TransformExampleRoute.page, path: '/transform-page'),
    AutoRoute(page: RotatedBoxExampleRoute.page, path: '/rotated-box-page'),
    AutoRoute(page: SafeAreaRoute.page, path: '/safe-area-page'),
    AutoRoute(page: ClipOvalExampleRoute.page, path: '/clip-oval-page'),
    AutoRoute(page: ClipRRectExampleRoute.page, path: '/clip-r-rect-page'),
    AutoRoute(page: ClipRectExampleRoute.page, path: '/clip-rect-page'),
    AutoRoute(page: ClipPathExampleRoute.page, path: '/clip-path-page'),
    AutoRoute(
      page: CustomClipperExampleRoute.page,
      path: '/custom-clipper-page',
    ),
    AutoRoute(page: TableRoute.page, path: '/table-page'),
    AutoRoute(page: ButtonShowcaseRoute.page, path: '/classic-buttons-page'),
    AutoRoute(page: AutoRouteUsageRoute.page, path: '/auto-route-page'),
    RedirectRoute(
      path: '/auto-route-page/legacy',
      redirectTo: '/auto-route-page/books',
    ),
    AutoRoute(page: AutoRouteBooksRoute.page, path: '/auto-route-page/books'),
    RedirectRoute(
      path: '/auto-route-page/books/:id/legacy',
      redirectTo: '/auto-route-page/books/:id',
    ),
    AutoRoute(
      page: AutoRouteBookDetailsRoute.page,
      path: '/auto-route-page/books/:id',
    ),
    AutoRoute(
      page: AutoRouteNestedRoute.page,
      path: '/auto-route-page/nested',
      children: <AutoRoute>[
        AutoRoute(
          page: AutoRouteBooksTabRoute.page,
          path: 'books',
          initial: true,
        ),
        AutoRoute(page: AutoRouteProfileTabRoute.page, path: 'profile'),
        AutoRoute(page: AutoRouteSettingsTabRoute.page, path: 'settings'),
      ],
    ),
    AutoRoute(
      page: AutoRouteProductRoute.page,
      path: '/auto-route-page/products/:id',
      children: <AutoRoute>[
        AutoRoute(
          page: AutoRouteProductOverviewRoute.page,
          path: '',
          initial: true,
        ),
        AutoRoute(page: AutoRouteProductReviewRoute.page, path: 'review'),
      ],
    ),
    AutoRoute(
      page: AutoRouteProtectedRoute.page,
      path: '/auto-route-page/protected',
      guards: <AutoRouteGuard>[
        AutoRouteGuard.simple((
          NavigationResolver resolver,
          StackRouter router,
        ) {
          if (demoAuthController.isLoggedIn) {
            resolver.next();
            return;
          }

          demoNavigationLog.add('route guard blocked ${resolver.routeName}');
          resolver.redirectUntil(
            AutoRouteLoginRoute(
              onResult: (bool didLogin) {
                demoNavigationLog.add(
                  'route guard resume ${resolver.routeName}: $didLogin',
                );
                resolver.resolveNext(didLogin, reevaluateNext: false);
              },
            ),
          );
        }, debugLabel: 'DemoRouteGuard'),
      ],
    ),
    AutoRoute(
      page: AutoRouteGlobalProtectedRoute.page,
      path: '/auto-route-page/global-protected',
    ),
    AutoRoute(
      page: AutoRouteWrappedRoute.page,
      path: '/auto-route-page/wrapped',
    ),
    AutoRoute(
      page: AutoRouteObserverRoute.page,
      path: '/auto-route-page/observer',
    ),
    AutoRoute(page: AutoRouteLoginRoute.page, path: '/auto-route-page/login'),
    AutoRoute(page: AutoRouteUnknownRoute.page, path: '/auto-route-page/*'),
    AutoRoute(page: IntlRoute.page, path: '/intl-page'),
    AutoRoute(page: SwitchExampleRoute.page, path: '/switch-page'),
    AutoRoute(page: CheckboxExampleRoute.page, path: '/checkbox-page'),
    AutoRoute(page: RadioExampleRoute.page, path: '/radio-page'),
    AutoRoute(page: InputChipRoute.page, path: '/input-chip-page'),
    AutoRoute(page: ChoiceChipRoute.page, path: '/choice-chip-page'),
    AutoRoute(page: FilterChipRoute.page, path: '/filter-chip-page'),
    AutoRoute(page: ActionChipRoute.page, path: '/action-chip-page'),
    AutoRoute(
      page: LinearProgressIndicatorExampleRoute.page,
      path: '/linear-progress-indicator-page',
    ),
    AutoRoute(
      page: CircularProgressIndicatorExampleRoute.page,
      path: '/circular-progress-indicator-page',
    ),
    AutoRoute(page: SliderExampleRoute.page, path: '/slider-page'),
    AutoRoute(page: DatePickerRoute.page, path: '/date-picker-page'),
    AutoRoute(page: TimePickerRoute.page, path: '/time-picker-page'),
    AutoRoute(page: FormRoute.page, path: '/form-page'),
    AutoRoute(page: FormFieldRoute.page, path: '/form-field-page'),
    AutoRoute(page: DraggableExampleRoute.page, path: '/draggable-page'),
    AutoRoute(page: DragTargetExampleRoute.page, path: '/drag-target-page'),
    AutoRoute(page: RichTextRoute.page, path: '/rich-text-page'),
    AutoRoute(page: TextStyleRoute.page, path: '/text-style-page'),
    AutoRoute(
      page: BottomNavigationBarExampleRoute.page,
      path: '/bottom-navigation-bar-page',
    ),
    AutoRoute(
      page: FloatingActionButtonExampleRoute.page,
      path: '/floating-action-button-page',
    ),
    AutoRoute(page: SnackBarExampleRoute.page, path: '/snack-bar-page'),
    AutoRoute(page: ShowDialogExampleRoute.page, path: '/show-dialog-page'),
    AutoRoute(page: AlertDialogExampleRoute.page, path: '/alert-dialog-page'),
    AutoRoute(page: SimpleDialogExampleRoute.page, path: '/simple-dialog-page'),
    AutoRoute(page: DialogExampleRoute.page, path: '/dialog-page'),
    AutoRoute(page: FutureBuilderRoute.page, path: '/future-builder-page'),
    AutoRoute(page: StreamBuilderRoute.page, path: '/stream-builder-page'),
    AutoRoute(page: DriftFlutterRoute.page, path: '/drift-flutter-page'),
    AutoRoute(
      page: KeyboardListenerRoute.page,
      path: '/keyboard-listener-page',
    ),
    AutoRoute(page: InkWidgetsRoute.page, path: '/ink-widgets-page'),
    AutoRoute(page: MediaQueryRoute.page, path: '/media-query-page'),
    AutoRoute(page: TextRichRoute.page, path: '/text-rich-page'),
    AutoRoute(
      page: SingleChildScrollViewRoute.page,
      path: '/single-child-scroll-view-page',
    ),
    AutoRoute(page: SliverExamplesRoute.page, path: '/sliver-widgets-page'),
    AutoRoute(page: ScrollbarRoute.page, path: '/scrollbar-page'),
    AutoRoute(page: FilledButtonRoute.page, path: '/filled-button-page'),
    AutoRoute(page: DecoratedBoxRoute.page, path: '/decorated-box-page'),
    AutoRoute(page: SemanticsRoute.page, path: '/semantics-page'),
    AutoRoute(
      page: ExcludeSemanticsRoute.page,
      path: '/exclude-semantics-page',
    ),
    AutoRoute(page: MergeSemanticsRoute.page, path: '/merge-semantics-page'),
    AutoRoute(
      page: SharedPreferencesRoute.page,
      path: '/shared-preferences-page',
    ),
    AutoRoute(
      page: TextFieldControllerRoute.page,
      path: '/text-field-controller-page',
    ),
    AutoRoute(
      page: FlutterAutoSizeTextRoute.page,
      path: '/flutter-auto-size-text-page',
    ),
    AutoRoute(
      page: CachedNetworkImageCeRoute.page,
      path: '/cached-network-image-ce-page',
    ),
    AutoRoute(page: DataTableRoute.page, path: '/data-table-page'),
    AutoRoute(page: FlChartRoute.page, path: '/fl-chart-page'),
    AutoRoute(
      page: FontAwesomeFlutterRoute.page,
      path: '/font-awesome-flutter-page',
    ),
    AutoRoute(
      page: MaterialSymbolsIconsRoute.page,
      path: '/material-symbols-icons-page',
    ),
    AutoRoute(page: ImageWidgetRoute.page, path: '/image-widget-page'),
    AutoRoute(
      page: AnimatedSwitcherRoute.page,
      path: '/animated-switcher-page',
    ),
    AutoRoute(
      page: AnimatedToggleSwitchRoute.page,
      path: '/animated-toggle-switch-page',
    ),
    AutoRoute(
      page: AnimatedDefaultTextStyleRoute.page,
      path: '/animated-default-text-style-page',
    ),
    AutoRoute(page: CustomPaintRoute.page, path: '/custom-paint-page'),
    AutoRoute(
      page: TweenAnimationBuilderRoute.page,
      path: '/tween-animation-builder-page',
    ),
    AutoRoute(
      page: AnimationControllerRoute.page,
      path: '/animation-controller-page',
    ),
    AutoRoute(
      page: SingleTickerProviderStateMixinRoute.page,
      path: '/single-ticker-provider-state-mixin-page',
    ),
    AutoRoute(page: TweenRoute.page, path: '/tween-page'),
    AutoRoute(
      page: TweenSequenceIntervalRoute.page,
      path: '/tween-sequence-interval-page',
    ),
    AutoRoute(page: FlutterSvgRoute.page, path: '/flutter-svg-page'),
  ];
}
