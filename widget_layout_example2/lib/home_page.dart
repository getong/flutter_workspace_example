import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/auto_route_demo_support.dart';

final List<_ModuleLink> _layoutModules = <_ModuleLink>[
  _ModuleLink(label: 'Align Module', routePath: AppRoute.align.path),
  _ModuleLink(
    label: 'AspectRatio Module',
    routePath: AppRoute.aspectRatio.path,
  ),
  _ModuleLink(label: 'Center Box Module', routePath: AppRoute.centerBox.path),
  _ModuleLink(
    label: 'Classic Buttons Module',
    routePath: AppRoute.classicButtons.path,
  ),
  _ModuleLink(label: 'ClipOval Module', routePath: AppRoute.clipOval.path),
  _ModuleLink(label: 'ClipPath Module', routePath: AppRoute.clipPath.path),
  _ModuleLink(label: 'ClipRect Module', routePath: AppRoute.clipRect.path),
  _ModuleLink(label: 'ClipRRect Module', routePath: AppRoute.clipRRect.path),
  _ModuleLink(label: 'Column Module', routePath: AppRoute.column.path),
  _ModuleLink(
    label: 'Column Saved Module',
    routePath: AppRoute.columnSaved.path,
  ),
  _ModuleLink(
    label: 'Column Saved Stateless Module',
    routePath: AppRoute.columnSavedStateless.path,
  ),
  _ModuleLink(
    label: 'Constrained Box Module',
    routePath: AppRoute.constrainedBox.path,
  ),
  _ModuleLink(label: 'Container Module', routePath: AppRoute.container.path),
  _ModuleLink(
    label: 'CustomClipper Module',
    routePath: AppRoute.customClipper.path,
  ),
  _ModuleLink(
    label: 'CustomMultiChildLayout Module',
    routePath: AppRoute.customMultiChildLayout.path,
  ),
  _ModuleLink(
    label: 'DecoratedBox Module',
    routePath: AppRoute.decoratedBox.path,
  ),
  _ModuleLink(label: 'Expanded Module', routePath: AppRoute.expanded.path),
  _ModuleLink(
    label: 'FilledButton Module',
    routePath: AppRoute.filledButton.path,
  ),
  _ModuleLink(label: 'FittedBox Module', routePath: AppRoute.fittedBox.path),
  _ModuleLink(label: 'Flexible Module', routePath: AppRoute.flexible.path),
  _ModuleLink(label: 'Flow Module', routePath: AppRoute.flow.path),
  _ModuleLink(
    label: 'FractionallySizedBox Module',
    routePath: AppRoute.fractionallySizedBox.path,
  ),
  _ModuleLink(
    label: 'gesturedector Module',
    routePath: AppRoute.gesturedector.path,
  ),
  _ModuleLink(
    label: 'IndexedStack Module',
    routePath: AppRoute.indexedStack.path,
  ),
  _ModuleLink(
    label: 'LayoutBuilder Module',
    routePath: AppRoute.layoutBuilder.path,
  ),
  _ModuleLink(label: 'MediaQuery Module', routePath: AppRoute.mediaQuery.path),
  _ModuleLink(
    label: 'OrientationBuilder Module',
    routePath: AppRoute.orientationBuilder.path,
  ),
  _ModuleLink(label: 'Padding Module', routePath: AppRoute.padding.path),
  _ModuleLink(label: 'Positioned Module', routePath: AppRoute.positioned.path),
  _ModuleLink(
    label: 'ResponsiveContainer Module',
    routePath: AppRoute.responsiveContainer.path,
  ),
  _ModuleLink(label: 'RotatedBox Module', routePath: AppRoute.rotatedBox.path),
  _ModuleLink(
    label: 'Row Expanded Module',
    routePath: AppRoute.rowExpanded.path,
  ),
  _ModuleLink(label: 'SafeArea Module', routePath: AppRoute.safeArea.path),
  _ModuleLink(label: 'Scrollbar Module', routePath: AppRoute.scrollbar.path),
  _ModuleLink(label: 'SizedBox Module', routePath: AppRoute.sizedBox.path),
  _ModuleLink(
    label: 'SingleChildScrollView Module',
    routePath: AppRoute.singleChildScrollView.path,
  ),
  _ModuleLink(
    label: 'SliverAppBar Module',
    routePath: AppRoute.sliverAppBar.path,
  ),
  _ModuleLink(label: 'SliverGrid Module', routePath: AppRoute.sliverGrid.path),
  _ModuleLink(label: 'SliverList Module', routePath: AppRoute.sliverList.path),
  _ModuleLink(
    label: 'SliverPadding Module',
    routePath: AppRoute.sliverPadding.path,
  ),
  _ModuleLink(label: 'SliverSnap Module', routePath: AppRoute.sliverSnap.path),
  _ModuleLink(
    label: 'SliverToBoxAdapter Module',
    routePath: AppRoute.sliverToBoxAdapter.path,
  ),
  _ModuleLink(
    label:
        'SliverToBoxAdapter + SliverList + SliverPadding + SliverFillRemaining Module',
    routePath: AppRoute.sliverWidgets.path,
  ),
  _ModuleLink(label: 'Stack Module', routePath: AppRoute.stack.path),
  _ModuleLink(label: 'Table Module', routePath: AppRoute.table.path),
  _ModuleLink(label: 'Transform Module', routePath: AppRoute.transform.path),
  _ModuleLink(
    label: 'UnconstrainedBox Module',
    routePath: AppRoute.unconstrainedBox.path,
  ),
  _ModuleLink(label: 'Wrap Module', routePath: AppRoute.wrap.path),
];

