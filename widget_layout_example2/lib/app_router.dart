import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/auto_route_demo_support.dart';
import 'package:widget_layout_example2/auth/auth.dart';
import 'package:widget_layout_example2/home_page.dart';
import 'package:widget_layout_example2/modules/about_dialog_page.dart';
import 'package:widget_layout_example2/modules/advanced_progress_indicator_page.dart';
import 'package:widget_layout_example2/modules/align_page.dart';
import 'package:widget_layout_example2/modules/animated_default_text_style_page.dart';
import 'package:widget_layout_example2/modules/animated_list_tile_page.dart';
import 'package:widget_layout_example2/modules/animated_text_kit_page.dart';
import 'package:widget_layout_example2/modules/animated_switcher_page.dart';
import 'package:widget_layout_example2/modules/animated_toggle_switch_page.dart';
import 'package:widget_layout_example2/modules/animation_controller_page.dart';
import 'package:widget_layout_example2/modules/animations_page.dart';
import 'package:widget_layout_example2/modules/alert_dialog_page.dart';
import 'package:widget_layout_example2/modules/auto_route_usage_page.dart';
import 'package:widget_layout_example2/modules/action_chip_page.dart';
import 'package:widget_layout_example2/modules/animate_do_page.dart';
import 'package:widget_layout_example2/modules/aspect_ratio_page.dart';
import 'package:widget_layout_example2/modules/block_semantics_page.dart';
import 'package:widget_layout_example2/modules/binarize_page.dart';
import 'package:widget_layout_example2/modules/binary_serializable_page.dart';
import 'package:widget_layout_example2/modules/center_box_page.dart';
import 'package:widget_layout_example2/modules/cached_network_image_ce_page.dart';
import 'package:widget_layout_example2/modules/characters_page.dart';
import 'package:widget_layout_example2/modules/chat_bubbles_page.dart';
import 'package:widget_layout_example2/modules/chopper_page.dart';
import 'package:widget_layout_example2/modules/cookie_jar_page.dart';
import 'package:widget_layout_example2/modules/clipboard_page.dart';
import 'package:widget_layout_example2/modules/checkbox_page.dart';
import 'package:widget_layout_example2/modules/button_showcase_page.dart';
import 'package:widget_layout_example2/modules/bottom_navigation_bar_page.dart';
import 'package:widget_layout_example2/modules/built_value_page.dart';
import 'package:widget_layout_example2/modules/cascade_route_page.dart';
import 'package:widget_layout_example2/modules/circular_progress_indicator_page.dart';
import 'package:widget_layout_example2/modules/clip_oval_page.dart';
import 'package:widget_layout_example2/modules/clip_path_page.dart';
import 'package:widget_layout_example2/modules/clip_r_rect_page.dart';
import 'package:widget_layout_example2/modules/clip_rect_page.dart';
import 'package:widget_layout_example2/modules/column_page.dart';
import 'package:widget_layout_example2/modules/column_saved_page.dart';
import 'package:widget_layout_example2/modules/column_saved_stateless_page.dart';
import 'package:widget_layout_example2/modules/constrained_box_page.dart';
import 'package:widget_layout_example2/modules/container_page.dart';
import 'package:widget_layout_example2/modules/custom_clipper_page.dart';
import 'package:widget_layout_example2/modules/custom_multi_child_layout_page.dart';
import 'package:widget_layout_example2/modules/custom_scroll_view_page.dart';
import 'package:widget_layout_example2/modules/custom_paint_page.dart';
import 'package:widget_layout_example2/modules/crypto_page.dart';
import 'package:widget_layout_example2/modules/cue_page.dart';
import 'package:widget_layout_example2/modules/data_table_page.dart';
import 'package:widget_layout_example2/modules/date_picker_dialog_page.dart';
import 'package:widget_layout_example2/modules/decorated_box_page.dart';
import 'package:widget_layout_example2/modules/dialog_page.dart';
import 'package:widget_layout_example2/modules/dio_page.dart';
import 'package:widget_layout_example2/modules/dio_smart_retry_page.dart';
import 'package:widget_layout_example2/modules/dio_multi_url_page.dart';
import 'package:widget_layout_example2/modules/dotted_border_page.dart';
import 'package:widget_layout_example2/modules/drawer_page.dart';
import 'package:widget_layout_example2/modules/draggable_page.dart';
import 'package:widget_layout_example2/modules/drag_target_page.dart';
import 'package:widget_layout_example2/modules/drift_flutter_page.dart';
import 'package:widget_layout_example2/modules/dynamic_color_page.dart';
import 'package:widget_layout_example2/modules/encrypter_plus_page.dart';
import 'package:widget_layout_example2/modules/extended_image_page.dart';
import 'package:widget_layout_example2/modules/expandable_section_page.dart';
import 'package:widget_layout_example2/modules/expansion_panel_list_page.dart';
import 'package:widget_layout_example2/modules/expanded_page.dart';
import 'package:widget_layout_example2/modules/date_picker_page.dart';
import 'package:widget_layout_example2/modules/exclude_semantics_page.dart';
import 'package:widget_layout_example2/modules/fc_native_video_thumbnail_page.dart';
import 'package:widget_layout_example2/modules/ffigen_page.dart';
import 'package:widget_layout_example2/modules/flash_page.dart';
import 'package:widget_layout_example2/modules/filled_button_page.dart';
import 'package:widget_layout_example2/modules/filter_chip_page.dart';
import 'package:widget_layout_example2/modules/fl_chart_page.dart';
import 'package:widget_layout_example2/modules/flex_color_scheme_page.dart';
import 'package:widget_layout_example2/modules/flex_seed_scheme_page.dart';
import 'package:widget_layout_example2/modules/flexible_page.dart';
import 'package:widget_layout_example2/modules/fitted_box_page.dart';
import 'package:widget_layout_example2/modules/floating_action_button_page.dart';
import 'package:widget_layout_example2/modules/fluent_ui_page.dart';
import 'package:widget_layout_example2/modules/focus_traversal_group_page.dart';
import 'package:widget_layout_example2/modules/focusable_action_detector_page.dart';
import 'package:widget_layout_example2/modules/flow_page.dart';
import 'package:widget_layout_example2/modules/fractionally_sized_box_page.dart';
import 'package:widget_layout_example2/modules/flutter_svg_page.dart';
import 'package:widget_layout_example2/modules/flutter_auto_size_text_page.dart';
import 'package:widget_layout_example2/modules/flutter_animate_page.dart';
import 'package:widget_layout_example2/modules/flutter_bloc_page.dart';
import 'package:widget_layout_example2/modules/flutter_card_swiper_page.dart';
import 'package:widget_layout_example2/modules/flutter_custom_tabs_page.dart';
import 'package:widget_layout_example2/modules/flutter_debounce_throttle_page.dart';
import 'package:widget_layout_example2/modules/flutter_dotenv_page.dart';
import 'package:widget_layout_example2/modules/flutter_hooks_page.dart';
import 'package:widget_layout_example2/modules/flutter_inappwebview_page.dart';
import 'package:widget_layout_example2/modules/flutter_local_notifications_page.dart';
import 'package:widget_layout_example2/modules/flutter_screenutil_page.dart';
import 'package:widget_layout_example2/modules/flutter_secure_storage_page.dart';
import 'package:widget_layout_example2/modules/flutter_slidable_page.dart';
import 'package:widget_layout_example2/modules/flutter_timezone_page.dart';
import 'package:widget_layout_example2/modules/flutter_tts_page.dart';
import 'package:widget_layout_example2/modules/flutter_video_caching_fvp_page.dart';
import 'package:widget_layout_example2/modules/fluttertoast_page.dart';
import 'package:widget_layout_example2/modules/freezed_annotation_page.dart';
import 'package:widget_layout_example2/modules/font_awesome_flutter_page.dart';
import 'package:widget_layout_example2/modules/forui_page.dart';
import 'package:widget_layout_example2/modules/form_page.dart';
import 'package:widget_layout_example2/modules/form_field_page.dart';
import 'package:widget_layout_example2/modules/formz_page.dart';
import 'package:widget_layout_example2/modules/future_builder_page.dart';
import 'package:widget_layout_example2/modules/gesturedetector.dart';
import 'package:widget_layout_example2/modules/genui_page.dart';
import 'package:widget_layout_example2/modules/graphql_flutter_page.dart';
import 'package:widget_layout_example2/modules/hero_page.dart';
import 'package:widget_layout_example2/modules/hugeicons_page.dart';
import 'package:widget_layout_example2/modules/iconly_page.dart';
import 'package:widget_layout_example2/modules/image_cropper_page.dart';
import 'package:widget_layout_example2/modules/image_widget_page.dart';
import 'package:widget_layout_example2/modules/ink_widgets_page.dart';
import 'package:widget_layout_example2/modules/injectable_get_it_page.dart';
import 'package:widget_layout_example2/modules/injectable_page.dart';
import 'package:widget_layout_example2/modules/iphone_like_floating_button_page.dart';
import 'package:widget_layout_example2/modules/introduction_screen_page.dart';
import 'package:widget_layout_example2/modules/indexed_stack_page.dart';
import 'package:widget_layout_example2/modules/input_chip_page.dart';
import 'package:widget_layout_example2/modules/infinite_scroll_pagination_page.dart';
import 'package:widget_layout_example2/modules/interactive_card_page.dart';
import 'package:widget_layout_example2/modules/intl_page.dart';
import 'package:widget_layout_example2/modules/jnigen_page.dart';
import 'package:widget_layout_example2/modules/json_annotation_page.dart';
import 'package:widget_layout_example2/modules/keyboard_listener_page.dart';
import 'package:widget_layout_example2/modules/layout_builder_page.dart';
import 'package:widget_layout_example2/modules/linear_progress_indicator_page.dart';
import 'package:widget_layout_example2/modules/local_auth_page.dart';
import 'package:widget_layout_example2/modules/loot_reel_page.dart';
import 'package:widget_layout_example2/modules/lucide_icons_flutter_page.dart';
import 'package:widget_layout_example2/modules/lottie_page.dart';
import 'package:widget_layout_example2/modules/material_color_utilities_page.dart';
import 'package:widget_layout_example2/modules/material_state_property_page.dart';
import 'package:widget_layout_example2/modules/material_symbols_icons_page.dart';
import 'package:widget_layout_example2/modules/macos_ui_page.dart';
import 'package:widget_layout_example2/modules/media_query_page.dart';
import 'package:widget_layout_example2/modules/merge_semantics_page.dart';
import 'package:widget_layout_example2/modules/mouse_region_page.dart';
import 'package:widget_layout_example2/modules/native_device_orientation_communicator_page.dart';
import 'package:widget_layout_example2/modules/native_device_orientation_oriented_widget_page.dart';
import 'package:widget_layout_example2/modules/native_device_orientation_reader_page.dart';
import 'package:widget_layout_example2/modules/open_file_page.dart';
import 'package:widget_layout_example2/modules/onboarding_overlay_page.dart';
import 'package:widget_layout_example2/modules/orientation_builder_page.dart';
import 'package:widget_layout_example2/modules/overlay_menu_page.dart';
import 'package:widget_layout_example2/modules/padding_page.dart';
import 'package:widget_layout_example2/modules/pedantic_mono_page.dart';
import 'package:widget_layout_example2/modules/permission_handler_page.dart';
import 'package:widget_layout_example2/modules/package_info_plus_page.dart';
import 'package:widget_layout_example2/modules/pinput_page.dart';
import 'package:widget_layout_example2/modules/pigeon_page.dart';
import 'package:widget_layout_example2/modules/pop_scope_page.dart';
import 'package:widget_layout_example2/modules/positioned_page.dart';
import 'package:widget_layout_example2/modules/pretty_dio_logger_page.dart';
import 'package:widget_layout_example2/modules/radio_page.dart';
import 'package:widget_layout_example2/modules/responsive_container_page.dart';
import 'package:widget_layout_example2/modules/retrofit_page.dart';
import 'package:widget_layout_example2/modules/rich_text_page.dart';
import 'package:widget_layout_example2/modules/row_expanded_page.dart';
import 'package:widget_layout_example2/modules/rotated_box_page.dart';
import 'package:widget_layout_example2/modules/safe_area_page.dart';
import 'package:widget_layout_example2/modules/scrollbar_page.dart';
import 'package:widget_layout_example2/modules/sensors_plus_page.dart';
import 'package:widget_layout_example2/modules/semantics_page.dart';
import 'package:widget_layout_example2/modules/shadcn_ui_page.dart';
import 'package:widget_layout_example2/modules/shader_graph_page.dart';
import 'package:widget_layout_example2/modules/shared_preferences_page.dart';
import 'package:widget_layout_example2/modules/share_plus_page.dart';
import 'package:widget_layout_example2/modules/show_dialog_page.dart';
import 'package:widget_layout_example2/modules/show_general_dialog_page.dart';
import 'package:widget_layout_example2/modules/shimmer_page.dart';
import 'package:widget_layout_example2/modules/sized_box_page.dart';
import 'package:widget_layout_example2/modules/single_child_scroll_view_page.dart';
import 'package:widget_layout_example2/modules/single_ticker_provider_state_mixin_page.dart';
import 'package:widget_layout_example2/modules/simple_dialog_page.dart';
import 'package:widget_layout_example2/modules/slider_page.dart';
import 'package:widget_layout_example2/modules/sliver_app_bar_page.dart';
import 'package:widget_layout_example2/modules/sliver_examples_page.dart';
import 'package:widget_layout_example2/modules/sliver_grid_page.dart';
import 'package:widget_layout_example2/modules/sliver_list_page.dart';
import 'package:widget_layout_example2/modules/sliver_padding_page.dart';
import 'package:widget_layout_example2/modules/sliver_snap_page.dart';
import 'package:widget_layout_example2/modules/snack_bar_page.dart';
import 'package:widget_layout_example2/modules/smooth_page_indicator_page.dart';
import 'package:widget_layout_example2/modules/speech_to_text_page.dart';
import 'package:widget_layout_example2/modules/spacer_page.dart';
import 'package:widget_layout_example2/modules/stack_page.dart';
import 'package:widget_layout_example2/modules/stream_builder_page.dart';
import 'package:widget_layout_example2/modules/super_clipboard_page.dart';
import 'package:widget_layout_example2/modules/switch_page.dart';
import 'package:widget_layout_example2/modules/syncfusion_flutter_charts_page.dart';
import 'package:widget_layout_example2/modules/table_calendar_page.dart';
import 'package:widget_layout_example2/modules/table_page.dart';
import 'package:widget_layout_example2/modules/tdesign_flutter_page.dart';
import 'package:widget_layout_example2/modules/time_picker_dialog_page.dart';
import 'package:widget_layout_example2/modules/text_field_controller_page.dart';
import 'package:widget_layout_example2/modules/text_rich_page.dart';
import 'package:widget_layout_example2/modules/text_style_page.dart';
import 'package:widget_layout_example2/modules/theme_data_visual_density_page.dart';
import 'package:widget_layout_example2/modules/timeago_flutter_page.dart';
import 'package:widget_layout_example2/modules/time_picker_page.dart';
import 'package:widget_layout_example2/modules/toggle_switch_page.dart';
import 'package:widget_layout_example2/modules/transform_page.dart';
import 'package:widget_layout_example2/modules/tooltip_page.dart';
import 'package:widget_layout_example2/modules/tween_animation_builder_page.dart';
import 'package:widget_layout_example2/modules/tween_page.dart';
import 'package:widget_layout_example2/modules/tween_sequence_interval_page.dart';
import 'package:widget_layout_example2/modules/unconstrained_box_page.dart';
import 'package:widget_layout_example2/modules/url_launcher_page.dart';
import 'package:widget_layout_example2/modules/universal_html_page.dart';
import 'package:widget_layout_example2/modules/wasm_ffi_page.dart';
import 'package:widget_layout_example2/modules/webview_flutter_page.dart';
import 'package:widget_layout_example2/modules/wrap_page.dart';
import 'package:widget_layout_example2/modules/choice_chip_page.dart';
import 'package:widget_layout_example2/modules/sliver_to_box_adapter_page.dart';

