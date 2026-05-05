import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/features/auto_route_demo/presentation/support/auto_route_demo_support.dart';
import 'package:widget_layout_example2/features/auth/auth.dart';
import 'package:widget_layout_example2/home_page.dart';
import 'package:widget_layout_example2/features/about_dialog/presentation/pages/about_dialog_page.dart';
import 'package:widget_layout_example2/features/advanced_progress_indicator/presentation/pages/advanced_progress_indicator_page.dart';
import 'package:widget_layout_example2/features/align/presentation/pages/align_page.dart';
import 'package:widget_layout_example2/features/animated_default_text_style/presentation/pages/animated_default_text_style_page.dart';
import 'package:widget_layout_example2/features/animated_list_tile/presentation/pages/animated_list_tile_page.dart';
import 'package:widget_layout_example2/features/animated_text_kit/presentation/pages/animated_text_kit_page.dart';
import 'package:widget_layout_example2/features/animated_switcher/presentation/pages/animated_switcher_page.dart';
import 'package:widget_layout_example2/features/animated_toggle_switch/presentation/pages/animated_toggle_switch_page.dart';
import 'package:widget_layout_example2/features/animation_controller/presentation/pages/animation_controller_page.dart';
import 'package:widget_layout_example2/features/animations/presentation/pages/animations_page.dart';
import 'package:widget_layout_example2/features/alert_dialog/presentation/pages/alert_dialog_page.dart';
import 'package:widget_layout_example2/features/auto_route_demo/presentation/pages/auto_route_usage_page.dart';
import 'package:widget_layout_example2/features/action_chip/presentation/pages/action_chip_page.dart';
import 'package:widget_layout_example2/features/animate_do/presentation/pages/animate_do_page.dart';
import 'package:widget_layout_example2/features/aspect_ratio/presentation/pages/aspect_ratio_page.dart';
import 'package:widget_layout_example2/features/block_semantics/presentation/pages/block_semantics_page.dart';
import 'package:widget_layout_example2/features/binarize/presentation/pages/binarize_page.dart';
import 'package:widget_layout_example2/features/binary_serializable/presentation/pages/binary_serializable_page.dart';
import 'package:widget_layout_example2/features/center_box/presentation/pages/center_box_page.dart';
import 'package:widget_layout_example2/features/cached_network_image_ce/presentation/pages/cached_network_image_ce_page.dart';
import 'package:widget_layout_example2/features/characters/presentation/pages/characters_page.dart';
import 'package:widget_layout_example2/features/chat_bubbles/presentation/pages/chat_bubbles_page.dart';
import 'package:widget_layout_example2/features/chopper/presentation/pages/chopper_page.dart';
import 'package:widget_layout_example2/features/cookie_jar/presentation/pages/cookie_jar_page.dart';
import 'package:widget_layout_example2/features/clipboard/presentation/pages/clipboard_page.dart';
import 'package:widget_layout_example2/features/checkbox/presentation/pages/checkbox_page.dart';
import 'package:widget_layout_example2/features/button_showcase/presentation/pages/button_showcase_page.dart';
import 'package:widget_layout_example2/features/bottom_navigation_bar/presentation/pages/bottom_navigation_bar_page.dart';
import 'package:widget_layout_example2/features/built_value/presentation/pages/built_value_page.dart';
import 'package:widget_layout_example2/features/cascade_route/presentation/pages/cascade_route_page.dart';
import 'package:widget_layout_example2/features/circular_progress_indicator/presentation/pages/circular_progress_indicator_page.dart';
import 'package:widget_layout_example2/features/clip_oval/presentation/pages/clip_oval_page.dart';
import 'package:widget_layout_example2/features/clip_path/presentation/pages/clip_path_page.dart';
import 'package:widget_layout_example2/features/clip_r_rect/presentation/pages/clip_r_rect_page.dart';
import 'package:widget_layout_example2/features/clip_rect/presentation/pages/clip_rect_page.dart';
import 'package:widget_layout_example2/features/column/presentation/pages/column_page.dart';
import 'package:widget_layout_example2/features/column_saved/presentation/pages/column_saved_page.dart';
import 'package:widget_layout_example2/features/column_saved_stateless/presentation/pages/column_saved_stateless_page.dart';
import 'package:widget_layout_example2/features/constrained_box/presentation/pages/constrained_box_page.dart';
import 'package:widget_layout_example2/features/container/presentation/pages/container_page.dart';
import 'package:widget_layout_example2/features/custom_clipper/presentation/pages/custom_clipper_page.dart';
import 'package:widget_layout_example2/features/custom_multi_child_layout/presentation/pages/custom_multi_child_layout_page.dart';
import 'package:widget_layout_example2/features/custom_multi_child_layout_vs_layout_builder/presentation/pages/custom_multi_child_layout_vs_layout_builder_page.dart';
import 'package:widget_layout_example2/features/custom_scroll_view/presentation/pages/custom_scroll_view_page.dart';
import 'package:widget_layout_example2/features/custom_paint/presentation/pages/custom_paint_page.dart';
import 'package:widget_layout_example2/features/crypto/presentation/pages/crypto_page.dart';
import 'package:widget_layout_example2/features/cue/presentation/pages/cue_page.dart';
import 'package:widget_layout_example2/features/dash_chat_3/presentation/pages/dash_chat_3_page.dart';
import 'package:widget_layout_example2/features/data_table/presentation/pages/data_table_page.dart';
import 'package:widget_layout_example2/features/desktop_multi_window/presentation/pages/desktop_multi_window_page.dart';
import 'package:widget_layout_example2/features/date_picker_dialog/presentation/pages/date_picker_dialog_page.dart';
import 'package:widget_layout_example2/features/decorated_box/presentation/pages/decorated_box_page.dart';
import 'package:widget_layout_example2/features/dialog/presentation/pages/dialog_page.dart';
import 'package:widget_layout_example2/features/dio/presentation/pages/dio_page.dart';
import 'package:widget_layout_example2/features/dio_cookie_manager/presentation/pages/dio_cookie_manager_page.dart';
import 'package:widget_layout_example2/features/dio_smart_retry/presentation/pages/dio_smart_retry_page.dart';
import 'package:widget_layout_example2/features/dio_multi_url/presentation/pages/dio_multi_url_page.dart';
import 'package:widget_layout_example2/features/dotted_border/presentation/pages/dotted_border_page.dart';
import 'package:widget_layout_example2/features/drawer/presentation/pages/drawer_page.dart';
import 'package:widget_layout_example2/features/draggable/presentation/pages/draggable_page.dart';
import 'package:widget_layout_example2/features/drag_target/presentation/pages/drag_target_page.dart';
import 'package:widget_layout_example2/features/drift_flutter/presentation/pages/drift_flutter_page.dart';
import 'package:widget_layout_example2/features/dynamic_color/presentation/pages/dynamic_color_page.dart';
import 'package:widget_layout_example2/features/encrypter_plus/presentation/pages/encrypter_plus_page.dart';
import 'package:widget_layout_example2/features/extended_image/presentation/pages/extended_image_page.dart';
import 'package:widget_layout_example2/features/expandable_section/presentation/pages/expandable_section_page.dart';
import 'package:widget_layout_example2/features/expansion_panel_list/presentation/pages/expansion_panel_list_page.dart';
import 'package:widget_layout_example2/features/expanded/presentation/pages/expanded_page.dart';
import 'package:widget_layout_example2/features/expanded_vs_flexible/presentation/pages/expanded_vs_flexible_page.dart';
import 'package:widget_layout_example2/features/date_picker/presentation/pages/date_picker_page.dart';
import 'package:widget_layout_example2/features/exclude_semantics/presentation/pages/exclude_semantics_page.dart';
import 'package:widget_layout_example2/features/fc_native_video_thumbnail/presentation/pages/fc_native_video_thumbnail_page.dart';
import 'package:widget_layout_example2/features/ffigen/presentation/pages/ffigen_page.dart';
import 'package:widget_layout_example2/features/flash/presentation/pages/flash_page.dart';
import 'package:widget_layout_example2/features/filled_button/presentation/pages/filled_button_page.dart';
import 'package:widget_layout_example2/features/fixed_left_panel/presentation/pages/fixed_left_panel_page.dart';
import 'package:widget_layout_example2/features/filter_chip/presentation/pages/filter_chip_page.dart';
import 'package:widget_layout_example2/features/fl_chart/presentation/pages/fl_chart_page.dart';
import 'package:widget_layout_example2/features/flex_color_scheme/presentation/pages/flex_color_scheme_page.dart';
import 'package:widget_layout_example2/features/flex_seed_scheme/presentation/pages/flex_seed_scheme_page.dart';
import 'package:widget_layout_example2/features/flexible/presentation/pages/flexible_page.dart';
import 'package:widget_layout_example2/features/fitted_box/presentation/pages/fitted_box_page.dart';
import 'package:widget_layout_example2/features/floating_action_button/presentation/pages/floating_action_button_page.dart';
import 'package:widget_layout_example2/features/fluent_ui/presentation/pages/fluent_ui_page.dart';
import 'package:widget_layout_example2/features/focus_traversal_group/presentation/pages/focus_traversal_group_page.dart';
import 'package:widget_layout_example2/features/focusable_action_detector/presentation/pages/focusable_action_detector_page.dart';
import 'package:widget_layout_example2/features/flow/presentation/pages/flow_page.dart';
import 'package:widget_layout_example2/features/fractionally_sized_box/presentation/pages/fractionally_sized_box_page.dart';
import 'package:widget_layout_example2/features/flutter_svg/presentation/pages/flutter_svg_page.dart';
import 'package:widget_layout_example2/features/flutter_auto_size_text/presentation/pages/flutter_auto_size_text_page.dart';
import 'package:widget_layout_example2/features/flutter_animate/presentation/pages/flutter_animate_page.dart';
import 'package:widget_layout_example2/features/flutter_bloc/presentation/pages/flutter_bloc_page.dart';
import 'package:widget_layout_example2/features/flutter_bloc_event_bus/presentation/pages/flutter_bloc_event_bus_page.dart';
import 'package:widget_layout_example2/features/flutter_card_swiper/presentation/pages/flutter_card_swiper_page.dart';
import 'package:widget_layout_example2/features/flutter_chat_ui/presentation/pages/flutter_chat_ui_page.dart';
import 'package:widget_layout_example2/features/flutter_custom_tabs/presentation/pages/flutter_custom_tabs_page.dart';
import 'package:widget_layout_example2/features/flutter_debounce_throttle/presentation/pages/flutter_debounce_throttle_page.dart';
import 'package:widget_layout_example2/features/flutter_dotenv/presentation/pages/flutter_dotenv_page.dart';
import 'package:widget_layout_example2/features/flutter_gen_ai_chat_ui/presentation/pages/flutter_gen_ai_chat_ui_page.dart';
import 'package:widget_layout_example2/features/flutter_hooks/presentation/pages/flutter_hooks_page.dart';
import 'package:widget_layout_example2/features/flutter_inappwebview/presentation/pages/flutter_inappwebview_page.dart';
import 'package:widget_layout_example2/features/flutter_markdown_plus/presentation/pages/flutter_markdown_plus_page.dart';
import 'package:widget_layout_example2/features/flutter_local_notifications/presentation/pages/flutter_local_notifications_page.dart';
import 'package:widget_layout_example2/features/flutter_screenutil/presentation/pages/flutter_screenutil_page.dart';
import 'package:widget_layout_example2/features/flutter_secure_storage/presentation/pages/flutter_secure_storage_page.dart';
import 'package:widget_layout_example2/features/flutter_slidable/presentation/pages/flutter_slidable_page.dart';
import 'package:widget_layout_example2/features/flutter_timezone/presentation/pages/flutter_timezone_page.dart';
import 'package:widget_layout_example2/features/flutter_tts/presentation/pages/flutter_tts_page.dart';
import 'package:widget_layout_example2/features/flutter_video_caching_fvp/presentation/pages/flutter_video_caching_fvp_page.dart';
import 'package:widget_layout_example2/features/fluttertoast/presentation/pages/fluttertoast_page.dart';
import 'package:widget_layout_example2/features/freezed_annotation/presentation/pages/freezed_annotation_page.dart';
import 'package:widget_layout_example2/features/font_awesome_flutter/presentation/pages/font_awesome_flutter_page.dart';
import 'package:widget_layout_example2/features/forui/presentation/pages/forui_page.dart';
import 'package:widget_layout_example2/features/form/presentation/pages/form_page.dart';
import 'package:widget_layout_example2/features/form_field/presentation/pages/form_field_page.dart';
import 'package:widget_layout_example2/features/formz/presentation/pages/formz_page.dart';
import 'package:widget_layout_example2/features/future_builder/presentation/pages/future_builder_page.dart';
import 'package:widget_layout_example2/features/gal/presentation/pages/gal_page.dart';
import 'package:widget_layout_example2/features/gesturedetector/presentation/pages/gesturedetector.dart';
import 'package:widget_layout_example2/features/genui/presentation/pages/genui_page.dart';
import 'package:widget_layout_example2/features/graphql_flutter/presentation/pages/graphql_flutter_page.dart';
import 'package:widget_layout_example2/features/hero/presentation/pages/hero_page.dart';
import 'package:widget_layout_example2/features/hugeicons/presentation/pages/hugeicons_page.dart';
import 'package:widget_layout_example2/features/iconly/presentation/pages/iconly_page.dart';
import 'package:widget_layout_example2/features/image_cropper/presentation/pages/image_cropper_page.dart';
import 'package:widget_layout_example2/features/image_widget/presentation/pages/image_widget_page.dart';
import 'package:widget_layout_example2/features/ink_widgets/presentation/pages/ink_widgets_page.dart';
import 'package:widget_layout_example2/features/injectable_get_it/presentation/pages/injectable_get_it_page.dart';
import 'package:widget_layout_example2/features/injectable/presentation/pages/injectable_page.dart';
import 'package:widget_layout_example2/features/iphone_like_floating_button/presentation/pages/iphone_like_floating_button_page.dart';
import 'package:widget_layout_example2/features/introduction_screen/presentation/pages/introduction_screen_page.dart';
import 'package:widget_layout_example2/features/indexed_stack/presentation/pages/indexed_stack_page.dart';
import 'package:widget_layout_example2/features/input_chip/presentation/pages/input_chip_page.dart';
import 'package:widget_layout_example2/features/infinite_scroll_pagination/presentation/pages/infinite_scroll_pagination_page.dart';
import 'package:widget_layout_example2/features/interactive_card/presentation/pages/interactive_card_page.dart';
import 'package:widget_layout_example2/features/intl/presentation/pages/intl_page.dart';
import 'package:widget_layout_example2/features/jnigen/presentation/pages/jnigen_page.dart';
import 'package:widget_layout_example2/features/json_annotation/presentation/pages/json_annotation_page.dart';
import 'package:widget_layout_example2/features/keyboard_listener/presentation/pages/keyboard_listener_page.dart';
import 'package:widget_layout_example2/features/layout_builder/presentation/pages/layout_builder_page.dart';
import 'package:widget_layout_example2/features/layout_builder_vs_stack/presentation/pages/layout_builder_vs_stack_page.dart';
import 'package:widget_layout_example2/features/linear_progress_indicator/presentation/pages/linear_progress_indicator_page.dart';
import 'package:widget_layout_example2/features/local_auth/presentation/pages/local_auth_page.dart';
import 'package:widget_layout_example2/features/loot_reel/presentation/pages/loot_reel_page.dart';
import 'package:widget_layout_example2/features/lucide_icons_flutter/presentation/pages/lucide_icons_flutter_page.dart';
import 'package:widget_layout_example2/features/lottie/presentation/pages/lottie_page.dart';
import 'package:widget_layout_example2/features/material_color_utilities/presentation/pages/material_color_utilities_page.dart';
import 'package:widget_layout_example2/features/material_state_property/presentation/pages/material_state_property_page.dart';
import 'package:widget_layout_example2/features/material_symbols_icons/presentation/pages/material_symbols_icons_page.dart';
import 'package:widget_layout_example2/features/macos_ui/presentation/pages/macos_ui_page.dart';
import 'package:widget_layout_example2/features/media_query/presentation/pages/media_query_page.dart';
import 'package:widget_layout_example2/features/merge_semantics/presentation/pages/merge_semantics_page.dart';
import 'package:widget_layout_example2/features/mouse_region/presentation/pages/mouse_region_page.dart';
import 'package:widget_layout_example2/features/native_device_orientation/presentation/pages/native_device_orientation_communicator_page.dart';
import 'package:widget_layout_example2/features/native_device_orientation/presentation/pages/native_device_orientation_oriented_widget_page.dart';
import 'package:widget_layout_example2/features/native_device_orientation/presentation/pages/native_device_orientation_reader_page.dart';
import 'package:widget_layout_example2/features/nested_scroll_view/presentation/pages/nested_scroll_view_page.dart';
import 'package:widget_layout_example2/features/custom_scroll_view_split/presentation/pages/custom_scroll_view_split_page.dart';
import 'package:widget_layout_example2/features/nested_scroll_view_split/presentation/pages/nested_scroll_view_split_page.dart';
import 'package:widget_layout_example2/features/open_file/presentation/pages/open_file_page.dart';
import 'package:widget_layout_example2/features/onboarding_overlay/presentation/pages/onboarding_overlay_page.dart';
import 'package:widget_layout_example2/features/orientation_builder/presentation/pages/orientation_builder_page.dart';
import 'package:widget_layout_example2/features/overlay_menu/presentation/pages/overlay_menu_page.dart';
import 'package:widget_layout_example2/features/padding/presentation/pages/padding_page.dart';
import 'package:widget_layout_example2/features/pedantic_mono/presentation/pages/pedantic_mono_page.dart';
import 'package:widget_layout_example2/features/percent_indicator/presentation/pages/percent_indicator_page.dart';
import 'package:widget_layout_example2/features/photo_view/presentation/pages/photo_view_page.dart';
import 'package:widget_layout_example2/features/permission_handler/presentation/pages/permission_handler_page.dart';
import 'package:widget_layout_example2/features/package_info_plus/presentation/pages/package_info_plus_page.dart';
import 'package:widget_layout_example2/features/page_view/presentation/pages/page_view_page.dart';
import 'package:widget_layout_example2/features/pinput/presentation/pages/pinput_page.dart';
import 'package:widget_layout_example2/features/pigeon/presentation/pages/pigeon_page.dart';
import 'package:widget_layout_example2/features/pop_scope/presentation/pages/pop_scope_page.dart';
import 'package:widget_layout_example2/features/positioned/presentation/pages/positioned_page.dart';
import 'package:widget_layout_example2/features/pretty_dio_logger/presentation/pages/pretty_dio_logger_page.dart';
import 'package:widget_layout_example2/features/flutter_link_previewer/presentation/pages/flutter_link_previewer_page.dart';
import 'package:widget_layout_example2/features/pull_down_button/presentation/pages/pull_down_button_page.dart';
import 'package:widget_layout_example2/features/radio/presentation/pages/radio_page.dart';
import 'package:widget_layout_example2/features/responsive_container/presentation/pages/responsive_container_page.dart';
import 'package:widget_layout_example2/features/retrofit/presentation/pages/retrofit_page.dart';
import 'package:widget_layout_example2/features/rich_text/presentation/pages/rich_text_page.dart';
import 'package:widget_layout_example2/features/rive/presentation/pages/rive_page.dart';
import 'package:widget_layout_example2/features/row_expanded/presentation/pages/row_expanded_page.dart';
import 'package:widget_layout_example2/features/rotated_box/presentation/pages/rotated_box_page.dart';
import 'package:widget_layout_example2/features/safe_area/presentation/pages/safe_area_page.dart';
import 'package:widget_layout_example2/features/scrollbar/presentation/pages/scrollbar_page.dart';
import 'package:widget_layout_example2/features/scaffold_demo/presentation/pages/scaffold_demo_page.dart';
import 'package:widget_layout_example2/features/sensors_plus/presentation/pages/sensors_plus_page.dart';
import 'package:widget_layout_example2/features/semantics/presentation/pages/semantics_page.dart';
import 'package:widget_layout_example2/features/shadcn_ui/presentation/pages/shadcn_ui_page.dart';
import 'package:widget_layout_example2/features/shader_graph/presentation/pages/shader_graph_page.dart';
import 'package:widget_layout_example2/features/shared_preferences/presentation/pages/shared_preferences_page.dart';
import 'package:widget_layout_example2/features/share_plus/presentation/pages/share_plus_page.dart';
import 'package:widget_layout_example2/features/show_dialog/presentation/pages/show_dialog_page.dart';
import 'package:widget_layout_example2/features/show_general_dialog/presentation/pages/show_general_dialog_page.dart';
import 'package:widget_layout_example2/features/shimmer/presentation/pages/shimmer_page.dart';
import 'package:widget_layout_example2/features/sized_box/presentation/pages/sized_box_page.dart';
import 'package:widget_layout_example2/features/single_child_scroll_view/presentation/pages/single_child_scroll_view_page.dart';
import 'package:widget_layout_example2/features/single_ticker_provider_state_mixin/presentation/pages/single_ticker_provider_state_mixin_page.dart';
import 'package:widget_layout_example2/features/simple_dialog/presentation/pages/simple_dialog_page.dart';
import 'package:widget_layout_example2/features/slider/presentation/pages/slider_page.dart';
import 'package:widget_layout_example2/features/sliver_app_bar/presentation/pages/sliver_app_bar_page.dart';
import 'package:widget_layout_example2/features/sliver_examples/presentation/pages/sliver_examples_page.dart';
import 'package:widget_layout_example2/features/sliver_grid/presentation/pages/sliver_grid_page.dart';
import 'package:widget_layout_example2/features/sliver_list/presentation/pages/sliver_list_page.dart';
import 'package:widget_layout_example2/features/sliver_padding/presentation/pages/sliver_padding_page.dart';
import 'package:widget_layout_example2/features/sliver_snap/presentation/pages/sliver_snap_page.dart';
import 'package:widget_layout_example2/features/snack_bar/presentation/pages/snack_bar_page.dart';
import 'package:widget_layout_example2/features/smooth_page_indicator/presentation/pages/smooth_page_indicator_page.dart';
import 'package:widget_layout_example2/features/speech_to_text/presentation/pages/speech_to_text_page.dart';
import 'package:widget_layout_example2/features/spacer/presentation/pages/spacer_page.dart';
import 'package:widget_layout_example2/features/stack/presentation/pages/stack_page.dart';
import 'package:widget_layout_example2/features/stream_builder/presentation/pages/stream_builder_page.dart';
import 'package:widget_layout_example2/features/super_clipboard/presentation/pages/super_clipboard_page.dart';
import 'package:widget_layout_example2/features/switch/presentation/pages/switch_page.dart';
import 'package:widget_layout_example2/features/syncfusion_flutter_charts/presentation/pages/syncfusion_flutter_charts_page.dart';
import 'package:widget_layout_example2/features/table_calendar/presentation/pages/table_calendar_page.dart';
import 'package:widget_layout_example2/features/table/presentation/pages/table_page.dart';
import 'package:widget_layout_example2/features/tab_bar_view/presentation/pages/tab_bar_view_page.dart';
import 'package:widget_layout_example2/features/tdesign_flutter/presentation/pages/tdesign_flutter_page.dart';
import 'package:widget_layout_example2/features/time_picker_dialog/presentation/pages/time_picker_dialog_page.dart';
import 'package:widget_layout_example2/features/text_field_controller/presentation/pages/text_field_controller_page.dart';
import 'package:widget_layout_example2/features/text_field_controller/presentation/pages/text_field_controller_jaspr_page.dart';
import 'package:widget_layout_example2/features/text_rich/presentation/pages/text_rich_page.dart';
import 'package:widget_layout_example2/features/text_style/presentation/pages/text_style_page.dart';
import 'package:widget_layout_example2/features/theme_data_visual_density/presentation/pages/theme_data_visual_density_page.dart';
import 'package:widget_layout_example2/features/timeago_flutter/presentation/pages/timeago_flutter_page.dart';
import 'package:widget_layout_example2/features/time_picker/presentation/pages/time_picker_page.dart';
import 'package:widget_layout_example2/features/toggle_switch/presentation/pages/toggle_switch_page.dart';
import 'package:widget_layout_example2/features/transform/presentation/pages/transform_page.dart';
import 'package:widget_layout_example2/features/tooltip/presentation/pages/tooltip_page.dart';
import 'package:widget_layout_example2/features/tween_animation_builder/presentation/pages/tween_animation_builder_page.dart';
import 'package:widget_layout_example2/features/tween/presentation/pages/tween_page.dart';
import 'package:widget_layout_example2/features/tween_sequence_interval/presentation/pages/tween_sequence_interval_page.dart';
import 'package:widget_layout_example2/features/unconstrained_box/presentation/pages/unconstrained_box_page.dart';
import 'package:widget_layout_example2/features/url_launcher/presentation/pages/url_launcher_page.dart';
import 'package:widget_layout_example2/features/universal_html/presentation/pages/universal_html_page.dart';
import 'package:widget_layout_example2/features/wasm_ffi/presentation/pages/wasm_ffi_page.dart';
import 'package:widget_layout_example2/features/webview_flutter/presentation/pages/webview_flutter_page.dart';
import 'package:widget_layout_example2/features/wrap/presentation/pages/wrap_page.dart';
import 'package:widget_layout_example2/features/choice_chip/presentation/pages/choice_chip_page.dart';
import 'package:widget_layout_example2/features/divider/presentation/pages/divider_page.dart';
import 'package:widget_layout_example2/features/mobile_scanner/presentation/pages/mobile_scanner_page.dart';
import 'package:widget_layout_example2/features/placeholder/presentation/pages/placeholder_page.dart';
import 'package:widget_layout_example2/features/sliver_to_box_adapter/presentation/pages/sliver_to_box_adapter_page.dart';
import 'package:widget_layout_example2/features/vector_math/presentation/pages/vector_math_page.dart';

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
          resolver.routeName == SignUpRoute.name ||
          resolver.routeName == AutoRouteLoginRoute.name) {
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
    AutoRoute(page: SignUpRoute.page, path: AppRoute.signUp.path),
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
    AutoRoute(page: RiveRoute.page, path: AppRoute.rive.path),
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
    AutoRoute(
      page: DioCookieManagerRoute.page,
      path: AppRoute.dioCookieManager.path,
    ),
    AutoRoute(page: DioSmartRetryRoute.page, path: AppRoute.dioSmartRetry.path),
    AutoRoute(page: DioMultiUrlRoute.page, path: AppRoute.dioMultiUrl.path),
    AutoRoute(page: DottedBorderRoute.page, path: AppRoute.dottedBorder.path),
    AutoRoute(page: DrawerRoute.page, path: AppRoute.drawer.path),
    AutoRoute(page: FutureBuilderRoute.page, path: AppRoute.futureBuilder.path),
    AutoRoute(page: GenuiRoute.page, path: AppRoute.genui.path),
    AutoRoute(page: FlutterBlocRoute.page, path: AppRoute.flutterBloc.path),
    AutoRoute(
      page: FlutterBlocEventBusRoute.page,
      path: AppRoute.flutterBlocEventBus.path,
    ),
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
    AutoRoute(
      page: NestedScrollViewRoute.page,
      path: AppRoute.nestedScrollView.path,
    ),
    AutoRoute(
      page: NestedScrollViewSplitRoute.page,
      path: AppRoute.nestedScrollViewSplit.path,
    ),
    AutoRoute(
      page: CustomScrollViewSplitRoute.page,
      path: AppRoute.customScrollViewSplit.path,
    ),
    AutoRoute(
      page: FixedLeftPanelRoute.page,
      path: AppRoute.fixedLeftPanel.path,
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
      page: PercentIndicatorRoute.page,
      path: AppRoute.percentIndicator.path,
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
    AutoRoute(page: ScaffoldDemoRoute.page, path: AppRoute.scaffoldDemo.path),
    AutoRoute(page: DashChat3Route.page, path: AppRoute.dashChat3.path),
    AutoRoute(page: FlutterChatUiRoute.page, path: AppRoute.flutterChatUi.path),
    AutoRoute(
      page: FlutterGenAiChatUiRoute.page,
      path: AppRoute.flutterGenAiChatUi.path,
    ),
    AutoRoute(page: GalRoute.page, path: AppRoute.gal.path),
    AutoRoute(page: PhotoViewRoute.page, path: AppRoute.photoView.path),
    AutoRoute(
      page: FlutterMarkdownPlusRoute.page,
      path: AppRoute.flutterMarkdownPlus.path,
    ),
    AutoRoute(
      page: FlutterLinkPreviewerRoute.page,
      path: AppRoute.flutterLinkPreviewer.path,
    ),
    AutoRoute(
      page: PullDownButtonRoute.page,
      path: AppRoute.pullDownButton.path,
    ),
    AutoRoute(page: PageViewRoute.page, path: AppRoute.pageView.path),
    AutoRoute(page: TabBarViewRoute.page, path: AppRoute.tabBarView.path),
    AutoRoute(
      page: TextFieldControllerRoute.page,
      path: AppRoute.textFieldController.path,
    ),
    AutoRoute(
      page: TextFieldControllerJasprRoute.page,
      path: AppRoute.textFieldControllerJaspr.path,
    ),
    AutoRoute(
      page: CustomMultiChildLayoutVsLayoutBuilderRoute.page,
      path: AppRoute.customMultiChildLayoutVsLayoutBuilder.path,
    ),
    AutoRoute(
      page: ExpandedVsFlexibleRoute.page,
      path: AppRoute.expandedVsFlexible.path,
    ),
    AutoRoute(
      page: LayoutBuilderVsStackRoute.page,
      path: AppRoute.layoutBuilderVsStack.path,
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
    AutoRoute(
      page: DesktopMultiWindowRoute.page,
      path: AppRoute.desktopMultiWindow.path,
    ),
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
    AutoRoute(page: DividerRoute.page, path: AppRoute.divider.path),
    AutoRoute(
      page: PlaceholderExampleRoute.page,
      path: AppRoute.placeholder.path,
    ),
    AutoRoute(page: VectorMathRoute.page, path: AppRoute.vectorMath.path),
    AutoRoute(page: MobileScannerRoute.page, path: AppRoute.mobileScanner.path),
  ];
}