final List<_ModuleLink> _contentModules = <_ModuleLink>[
  _ModuleLink(label: 'ActionChip Module', routePath: AppRoute.actionChip.path),
  _ModuleLink(
    label: 'AboutDialog Module',
    routePath: AppRoute.aboutDialog.path,
  ),
  _ModuleLink(
    label: 'AdvancedProgressIndicator Module',
    routePath: AppRoute.advancedProgressIndicator.path,
  ),
  _ModuleLink(
    label: 'AlertDialog Module',
    routePath: AppRoute.alertDialog.path,
  ),
  _ModuleLink(
    label: 'AnimatedListTile Module',
    routePath: AppRoute.animatedListTile.path,
  ),
  _ModuleLink(
    label: 'auto_route Module',
    routePath: AppRoute.autoRouteUsage.path,
  ),
  _ModuleLink(label: 'Cascade Route Module', routePath: AppRoute.cascade.path),
  _ModuleLink(
    label: 'BlockSemantics Module',
    routePath: AppRoute.blockSemantics.path,
  ),
  _ModuleLink(
    label: 'BottomNavigationBar Module',
    routePath: AppRoute.bottomNavigationBar.path,
  ),
  _ModuleLink(label: 'built_value Module', routePath: AppRoute.builtValue.path),
  _ModuleLink(
    label: 'cached_network_image_ce Module',
    routePath: AppRoute.cachedNetworkImageCe.path,
  ),
  _ModuleLink(label: 'characters Module', routePath: AppRoute.characters.path),
  _ModuleLink(label: 'chopper Module', routePath: AppRoute.chopper.path),
  _ModuleLink(label: 'clipboard Module', routePath: AppRoute.clipboard.path),
  _ModuleLink(label: 'Checkbox Module', routePath: AppRoute.checkbox.path),
  _ModuleLink(label: 'ChoiceChip Module', routePath: AppRoute.choiceChip.path),
  _ModuleLink(
    label: 'CircularProgressIndicator Module',
    routePath: AppRoute.circularProgressIndicator.path,
  ),
  _ModuleLink(label: 'crypto Module', routePath: AppRoute.crypto.path),
  _ModuleLink(label: 'cue Module', routePath: AppRoute.cue.path),
  _ModuleLink(
    label: 'DataTable + PaginatedDataTable Module',
    routePath: AppRoute.dataTable.path,
  ),
  _ModuleLink(label: 'DatePicker Module', routePath: AppRoute.datePicker.path),
  _ModuleLink(
    label: 'DatePickerDialog Module',
    routePath: AppRoute.datePickerDialog.path,
  ),
  _ModuleLink(label: 'Dialog Module', routePath: AppRoute.dialog.path),
  _ModuleLink(label: 'dio Module', routePath: AppRoute.dio.path),
  _ModuleLink(
    label: 'dio + get_it Multi-URL Module',
    routePath: AppRoute.dioMultiUrl.path,
  ),
  _ModuleLink(label: 'DragTarget Module', routePath: AppRoute.dragTarget.path),
  _ModuleLink(label: 'Draggable Module', routePath: AppRoute.draggable.path),
  _ModuleLink(
    label: 'drift + drift_flutter Module',
    routePath: AppRoute.driftFlutter.path,
  ),
  _ModuleLink(
    label: 'encrypter_plus Module',
    routePath: AppRoute.encrypterPlus.path,
  ),
  _ModuleLink(
    label: 'ExpandableSection Module',
    routePath: AppRoute.expandableSection.path,
  ),
  _ModuleLink(
    label: 'ExcludeSemantics Module',
    routePath: AppRoute.excludeSemantics.path,
  ),
  _ModuleLink(label: 'FilterChip Module', routePath: AppRoute.filterChip.path),
  _ModuleLink(label: 'ffigen Module', routePath: AppRoute.ffigen.path),
  _ModuleLink(
    label: 'flex_color_scheme Module',
    routePath: AppRoute.flexColorScheme.path,
  ),
  _ModuleLink(
    label: 'flex_seed_scheme Module',
    routePath: AppRoute.flexSeedScheme.path,
  ),
  _ModuleLink(label: 'fl_chart Module', routePath: AppRoute.flChart.path),
  _ModuleLink(label: 'fluent_ui Module', routePath: AppRoute.fluentUi.path),
  _ModuleLink(
    label: 'FloatingActionButton Module',
    routePath: AppRoute.floatingActionButton.path,
  ),
  _ModuleLink(
    label: 'FocusableActionDetector Module',
    routePath: AppRoute.focusableActionDetector.path,
  ),
  _ModuleLink(
    label: 'FocusTraversalGroup Module',
    routePath: AppRoute.focusTraversalGroup.path,
  ),
  _ModuleLink(
    label: 'flutter_auto_size_text Module',
    routePath: AppRoute.flutterAutoSizeText.path,
  ),
  _ModuleLink(
    label: 'flutter_bloc Module',
    routePath: AppRoute.flutterBloc.path,
  ),
  _ModuleLink(
    label: 'flutter_card_swiper Module',
    routePath: AppRoute.flutterCardSwiper.path,
  ),
  _ModuleLink(
    label: 'flutter_dotenv Module',
    routePath: AppRoute.flutterDotenv.path,
  ),
  _ModuleLink(
    label: 'flutter_hooks Module',
    routePath: AppRoute.flutterHooks.path,
  ),
  _ModuleLink(
    label: 'flutter_local_notifications Module',
    routePath: AppRoute.flutterLocalNotifications.path,
  ),
  _ModuleLink(
    label: 'flutter_secure_storage Module',
    routePath: AppRoute.flutterSecureStorage.path,
  ),
  _ModuleLink(
    label: 'flutter_slidable Module',
    routePath: AppRoute.flutterSlidable.path,
  ),
  _ModuleLink(
    label: 'flutter_custom_tabs Module',
    routePath: AppRoute.flutterCustomTabs.path,
  ),
  _ModuleLink(label: 'flutter_svg Module', routePath: AppRoute.flutterSvg.path),
  _ModuleLink(label: 'flutter_tts Module', routePath: AppRoute.flutterTts.path),
  _ModuleLink(
    label: 'fluttertoast Module',
    routePath: AppRoute.fluttertoast.path,
  ),
  _ModuleLink(
    label: 'flutter_video_caching + fvp Module',
    routePath: AppRoute.flutterVideoCachingFvp.path,
  ),
  _ModuleLink(
    label: 'freezed_annotation Module',
    routePath: AppRoute.freezedAnnotation.path,
  ),
  _ModuleLink(
    label: 'font_awesome_flutter Module',
    routePath: AppRoute.fontAwesomeFlutter.path,
  ),
  _ModuleLink(label: 'Form Module', routePath: AppRoute.form.path),
  _ModuleLink(label: 'FormField Module', routePath: AppRoute.formField.path),
  _ModuleLink(
    label: 'FutureBuilder Module',
    routePath: AppRoute.futureBuilder.path,
  ),
  _ModuleLink(label: 'genui Module', routePath: AppRoute.genui.path),
  _ModuleLink(
    label: 'graphql_flutter Module',
    routePath: AppRoute.graphqlFlutter.path,
  ),
  _ModuleLink(label: 'Image Module', routePath: AppRoute.imageWidget.path),
  _ModuleLink(label: 'iconly Module', routePath: AppRoute.iconly.path),
  _ModuleLink(
    label: 'Ink + InkWell + InkResponse Module',
    routePath: AppRoute.inkWidgets.path,
  ),
  _ModuleLink(label: 'injectable Module', routePath: AppRoute.injectable.path),
  _ModuleLink(
    label: 'injectable + get_it Module',
    routePath: AppRoute.injectableGetIt.path,
  ),
  _ModuleLink(
    label: 'infinite_scroll_pagination Module',
    routePath: AppRoute.infiniteScrollPagination.path,
  ),
  _ModuleLink(label: 'InputChip Module', routePath: AppRoute.inputChip.path),
  _ModuleLink(
    label: 'iPhone-like Floating Button Module',
    routePath: AppRoute.iPhoneLikeFloatingButton.path,
  ),
  _ModuleLink(
    label: 'introduction_screen Module',
    routePath: AppRoute.introductionScreen.path,
  ),
  _ModuleLink(label: 'Intl Module', routePath: AppRoute.intl.path),
  _ModuleLink(
    label: 'InteractiveCard Module',
    routePath: AppRoute.interactiveCard.path,
  ),
  _ModuleLink(label: 'jnigen Module', routePath: AppRoute.jnigen.path),
  _ModuleLink(
    label: 'json_annotation Module',
    routePath: AppRoute.jsonAnnotation.path,
  ),
  _ModuleLink(
    label: 'KeyboardListener Module',
    routePath: AppRoute.keyboardListener.path,
  ),
  _ModuleLink(
    label: 'LinearProgressIndicator Module',
    routePath: AppRoute.linearProgressIndicator.path,
  ),
  _ModuleLink(label: 'loot_reel Module', routePath: AppRoute.lootReel.path),
  _ModuleLink(
    label: 'lucide_icons_flutter Module',
    routePath: AppRoute.lucideIconsFlutter.path,
  ),
  _ModuleLink(label: 'lottie Module', routePath: AppRoute.lottie.path),
  _ModuleLink(
    label: 'material_color_utilities Module',
    routePath: AppRoute.materialColorUtilities.path,
  ),
  _ModuleLink(
    label: 'MaterialStateProperty Module',
    routePath: AppRoute.materialStateProperty.path,
  ),
  _ModuleLink(
    label: 'material_symbols_icons Module',
    routePath: AppRoute.materialSymbolsIcons.path,
  ),
  _ModuleLink(label: 'macos_ui Module', routePath: AppRoute.macosUi.path),
  _ModuleLink(
    label: 'MergeSemantics Module',
    routePath: AppRoute.mergeSemantics.path,
  ),
  _ModuleLink(
    label: 'MouseRegion Module',
    routePath: AppRoute.mouseRegion.path,
  ),
  _ModuleLink(
    label: 'native_device_orientation Communicator Module',
    routePath: AppRoute.nativeDeviceOrientationCommunicator.path,
  ),
  _ModuleLink(
    label: 'native_device_orientation OrientedWidget Module',
    routePath: AppRoute.nativeDeviceOrientationOrientedWidget.path,
  ),
  _ModuleLink(
    label: 'native_device_orientation Reader Module',
    routePath: AppRoute.nativeDeviceOrientationReader.path,
  ),
  _ModuleLink(label: 'open_file Module', routePath: AppRoute.openFile.path),
  _ModuleLink(
    label: 'onboarding_overlay Module',
    routePath: AppRoute.onboardingOverlay.path,
  ),
  _ModuleLink(
    label: 'OverlayMenu Module',
    routePath: AppRoute.overlayMenu.path,
  ),
  _ModuleLink(
    label: 'permission_handler Module',
    routePath: AppRoute.permissionHandler.path,
  ),
  _ModuleLink(
    label: 'package_info_plus Module',
    routePath: AppRoute.packageInfoPlus.path,
  ),
  _ModuleLink(label: 'pigeon Module', routePath: AppRoute.pigeon.path),
  _ModuleLink(label: 'PopScope Module', routePath: AppRoute.popScope.path),
  _ModuleLink(label: 'Radio Module', routePath: AppRoute.radio.path),
  _ModuleLink(label: 'RichText Module', routePath: AppRoute.richText.path),
  _ModuleLink(
    label: 'sensors_plus Module',
    routePath: AppRoute.sensorsPlus.path,
  ),
  _ModuleLink(label: 'Semantics Module', routePath: AppRoute.semantics.path),
  _ModuleLink(label: 'shadcn_ui Module', routePath: AppRoute.shadcnUi.path),
  _ModuleLink(
    label: 'shared_preferences Module',
    routePath: AppRoute.sharedPreferences.path,
  ),
  _ModuleLink(label: 'share_plus Module', routePath: AppRoute.sharePlus.path),
  _ModuleLink(label: 'showDialog Module', routePath: AppRoute.showDialog.path),
  _ModuleLink(
    label: 'SimpleDialog Module',
    routePath: AppRoute.simpleDialog.path,
  ),
  _ModuleLink(label: 'Slider Module', routePath: AppRoute.slider.path),
  _ModuleLink(label: 'SnackBar Module', routePath: AppRoute.snackBar.path),
  _ModuleLink(
    label: 'speech_to_text Module',
    routePath: AppRoute.speechToText.path,
  ),
  _ModuleLink(
    label: 'StreamBuilder Module',
    routePath: AppRoute.streamBuilder.path,
  ),
  _ModuleLink(
    label: 'super_clipboard Module',
    routePath: AppRoute.superClipboard.path,
  ),
  _ModuleLink(
    label: 'smooth_page_indicator Module',
    routePath: AppRoute.smoothPageIndicator.path,
  ),
  _ModuleLink(label: 'Switch Module', routePath: AppRoute.switchExample.path),
  _ModuleLink(label: 'Text.rich Module', routePath: AppRoute.textRich.path),
  _ModuleLink(
    label: 'TextField + TextEditingController Module',
    routePath: AppRoute.textFieldController.path,
  ),
  _ModuleLink(label: 'TextStyle Module', routePath: AppRoute.textStyle.path),
  _ModuleLink(
    label: 'ThemeData VisualDensity Module',
    routePath: AppRoute.themeDataVisualDensity.path,
  ),
  _ModuleLink(label: 'TimePicker Module', routePath: AppRoute.timePicker.path),
  _ModuleLink(
    label: 'TimePickerDialog Module',
    routePath: AppRoute.timePickerDialog.path,
  ),
  _ModuleLink(
    label: 'toggle_switch Module',
    routePath: AppRoute.toggleSwitch.path,
  ),
  _ModuleLink(label: 'Tooltip Module', routePath: AppRoute.tooltip.path),
  _ModuleLink(
    label: 'url_launcher Module',
    routePath: AppRoute.urlLauncher.path,
  ),
  _ModuleLink(
    label: 'video_thumbnail Module',
    routePath: AppRoute.videoThumbnail.path,
  ),
  _ModuleLink(label: 'wasm_ffi Module', routePath: AppRoute.wasmFfi.path),
  _ModuleLink(
    label: 'webview_flutter Module',
    routePath: AppRoute.webviewFlutter.path,
  ),
];