part 'app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (demoAuthController.isLoggedIn) {
      resolver.next(true);
      return;
    }

    demoNavigationLog.add('AuthGuard blocked ${resolver.routeName}');
    resolver.redirectUntil(
      AutoRouteLoginRoute(
        onResult: (bool didLogin) {
          demoNavigationLog.add(
            'AuthGuard resume ${resolver.routeName}: $didLogin',
          );
          resolver.resolveNext(didLogin, reevaluateNext: false);
        },
      ),
    );
  }
}

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  late final List<AutoRouteGuard> guards = <AutoRouteGuard>[
    AutoRouteGuard.simple((NavigationResolver resolver, StackRouter router) {
      if (demoAuthController.isLoggedIn ||
          resolver.routeName == LoginRoute.name ||
          resolver.routeName == AutoRouteLoginRoute.name ||
          resolver.routeName == AutoRouteSignupRoute.name) {
        resolver.next();
        return;
      }

      demoNavigationLog.add('global guard blocked ${resolver.routeName}');
      resolver.redirectUntil(
        LoginRoute(
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
    AutoRoute(page: LoginRoute.page, path: AppRoute.login.path),
    AutoRoute(
      page: HomeRoute.page,
      path: AppRoute.home.path,
      children: <AutoRoute>[
        AutoRoute(
          page: LayoutTabRoute.page,
          path: AppRoute.homeLayout.path,
          initial: true,
        ),
        AutoRoute(page: ContentTabRoute.page, path: AppRoute.homeContent.path),
        AutoRoute(
          page: AnimationTabRoute.page,
          path: AppRoute.homeAnimation.path,
        ),
      ],
    ),
    AutoRoute(page: AspectRatioRoute.page, path: AppRoute.aspectRatio.path),
    AutoRoute(page: CenterBoxRoute.page, path: AppRoute.centerBox.path),
    AutoRoute(
      page: ConstrainedBoxRoute.page,
      path: AppRoute.constrainedBox.path,
    ),
    AutoRoute(page: ContainerRoute.page, path: AppRoute.container.path),
    AutoRoute(
      page: UnconstrainedBoxExampleRoute.page,
      path: AppRoute.unconstrainedBox.path,
    ),
    AutoRoute(page: RowExpandedRoute.page, path: AppRoute.rowExpanded.path),
    AutoRoute(page: ExpandedRoute.page, path: AppRoute.expanded.path),
    AutoRoute(page: FlexibleRoute.page, path: AppRoute.flexible.path),
    AutoRoute(
      page: GesturedetectorRoute.page,
      path: AppRoute.gesturedector.path,
    ),
    AutoRoute(page: ColumnRoute.page, path: AppRoute.column.path),
    AutoRoute(page: ColumnSavedRoute.page, path: AppRoute.columnSaved.path),
    AutoRoute(
      page: ColumnSavedStatelessRoute.page,
      path: AppRoute.columnSavedStateless.path,
    ),
    AutoRoute(page: FlowExampleRoute.page, path: AppRoute.flow.path),
    AutoRoute(
      page: FractionallySizedBoxRoute.page,
      path: AppRoute.fractionallySizedBox.path,
    ),
    AutoRoute(
      page: LayoutBuilderExampleRoute.page,
      path: AppRoute.layoutBuilder.path,
    ),
    AutoRoute(
      page: OrientationBuilderRoute.page,
      path: AppRoute.orientationBuilder.path,
    ),
    AutoRoute(page: PaddingRoute.page, path: AppRoute.padding.path),
    AutoRoute(
      page: ResponsiveContainerRoute.page,
      path: AppRoute.responsiveContainer.path,
    ),
    AutoRoute(page: WrapRoute.page, path: AppRoute.wrap.path),
    AutoRoute(page: PositionedRoute.page, path: AppRoute.positioned.path),
    AutoRoute(page: SizedBoxRoute.page, path: AppRoute.sizedBox.path),
    AutoRoute(page: SpacerRoute.page, path: AppRoute.spacer.path),
    AutoRoute(page: StackRoute.page, path: AppRoute.stack.path),
    AutoRoute(page: AlignRoute.page, path: AppRoute.align.path),
    AutoRoute(page: TransformExampleRoute.page, path: AppRoute.transform.path),
    AutoRoute(
      page: RotatedBoxExampleRoute.page,
      path: AppRoute.rotatedBox.path,
    ),
    AutoRoute(page: SafeAreaRoute.page, path: AppRoute.safeArea.path),
    AutoRoute(page: IndexedStackRoute.page, path: AppRoute.indexedStack.path),
    AutoRoute(page: SliverListRoute.page, path: AppRoute.sliverList.path),
    AutoRoute(page: SliverGridRoute.page, path: AppRoute.sliverGrid.path),
    AutoRoute(page: SliverAppBarRoute.page, path: AppRoute.sliverAppBar.path),
    AutoRoute(page: SliverSnapRoute.page, path: AppRoute.sliverSnap.path),
    AutoRoute(
      page: SliverToBoxAdapterRoute.page,
      path: AppRoute.sliverToBoxAdapter.path,
    ),
    AutoRoute(page: SliverPaddingRoute.page, path: AppRoute.sliverPadding.path),
    AutoRoute(page: ClipOvalExampleRoute.page, path: AppRoute.clipOval.path),
    AutoRoute(page: ClipRRectExampleRoute.page, path: AppRoute.clipRRect.path),
    AutoRoute(page: ClipRectExampleRoute.page, path: AppRoute.clipRect.path),
    AutoRoute(page: ClipPathExampleRoute.page, path: AppRoute.clipPath.path),
    AutoRoute(
      page: CustomClipperExampleRoute.page,
      path: AppRoute.customClipper.path,
    ),
    AutoRoute(
      page: CustomMultiChildLayoutRoute.page,
      path: AppRoute.customMultiChildLayout.path,
    ),
    AutoRoute(
      page: CustomScrollViewRoute.page,
      path: AppRoute.customScrollView.path,
    ),
    AutoRoute(page: TableRoute.page, path: AppRoute.table.path),
    AutoRoute(
      page: ButtonShowcaseRoute.page,
      path: AppRoute.classicButtons.path,
    ),
    AutoRoute(page: CascadeRoute.page, path: AppRoute.cascade.path),
    AutoRoute(
      page: CascadeCategoriesRoute.page,
      path: AppRoute.cascadeCategories.path,
    ),
    AutoRoute(
      page: CascadeCategoryDetailsRoute.page,
      path: AppRoute.cascadeCategoryDetails.path,
    ),
    AutoRoute(
      page: CascadeSubcategoryItemsRoute.page,
      path: AppRoute.cascadeSubcategoryItems.path,
    ),
    AutoRoute(
      page: CascadeItemDetailsRoute.page,
      path: AppRoute.cascadeItemDetails.path,
    ),
    AutoRoute(
      page: AutoRouteUsageRoute.page,
      path: AppRoute.autoRouteUsage.path,
    ),
    RedirectRoute(
      path: AppRoute.autoRouteLegacy.path,
      redirectTo: AppRoute.autoRouteBooks.path,
    ),
    AutoRoute(
      page: AutoRouteBooksRoute.page,
      path: AppRoute.autoRouteBooks.path,
    ),
    RedirectRoute(
      path: AppRoute.autoRouteBookLegacy.path,
      redirectTo: AppRoute.autoRouteBookDetails.path,
    ),
    AutoRoute(
      page: AutoRouteBookDetailsRoute.page,
      path: AppRoute.autoRouteBookDetails.path,
    ),
    AutoRoute(
      page: AutoRouteNestedRoute.page,
      path: AppRoute.autoRouteNested.path,
      children: <AutoRoute>[
        AutoRoute(
          page: AutoRouteBooksTabRoute.page,
          path: AppRoute.autoRouteNestedBooks.path,
          initial: true,
        ),
        AutoRoute(
          page: AutoRouteProfileTabRoute.page,
          path: AppRoute.autoRouteNestedProfile.path,
        ),
        AutoRoute(
          page: AutoRouteSettingsTabRoute.page,
          path: AppRoute.autoRouteNestedSettings.path,
        ),
      ],
    ),
    AutoRoute(
      page: AutoRouteProductRoute.page,
      path: AppRoute.autoRouteProduct.path,
      children: <AutoRoute>[
        AutoRoute(
          page: AutoRouteProductOverviewRoute.page,
          path: AppRoute.autoRouteProductOverview.path,
          initial: true,
        ),
        AutoRoute(
          page: AutoRouteProductReviewRoute.page,
          path: AppRoute.autoRouteProductReview.path,
        ),
      ],
    ),
    AutoRoute(
      page: AutoRouteArticleRoute.page,
      path: AppRoute.autoRouteArticle.path,
    ),
    AutoRoute(
      page: AutoRouteProtectedRoute.page,
      path: AppRoute.autoRouteProtected.path,
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
      path: AppRoute.autoRouteGlobalProtected.path,
    ),
    AutoRoute(
      page: ProfileRoute.page,
      path: AppRoute.autoRouteProfile.path,
      guards: <AutoRouteGuard>[AuthGuard()],
    ),
    AutoRoute(
      page: AutoRouteWrappedRoute.page,
      path: AppRoute.autoRouteWrapped.path,
    ),
    AutoRoute(
      page: AutoRouteObserverRoute.page,
      path: AppRoute.autoRouteObserver.path,
    ),
    AutoRoute(
      page: AutoRouteLoginRoute.page,
      path: AppRoute.autoRouteLogin.path,
    ),
    AutoRoute(
      page: AutoRouteSignupRoute.page,
      path: AppRoute.autoRouteSignup.path,
    ),
    AutoRoute(
      page: AutoRouteUnknownRoute.page,
      path: AppRoute.autoRouteUnknown.path,
    ),
    AutoRoute(page: AnimateDoRoute.page, path: AppRoute.animateDo.path),
    AutoRoute(page: IntlRoute.page, path: AppRoute.intl.path),
    AutoRoute(page: JnigenRoute.page, path: AppRoute.jnigen.path),
    AutoRoute(page: CharactersRoute.page, path: AppRoute.characters.path),
    AutoRoute(page: ChatBubblesRoute.page, path: AppRoute.chatBubbles.path),
    AutoRoute(page: ChopperRoute.page, path: AppRoute.chopper.path),
    AutoRoute(page: CookieJarRoute.page, path: AppRoute.cookieJar.path),
    AutoRoute(page: SwitchExampleRoute.page, path: AppRoute.switchExample.path),
    AutoRoute(page: CheckboxExampleRoute.page, path: AppRoute.checkbox.path),
    AutoRoute(page: ClipboardRoute.page, path: AppRoute.clipboard.path),
    AutoRoute(page: RadioExampleRoute.page, path: AppRoute.radio.path),
    AutoRoute(page: InputChipRoute.page, path: AppRoute.inputChip.path),
    AutoRoute(page: ChoiceChipRoute.page, path: AppRoute.choiceChip.path),
    AutoRoute(page: FilterChipRoute.page, path: AppRoute.filterChip.path),
    AutoRoute(page: AboutDialogRoute.page, path: AppRoute.aboutDialog.path),
    AutoRoute(
      page: AdvancedProgressIndicatorRoute.page,
      path: AppRoute.advancedProgressIndicator.path,
    ),
    AutoRoute(
      page: AnimatedListTileRoute.page,
      path: AppRoute.animatedListTile.path,
    ),
    AutoRoute(page: ExtendedImageRoute.page, path: AppRoute.extendedImage.path),
    AutoRoute(
      page: FcNativeVideoThumbnailRoute.page,
      path: AppRoute.fcNativeVideoThumbnail.path,
    ),
    AutoRoute(page: FfigenRoute.page, path: AppRoute.ffigen.path),
    AutoRoute(page: FlashRoute.page, path: AppRoute.flash.path),
    AutoRoute(page: HugeiconsRoute.page, path: AppRoute.hugeicons.path),
    AutoRoute(
      page: FlexColorSchemeRoute.page,
      path: AppRoute.flexColorScheme.path,
    ),
    AutoRoute(
      page: FlexSeedSchemeRoute.page,
      path: AppRoute.flexSeedScheme.path,
    ),
    AutoRoute(page: ActionChipRoute.page, path: AppRoute.actionChip.path),
    AutoRoute(
      page: LinearProgressIndicatorExampleRoute.page,
      path: AppRoute.linearProgressIndicator.path,
    ),
    AutoRoute(page: LocalAuthRoute.page, path: AppRoute.localAuth.path),
    AutoRoute(page: LootReelRoute.page, path: AppRoute.lootReel.path),
    AutoRoute(
      page: LucideIconsFlutterRoute.page,
      path: AppRoute.lucideIconsFlutter.path,
    ),
    AutoRoute(page: LottieRoute.page, path: AppRoute.lottie.path),
    AutoRoute(page: FluentUiRoute.page, path: AppRoute.fluentUi.path),
    AutoRoute(
      page: MaterialColorUtilitiesRoute.page,
      path: AppRoute.materialColorUtilities.path,
    ),
    AutoRoute(
      page: MaterialStatePropertyRoute.page,
      path: AppRoute.materialStateProperty.path,
    ),
    AutoRoute(page: MacosUiRoute.page, path: AppRoute.macosUi.path),
    AutoRoute(
      page: CircularProgressIndicatorExampleRoute.page,
      path: AppRoute.circularProgressIndicator.path,
    ),
    AutoRoute(page: CryptoRoute.page, path: AppRoute.crypto.path),
    AutoRoute(page: CueRoute.page, path: AppRoute.cue.path),
    AutoRoute(page: SliderExampleRoute.page, path: AppRoute.slider.path),
    AutoRoute(page: SensorsPlusRoute.page, path: AppRoute.sensorsPlus.path),
    AutoRoute(page: ShadcnUiRoute.page, path: AppRoute.shadcnUi.path),
    AutoRoute(page: ShaderGraphRoute.page, path: AppRoute.shaderGraph.path),
    AutoRoute(page: DatePickerRoute.page, path: AppRoute.datePicker.path),
    AutoRoute(
      page: DatePickerDialogRoute.page,
      path: AppRoute.datePickerDialog.path,
    ),
    AutoRoute(
      page: TimeagoFlutterRoute.page,
      path: AppRoute.timeagoFlutter.path,
    ),
    AutoRoute(page: TimePickerRoute.page, path: AppRoute.timePicker.path),
    AutoRoute(
      page: TimePickerDialogRoute.page,
      path: AppRoute.timePickerDialog.path,
    ),
    AutoRoute(page: ToggleSwitchRoute.page, path: AppRoute.toggleSwitch.path),
    AutoRoute(page: UrlLauncherRoute.page, path: AppRoute.urlLauncher.path),
    AutoRoute(page: WasmFfiRoute.page, path: AppRoute.wasmFfi.path),
    AutoRoute(
      page: WebviewFlutterRoute.page,
      path: AppRoute.webviewFlutter.path,
    ),
    AutoRoute(page: FormRoute.page, path: AppRoute.form.path),
    AutoRoute(page: FormFieldRoute.page, path: AppRoute.formField.path),
    AutoRoute(page: FormzRoute.page, path: AppRoute.formz.path),
    AutoRoute(page: DraggableExampleRoute.page, path: AppRoute.draggable.path),
    AutoRoute(
      page: DragTargetExampleRoute.page,
      path: AppRoute.dragTarget.path,
    ),
    AutoRoute(
      page: ExpandableSectionRoute.page,
      path: AppRoute.expandableSection.path,
    ),
    AutoRoute(
      page: ExpansionPanelListRoute.page,
      path: AppRoute.expansionPanelList.path,
    ),
    AutoRoute(page: RichTextRoute.page, path: AppRoute.richText.path),
    AutoRoute(
      page: TdesignFlutterRoute.page,
      path: AppRoute.tdesignFlutter.path,
    ),
    AutoRoute(page: TextStyleRoute.page, path: AppRoute.textStyle.path),
    AutoRoute(
      page: ThemeDataVisualDensityRoute.page,
      path: AppRoute.themeDataVisualDensity.path,
    ),
    AutoRoute(
      page: BottomNavigationBarExampleRoute.page,
      path: AppRoute.bottomNavigationBar.path,
    ),
    AutoRoute(page: BinarizeRoute.page, path: AppRoute.binarize.path),
    AutoRoute(
      page: BinarySerializableRoute.page,
      path: AppRoute.binarySerializable.path,
    ),
    AutoRoute(page: BuiltValueRoute.page, path: AppRoute.builtValue.path),
    AutoRoute(
      page: FloatingActionButtonExampleRoute.page,
      path: AppRoute.floatingActionButton.path,
    ),
    AutoRoute(
      page: FocusableActionDetectorRoute.page,
      path: AppRoute.focusableActionDetector.path,
    ),
    AutoRoute(
      page: FocusTraversalGroupRoute.page,
      path: AppRoute.focusTraversalGroup.path,
    ),
    AutoRoute(page: SnackBarExampleRoute.page, path: AppRoute.snackBar.path),
    AutoRoute(
      page: ShowDialogExampleRoute.page,
      path: AppRoute.showDialog.path,
    ),
    AutoRoute(
      page: ShowGeneralDialogRoute.page,
      path: AppRoute.showGeneralDialog.path,
    ),
    AutoRoute(
      page: AlertDialogExampleRoute.page,
      path: AppRoute.alertDialog.path,
    ),
    AutoRoute(
      page: SimpleDialogExampleRoute.page,
      path: AppRoute.simpleDialog.path,
    ),
    AutoRoute(page: DialogExampleRoute.page, path: AppRoute.dialog.path),
    AutoRoute(page: DioRoute.page, path: AppRoute.dio.path),
    AutoRoute(page: DioSmartRetryRoute.page, path: AppRoute.dioSmartRetry.path),
    AutoRoute(page: DioMultiUrlRoute.page, path: AppRoute.dioMultiUrl.path),
    AutoRoute(page: DottedBorderRoute.page, path: AppRoute.dottedBorder.path),
    AutoRoute(page: DrawerRoute.page, path: AppRoute.drawer.path),
    AutoRoute(page: FutureBuilderRoute.page, path: AppRoute.futureBuilder.path),
    AutoRoute(page: GenuiRoute.page, path: AppRoute.genui.path),
    AutoRoute(page: FlutterBlocRoute.page, path: AppRoute.flutterBloc.path),
    AutoRoute(
      page: FlutterCardSwiperRoute.page,
      path: AppRoute.flutterCardSwiper.path,
    ),
    AutoRoute(
      page: FlutterCustomTabsRoute.page,
      path: AppRoute.flutterCustomTabs.path,
    ),
    AutoRoute(
      page: FlutterDebounceThrottleRoute.page,
      path: AppRoute.flutterDebounceThrottle.path,
    ),
    AutoRoute(page: FlutterDotenvRoute.page, path: AppRoute.flutterDotenv.path),
    AutoRoute(page: FlutterHooksRoute.page, path: AppRoute.flutterHooks.path),
    AutoRoute(
      page: FlutterInappwebviewRoute.page,
      path: AppRoute.flutterInappwebview.path,
    ),
    AutoRoute(
      page: InteractiveCardRoute.page,
      path: AppRoute.interactiveCard.path,
    ),
    AutoRoute(page: FlutterTtsRoute.page, path: AppRoute.flutterTts.path),
    AutoRoute(
      page: FreezedAnnotationRoute.page,
      path: AppRoute.freezedAnnotation.path,
    ),
    AutoRoute(
      page: GraphqlFlutterRoute.page,
      path: AppRoute.graphqlFlutter.path,
    ),
    AutoRoute(page: HeroRoute.page, path: AppRoute.hero.path),
    AutoRoute(page: IconlyRoute.page, path: AppRoute.iconly.path),
    AutoRoute(
      page: InjectableGetItRoute.page,
      path: AppRoute.injectableGetIt.path,
    ),
    AutoRoute(page: InjectableRoute.page, path: AppRoute.injectable.path),
    AutoRoute(
      page: IPhoneLikeFloatingButtonRoute.page,
      path: AppRoute.iPhoneLikeFloatingButton.path,
    ),
    AutoRoute(
      page: InfiniteScrollPaginationRoute.page,
      path: AppRoute.infiniteScrollPagination.path,
    ),
    AutoRoute(
      page: IntroductionScreenRoute.page,
      path: AppRoute.introductionScreen.path,
    ),
    AutoRoute(
      page: JsonAnnotationRoute.page,
      path: AppRoute.jsonAnnotation.path,
    ),
    AutoRoute(page: OverlayMenuRoute.page, path: AppRoute.overlayMenu.path),
    AutoRoute(page: StreamBuilderRoute.page, path: AppRoute.streamBuilder.path),
    AutoRoute(page: DriftFlutterRoute.page, path: AppRoute.driftFlutter.path),
    AutoRoute(page: DynamicColorRoute.page, path: AppRoute.dynamicColor.path),
    AutoRoute(page: EncrypterPlusRoute.page, path: AppRoute.encrypterPlus.path),
    AutoRoute(page: FluttertoastRoute.page, path: AppRoute.fluttertoast.path),
    AutoRoute(
      page: KeyboardListenerRoute.page,
      path: AppRoute.keyboardListener.path,
    ),
    AutoRoute(page: InkWidgetsRoute.page, path: AppRoute.inkWidgets.path),
    AutoRoute(page: MediaQueryRoute.page, path: AppRoute.mediaQuery.path),
    AutoRoute(page: MouseRegionRoute.page, path: AppRoute.mouseRegion.path),
    AutoRoute(
      page: NativeDeviceOrientationCommunicatorRoute.page,
      path: AppRoute.nativeDeviceOrientationCommunicator.path,
    ),
    AutoRoute(
      page: NativeDeviceOrientationOrientedWidgetRoute.page,
      path: AppRoute.nativeDeviceOrientationOrientedWidget.path,
    ),
    AutoRoute(
      page: NativeDeviceOrientationReaderRoute.page,
      path: AppRoute.nativeDeviceOrientationReader.path,
    ),
    AutoRoute(page: TextRichRoute.page, path: AppRoute.textRich.path),
    AutoRoute(
      page: SingleChildScrollViewRoute.page,
      path: AppRoute.singleChildScrollView.path,
    ),
    AutoRoute(
      page: SliverExamplesRoute.page,
      path: AppRoute.sliverWidgets.path,
    ),
    AutoRoute(page: ScrollbarRoute.page, path: AppRoute.scrollbar.path),
    AutoRoute(page: FilledButtonRoute.page, path: AppRoute.filledButton.path),
    AutoRoute(page: FittedBoxRoute.page, path: AppRoute.fittedBox.path),
    AutoRoute(page: DecoratedBoxRoute.page, path: AppRoute.decoratedBox.path),
    AutoRoute(
      page: BlockSemanticsRoute.page,
      path: AppRoute.blockSemantics.path,
    ),
    AutoRoute(page: SemanticsRoute.page, path: AppRoute.semantics.path),
    AutoRoute(
      page: ExcludeSemanticsRoute.page,
      path: AppRoute.excludeSemantics.path,
    ),
    AutoRoute(
      page: MergeSemanticsRoute.page,
      path: AppRoute.mergeSemantics.path,
    ),
    AutoRoute(
      page: OnboardingOverlayRoute.page,
      path: AppRoute.onboardingOverlay.path,
    ),
    AutoRoute(page: OpenFileRoute.page, path: AppRoute.openFile.path),
    AutoRoute(page: PedanticMonoRoute.page, path: AppRoute.pedanticMono.path),
    AutoRoute(
      page: PermissionHandlerRoute.page,
      path: AppRoute.permissionHandler.path,
    ),
    AutoRoute(
      page: PackageInfoPlusRoute.page,
      path: AppRoute.packageInfoPlus.path,
    ),
    AutoRoute(page: PinputRoute.page, path: AppRoute.pinput.path),
    AutoRoute(page: PigeonRoute.page, path: AppRoute.pigeon.path),
    AutoRoute(page: PopScopeRoute.page, path: AppRoute.popScope.path),
    AutoRoute(
      page: PrettyDioLoggerRoute.page,
      path: AppRoute.prettyDioLogger.path,
    ),
    AutoRoute(page: SpeechToTextRoute.page, path: AppRoute.speechToText.path),
    AutoRoute(page: ShimmerRoute.page, path: AppRoute.shimmer.path),
    AutoRoute(page: RetrofitRoute.page, path: AppRoute.retrofit.path),
    AutoRoute(
      page: SyncfusionFlutterChartsRoute.page,
      path: AppRoute.syncfusionFlutterCharts.path,
    ),
    AutoRoute(
      page: SmoothPageIndicatorRoute.page,
      path: AppRoute.smoothPageIndicator.path,
    ),
    AutoRoute(
      page: SuperClipboardRoute.page,
      path: AppRoute.superClipboard.path,
    ),
    AutoRoute(
      page: SharedPreferencesRoute.page,
      path: AppRoute.sharedPreferences.path,
    ),
    AutoRoute(page: SharePlusRoute.page, path: AppRoute.sharePlus.path),
    AutoRoute(
      page: TextFieldControllerRoute.page,
      path: AppRoute.textFieldController.path,
    ),
    AutoRoute(
      page: FlutterAutoSizeTextRoute.page,
      path: AppRoute.flutterAutoSizeText.path,
    ),
    AutoRoute(
      page: FlutterAnimateRoute.page,
      path: AppRoute.flutterAnimate.path,
    ),
    AutoRoute(
      page: FlutterLocalNotificationsRoute.page,
      path: AppRoute.flutterLocalNotifications.path,
    ),
    AutoRoute(
      page: FlutterScreenutilRoute.page,
      path: AppRoute.flutterScreenutil.path,
    ),
    AutoRoute(
      page: FlutterSecureStorageRoute.page,
      path: AppRoute.flutterSecureStorage.path,
    ),
    AutoRoute(
      page: FlutterTimezoneRoute.page,
      path: AppRoute.flutterTimezone.path,
    ),
    AutoRoute(page: TooltipRoute.page, path: AppRoute.tooltip.path),
    AutoRoute(
      page: AnimatedTextKitRoute.page,
      path: AppRoute.animatedTextKit.path,
    ),
    AutoRoute(
      page: AnimationsPackageRoute.page,
      path: AppRoute.animationsPackage.path,
    ),
    AutoRoute(page: UniversalHtmlRoute.page, path: AppRoute.universalHtml.path),
    AutoRoute(
      page: FlutterSlidableRoute.page,
      path: AppRoute.flutterSlidable.path,
    ),
    AutoRoute(
      page: FlutterVideoCachingFvpRoute.page,
      path: AppRoute.flutterVideoCachingFvp.path,
    ),
    AutoRoute(
      page: CachedNetworkImageCeRoute.page,
      path: AppRoute.cachedNetworkImageCe.path,
    ),
    AutoRoute(page: DataTableRoute.page, path: AppRoute.dataTable.path),
    AutoRoute(page: FlChartRoute.page, path: AppRoute.flChart.path),
    AutoRoute(
      page: FontAwesomeFlutterRoute.page,
      path: AppRoute.fontAwesomeFlutter.path,
    ),
    AutoRoute(page: ForuiRoute.page, path: AppRoute.forui.path),
    AutoRoute(
      page: MaterialSymbolsIconsRoute.page,
      path: AppRoute.materialSymbolsIcons.path,
    ),
    AutoRoute(page: ImageCropperRoute.page, path: AppRoute.imageCropper.path),
    AutoRoute(page: ImageWidgetRoute.page, path: AppRoute.imageWidget.path),
    AutoRoute(
      page: AnimatedSwitcherRoute.page,
      path: AppRoute.animatedSwitcher.path,
    ),
    AutoRoute(
      page: AnimatedToggleSwitchRoute.page,
      path: AppRoute.animatedToggleSwitch.path,
    ),
    AutoRoute(
      page: AnimatedDefaultTextStyleRoute.page,
      path: AppRoute.animatedDefaultTextStyle.path,
    ),
    AutoRoute(page: CustomPaintRoute.page, path: AppRoute.customPaint.path),
    AutoRoute(
      page: TweenAnimationBuilderRoute.page,
      path: AppRoute.tweenAnimationBuilder.path,
    ),
    AutoRoute(
      page: AnimationControllerRoute.page,
      path: AppRoute.animationController.path,
    ),
    AutoRoute(
      page: SingleTickerProviderStateMixinRoute.page,
      path: AppRoute.singleTickerProviderStateMixin.path,
    ),
    AutoRoute(page: TableCalendarRoute.page, path: AppRoute.tableCalendar.path),
    AutoRoute(page: TweenRoute.page, path: AppRoute.tween.path),
    AutoRoute(
      page: TweenSequenceIntervalRoute.page,
      path: AppRoute.tweenSequenceInterval.path,
    ),
    AutoRoute(page: FlutterSvgRoute.page, path: AppRoute.flutterSvg.path),
  ];
}