final List<_ModuleLink> _animationModules = <_ModuleLink>[
  _ModuleLink(
    label: 'animated_text_kit Module',
    routePath: AppRoute.animatedTextKit.path,
  ),
  _ModuleLink(
    label: 'AnimatedDefaultTextStyle Module',
    routePath: AppRoute.animatedDefaultTextStyle.path,
  ),
  _ModuleLink(
    label: 'AnimatedSwitcher Module',
    routePath: AppRoute.animatedSwitcher.path,
  ),
  _ModuleLink(
    label: 'animated_toggle_switch Module',
    routePath: AppRoute.animatedToggleSwitch.path,
  ),
  _ModuleLink(
    label: 'AnimationController Module',
    routePath: AppRoute.animationController.path,
  ),
  _ModuleLink(
    label: 'CustomPaint Module',
    routePath: AppRoute.customPaint.path,
  ),
  _ModuleLink(
    label: 'SingleTickerProviderStateMixin Module',
    routePath: AppRoute.singleTickerProviderStateMixin.path,
  ),
  _ModuleLink(label: 'Tween Module', routePath: AppRoute.tween.path),
  _ModuleLink(
    label: 'TweenAnimationBuilder Module',
    routePath: AppRoute.tweenAnimationBuilder.path,
  ),
  _ModuleLink(
    label: 'TweenSequence + Interval Module',
    routePath: AppRoute.tweenSequenceInterval.path,
  ),
];

@RoutePage(name: RouteName.home)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: AppTab.values
          .map((AppTab tab) => tab.tabRoute)
          .toList(growable: false),
      appBarBuilder: (BuildContext context, TabsRouter tabsRouter) {
        final AppTab activeTab = AppTab.values[tabsRouter.activeIndex];
        return AppBar(
          automaticallyImplyLeading: false,
          title: Text(activeTab.title),
          actions: <Widget>[
            IconButton(
              tooltip: 'Logout',
              onPressed: demoAuthController.logout,
              icon: const Icon(Icons.logout),
            ),
          ],
        );
      },
      bottomNavigationBuilder: (BuildContext context, TabsRouter tabsRouter) {
        return NavigationBar(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: tabsRouter.setActiveIndex,
          destinations: AppTab.values
              .map((AppTab tab) => tab.destination)
              .toList(growable: false),
        );
      },
    );
  }
}

@RoutePage(name: RouteName.homeLayout)
class LayoutTabPage extends StatelessWidget {
  const LayoutTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ModuleTabView(modules: _layoutModules);
  }
}

@RoutePage(name: RouteName.homeContent)
class ContentTabPage extends StatelessWidget {
  const ContentTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ModuleTabView(modules: _contentModules);
  }
}

@RoutePage(name: RouteName.homeAnimation)
class AnimationTabPage extends StatelessWidget {
  const AnimationTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ModuleTabView(modules: _animationModules);
  }
}

class _ModuleTabView extends StatelessWidget {
  const _ModuleTabView({required this.modules});

  final List<_ModuleLink> modules;

  @override
  Widget build(BuildContext context) {
    final List<_ModuleLink> sortedModules = List<_ModuleLink>.of(modules)
      ..sort(
        (_ModuleLink a, _ModuleLink b) =>
            a.label.toLowerCase().compareTo(b.label.toLowerCase()),
      );

    return SelectionArea(
      child: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: sortedModules.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 16);
        },
        itemBuilder: (BuildContext context, int index) {
          final _ModuleLink module = sortedModules[index];
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.router.root.pushPath(module.routePath),
              child: Text(module.label),
            ),
          );
        },
      ),
    );
  }
}

class _ModuleLink {
  const _ModuleLink({required this.label, required this.routePath});

  final String label;
  final String routePath;
}
