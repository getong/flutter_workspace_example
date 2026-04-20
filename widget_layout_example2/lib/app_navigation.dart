import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/app_router.dart';

enum AppRoute {
  /// Route definitions combining path and route name.
  ///
  /// Usage: `AppRoute.login.path` for the URL path,
  ///        `AppRoute.login.routeName` for the generated route class name.
  login('/login', 'LoginRoute'),
  home('/', 'HomeRoute'),
  homeLayout('layout', 'LayoutTabRoute'),
  homeContent('content', 'ContentTabRoute'),
  homeAnimation('animation', 'AnimationTabRoute'),
  aspectRatio('/aspect-ratio-page', 'AspectRatioRoute'),
  centerBox('/center-box', 'CenterBoxRoute'),
  constrainedBox('/constrained-box', 'ConstrainedBoxRoute'),
  container('/container-page', 'ContainerRoute'),
  unconstrainedBox('/unconstrained-box-page', 'UnconstrainedBoxExampleRoute'),
  rowExpanded('/row-expand-page', 'RowExpandedRoute'),
  expanded('/expanded-page', 'ExpandedRoute'),
  flexible('/flexible-page', 'FlexibleRoute'),
  gesturedector('/gesturedector-page', 'GesturedetectorRoute'),
  column('/column-page', 'ColumnRoute'),
  columnSaved('/column-saved-page', 'ColumnSavedRoute'),
  columnSavedStateless(
    '/column-saved-stateless-page',
    'ColumnSavedStatelessRoute',
  ),
  flow('/flow-page', 'FlowExampleRoute'),
  fractionallySizedBox(
    '/fractionally-sized-box-page',
    'FractionallySizedBoxRoute',
  ),
  layoutBuilder('/layout-builder-page', 'LayoutBuilderExampleRoute'),
  orientationBuilder('/orientation-builder-page', 'OrientationBuilderRoute'),
  padding('/padding-page', 'PaddingRoute'),
  responsiveContainer('/responsive-container-page', 'ResponsiveContainerRoute'),
  wrap('/wrap-page', 'WrapRoute'),
  positioned('/positioned-page', 'PositionedRoute'),
  sizedBox('/sized-box-page', 'SizedBoxRoute'),
  stack('/stack-page', 'StackRoute'),
  align('/align-page', 'AlignRoute'),
  transform('/transform-page', 'TransformExampleRoute'),
  rotatedBox('/rotated-box-page', 'RotatedBoxExampleRoute'),
  safeArea('/safe-area-page', 'SafeAreaRoute'),
  indexedStack('/indexed-stack-page', 'IndexedStackRoute'),
  sliverList('/sliver-list-page', 'SliverListRoute'),
  sliverGrid('/sliver-grid-page', 'SliverGridRoute'),
  sliverAppBar('/sliver-app-bar-page', 'SliverAppBarRoute'),
  sliverSnap('/sliver-snap-page', 'SliverSnapRoute'),
  sliverToBoxAdapter('/sliver-to-box-adapter-page', 'SliverToBoxAdapterRoute'),
  sliverPadding('/sliver-padding-page', 'SliverPaddingRoute'),
  clipOval('/clip-oval-page', 'ClipOvalExampleRoute'),
  clipRRect('/clip-r-rect-page', 'ClipRRectExampleRoute'),
  clipRect('/clip-rect-page', 'ClipRectExampleRoute'),
  clipPath('/clip-path-page', 'ClipPathExampleRoute'),
  customClipper('/custom-clipper-page', 'CustomClipperExampleRoute'),
  customMultiChildLayout(
    '/custom-multi-child-layout-page',
    'CustomMultiChildLayoutRoute',
  ),
  table('/table-page', 'TableRoute'),
  classicButtons('/classic-buttons-page', 'ButtonShowcaseRoute'),
  cascade('/cascade', 'CascadeRoute'),
  cascadeCategories('/cascade/categories', 'CascadeCategoriesRoute'),
  cascadeCategoryDetails(
    '/cascade/categories/:categoryId',
    'CascadeCategoryDetailsRoute',
  ),
  cascadeSubcategoryItems(
    '/cascade/categories/:categoryId/:subcategoryName',
    'CascadeSubcategoryItemsRoute',
  ),
  cascadeItemDetails(
    '/cascade/categories/:categoryId/:subcategoryName/:itemId',
    'CascadeItemDetailsRoute',
  ),
  autoRouteUsage('/auto-route-page', 'AutoRouteUsageRoute'),
  autoRouteLegacy('/auto-route-page/legacy', ''),
  autoRouteBooks('/auto-route-page/books', 'AutoRouteBooksRoute'),
  autoRouteBookLegacy('/auto-route-page/books/:id/legacy', ''),
  autoRouteBookDetails(
    '/auto-route-page/books/:id',
    'AutoRouteBookDetailsRoute',
  ),
  autoRouteNested('/auto-route-page/nested', 'AutoRouteNestedRoute'),
  autoRouteNestedBooks('books', 'AutoRouteBooksTabRoute'),
  autoRouteNestedProfile('profile', 'AutoRouteProfileTabRoute'),
  autoRouteNestedSettings('settings', 'AutoRouteSettingsTabRoute'),
  autoRouteProduct('/auto-route-page/products/:id', 'AutoRouteProductRoute'),
  autoRouteProductOverview('', 'AutoRouteProductOverviewRoute'),
  autoRouteProductReview('review', 'AutoRouteProductReviewRoute'),
  autoRouteArticle(
    '/auto-route-page/articles/:category/:slug',
    'AutoRouteArticleRoute',
  ),
  autoRouteProtected('/auto-route-page/protected', 'AutoRouteProtectedRoute'),
  autoRouteGlobalProtected(
    '/auto-route-page/global-protected',
    'AutoRouteGlobalProtectedRoute',
  ),
  autoRouteProfile('/auto-route-page/profile', 'ProfileRoute'),
  autoRouteWrapped('/auto-route-page/wrapped', 'AutoRouteWrappedRoute'),
  autoRouteObserver('/auto-route-page/observer', 'AutoRouteObserverRoute'),
  autoRouteLogin('/auto-route-page/login', 'AutoRouteLoginRoute'),
  autoRouteSignup('/auto-route-page/signup', 'AutoRouteSignupRoute'),
  autoRouteUnknown('/auto-route-page/*', 'AutoRouteUnknownRoute'),
  intl('/intl-page', 'IntlRoute'),
  jnigen('/jnigen-page', 'JnigenRoute'),
  characters('/characters-page', 'CharactersRoute'),
  chopper('/chopper-page', 'ChopperRoute'),
  switchExample('/switch-page', 'SwitchExampleRoute'),
  checkbox('/checkbox-page', 'CheckboxExampleRoute'),
  clipboard('/clipboard-page', 'ClipboardRoute'),
  radio('/radio-page', 'RadioExampleRoute'),
  inputChip('/input-chip-page', 'InputChipRoute'),
  choiceChip('/choice-chip-page', 'ChoiceChipRoute'),
  filterChip('/filter-chip-page', 'FilterChipRoute'),
  aboutDialog('/about-dialog-page', 'AboutDialogRoute'),
  advancedProgressIndicator(
    '/advanced-progress-indicator-page',
    'AdvancedProgressIndicatorRoute',
  ),
  animatedListTile('/animated-list-tile-page', 'AnimatedListTileRoute'),
  ffigen('/ffigen-page', 'FfigenRoute'),
  flexColorScheme('/flex-color-scheme-page', 'FlexColorSchemeRoute'),
  flexSeedScheme('/flex-seed-scheme-page', 'FlexSeedSchemeRoute'),
  actionChip('/action-chip-page', 'ActionChipRoute'),
  linearProgressIndicator(
    '/linear-progress-indicator-page',
    'LinearProgressIndicatorExampleRoute',
  ),
  lootReel('/loot-reel-page', 'LootReelRoute'),
  lucideIconsFlutter('/lucide-icons-flutter-page', 'LucideIconsFlutterRoute'),
  lottie('/lottie-page', 'LottieRoute'),
  fluentUi('/fluent-ui-page', 'FluentUiRoute'),
  materialColorUtilities(
    '/material-color-utilities-page',
    'MaterialColorUtilitiesRoute',
  ),
  materialStateProperty(
    '/material-state-property-page',
    'MaterialStatePropertyRoute',
  ),
  macosUi('/macos-ui-page', 'MacosUiRoute'),
  circularProgressIndicator(
    '/circular-progress-indicator-page',
    'CircularProgressIndicatorExampleRoute',
  ),
  crypto('/crypto-page', 'CryptoRoute'),
  cue('/cue-page', 'CueRoute'),
  slider('/slider-page', 'SliderExampleRoute'),
  sensorsPlus('/sensors-plus-page', 'SensorsPlusRoute'),
  shadcnUi('/shadcn-ui-page', 'ShadcnUiRoute'),
  datePicker('/date-picker-page', 'DatePickerRoute'),
  datePickerDialog('/date-picker-dialog-page', 'DatePickerDialogRoute'),
  timePicker('/time-picker-page', 'TimePickerRoute'),
  timePickerDialog('/time-picker-dialog-page', 'TimePickerDialogRoute'),
  toggleSwitch('/toggle-switch-page', 'ToggleSwitchRoute'),
  urlLauncher('/url-launcher-page', 'UrlLauncherRoute'),
  wasmFfi('/wasm-ffi-page', 'WasmFfiRoute'),
  webviewFlutter('/webview-flutter-page', 'WebviewFlutterRoute'),
  form('/form-page', 'FormRoute'),
  formField('/form-field-page', 'FormFieldRoute'),
  draggable('/draggable-page', 'DraggableExampleRoute'),
  dragTarget('/drag-target-page', 'DragTargetExampleRoute'),
  expandableSection('/expandable-section-page', 'ExpandableSectionRoute'),
  richText('/rich-text-page', 'RichTextRoute'),
  textStyle('/text-style-page', 'TextStyleRoute'),
  themeDataVisualDensity(
    '/theme-data-visual-density-page',
    'ThemeDataVisualDensityRoute',
  ),
  bottomNavigationBar(
    '/bottom-navigation-bar-page',
    'BottomNavigationBarExampleRoute',
  ),
  builtValue('/built-value-page', 'BuiltValueRoute'),
  floatingActionButton(
    '/floating-action-button-page',
    'FloatingActionButtonExampleRoute',
  ),
  focusableActionDetector(
    '/focusable-action-detector-page',
    'FocusableActionDetectorRoute',
  ),
  focusTraversalGroup(
    '/focus-traversal-group-page',
    'FocusTraversalGroupRoute',
  ),
  snackBar('/snack-bar-page', 'SnackBarExampleRoute'),
  showDialog('/show-dialog-page', 'ShowDialogExampleRoute'),
  alertDialog('/alert-dialog-page', 'AlertDialogExampleRoute'),
  simpleDialog('/simple-dialog-page', 'SimpleDialogExampleRoute'),
  dialog('/dialog-page', 'DialogExampleRoute'),
  dio('/dio-page', 'DioRoute'),
  dioMultiUrl('/dio-multi-url-page', 'DioMultiUrlRoute'),
  futureBuilder('/future-builder-page', 'FutureBuilderRoute'),
  genui('/genui-page', 'GenuiRoute'),
  flutterBloc('/flutter-bloc-page', 'FlutterBlocRoute'),
  flutterCardSwiper('/flutter-card-swiper-page', 'FlutterCardSwiperRoute'),
  flutterCustomTabs('/flutter-custom-tabs-page', 'FlutterCustomTabsRoute'),
  flutterDotenv('/flutter-dotenv-page', 'FlutterDotenvRoute'),
  flutterHooks('/flutter-hooks-page', 'FlutterHooksRoute'),
  interactiveCard('/interactive-card-page', 'InteractiveCardRoute'),
  flutterTts('/flutter-tts-page', 'FlutterTtsRoute'),
  freezedAnnotation('/freezed-annotation-page', 'FreezedAnnotationRoute'),
  graphqlFlutter('/graphql-flutter-page', 'GraphqlFlutterRoute'),
  iconly('/iconly-page', 'IconlyRoute'),
  injectableGetIt('/injectable-get-it-page', 'InjectableGetItRoute'),
  injectable('/injectable-page', 'InjectableRoute'),
  iPhoneLikeFloatingButton(
    '/iphone-like-floating-button-page',
    'IPhoneLikeFloatingButtonRoute',
  ),
  infiniteScrollPagination(
    '/infinite-scroll-pagination-page',
    'InfiniteScrollPaginationRoute',
  ),
  introductionScreen('/introduction-screen-page', 'IntroductionScreenRoute'),
  jsonAnnotation('/json-annotation-page', 'JsonAnnotationRoute'),
  overlayMenu('/overlay-menu-page', 'OverlayMenuRoute'),
  streamBuilder('/stream-builder-page', 'StreamBuilderRoute'),
  driftFlutter('/drift-flutter-page', 'DriftFlutterRoute'),
  encrypterPlus('/encrypter-plus-page', 'EncrypterPlusRoute'),
  fluttertoast('/fluttertoast-page', 'FluttertoastRoute'),
  keyboardListener('/keyboard-listener-page', 'KeyboardListenerRoute'),
  inkWidgets('/ink-widgets-page', 'InkWidgetsRoute'),
  mediaQuery('/media-query-page', 'MediaQueryRoute'),
  mouseRegion('/mouse-region-page', 'MouseRegionRoute'),
  nativeDeviceOrientationCommunicator(
    '/native-device-orientation-communicator-page',
    'NativeDeviceOrientationCommunicatorRoute',
  ),
  nativeDeviceOrientationOrientedWidget(
    '/native-device-orientation-oriented-widget-page',
    'NativeDeviceOrientationOrientedWidgetRoute',
  ),
  nativeDeviceOrientationReader(
    '/native-device-orientation-reader-page',
    'NativeDeviceOrientationReaderRoute',
  ),
  textRich('/text-rich-page', 'TextRichRoute'),
  singleChildScrollView(
    '/single-child-scroll-view-page',
    'SingleChildScrollViewRoute',
  ),
  sliverWidgets('/sliver-widgets-page', 'SliverExamplesRoute'),
  scrollbar('/scrollbar-page', 'ScrollbarRoute'),
  filledButton('/filled-button-page', 'FilledButtonRoute'),
  fittedBox('/fitted-box-page', 'FittedBoxRoute'),
  decoratedBox('/decorated-box-page', 'DecoratedBoxRoute'),
  blockSemantics('/block-semantics-page', 'BlockSemanticsRoute'),
  semantics('/semantics-page', 'SemanticsRoute'),
  excludeSemantics('/exclude-semantics-page', 'ExcludeSemanticsRoute'),
  mergeSemantics('/merge-semantics-page', 'MergeSemanticsRoute'),
  onboardingOverlay('/onboarding-overlay-page', 'OnboardingOverlayRoute'),
  openFile('/open-file-page', 'OpenFileRoute'),
  permissionHandler('/permission-handler-page', 'PermissionHandlerRoute'),
  packageInfoPlus('/package-info-plus-page', 'PackageInfoPlusRoute'),
  pigeon('/pigeon-page', 'PigeonRoute'),
  popScope('/pop-scope-page', 'PopScopeRoute'),
  speechToText('/speech-to-text-page', 'SpeechToTextRoute'),
  smoothPageIndicator(
    '/smooth-page-indicator-page',
    'SmoothPageIndicatorRoute',
  ),
  superClipboard('/super-clipboard-page', 'SuperClipboardRoute'),
  sharedPreferences('/shared-preferences-page', 'SharedPreferencesRoute'),
  sharePlus('/share-plus-page', 'SharePlusRoute'),
  textFieldController(
    '/text-field-controller-page',
    'TextFieldControllerRoute',
  ),
  flutterAutoSizeText(
    '/flutter-auto-size-text-page',
    'FlutterAutoSizeTextRoute',
  ),
  flutterLocalNotifications(
    '/flutter-local-notifications-page',
    'FlutterLocalNotificationsRoute',
  ),
  flutterSecureStorage(
    '/flutter-secure-storage-page',
    'FlutterSecureStorageRoute',
  ),
  tooltip('/tooltip-page', 'TooltipRoute'),
  animatedTextKit('/animated-text-kit-page', 'AnimatedTextKitRoute'),
  videoThumbnail('/video-thumbnail-page', 'VideoThumbnailRoute'),
  flutterSlidable('/flutter-slidable-page', 'FlutterSlidableRoute'),
  flutterVideoCachingFvp(
    '/flutter-video-caching-fvp-page',
    'FlutterVideoCachingFvpRoute',
  ),
  cachedNetworkImageCe(
    '/cached-network-image-ce-page',
    'CachedNetworkImageCeRoute',
  ),
  dataTable('/data-table-page', 'DataTableRoute'),
  flChart('/fl-chart-page', 'FlChartRoute'),
  fontAwesomeFlutter('/font-awesome-flutter-page', 'FontAwesomeFlutterRoute'),
  materialSymbolsIcons(
    '/material-symbols-icons-page',
    'MaterialSymbolsIconsRoute',
  ),
  imageWidget('/image-widget-page', 'ImageWidgetRoute'),
  animatedSwitcher('/animated-switcher-page', 'AnimatedSwitcherRoute'),
  animatedToggleSwitch(
    '/animated-toggle-switch-page',
    'AnimatedToggleSwitchRoute',
  ),
  animatedDefaultTextStyle(
    '/animated-default-text-style-page',
    'AnimatedDefaultTextStyleRoute',
  ),
  customPaint('/custom-paint-page', 'CustomPaintRoute'),
  tweenAnimationBuilder(
    '/tween-animation-builder-page',
    'TweenAnimationBuilderRoute',
  ),
  animationController('/animation-controller-page', 'AnimationControllerRoute'),
  singleTickerProviderStateMixin(
    '/single-ticker-provider-state-mixin-page',
    'SingleTickerProviderStateMixinRoute',
  ),
  tween('/tween-page', 'TweenRoute'),
  tweenSequenceInterval(
    '/tween-sequence-interval-page',
    'TweenSequenceIntervalRoute',
  ),
  flutterSvg('/flutter-svg-page', 'FlutterSvgRoute');

  final String path;
  final String routeName;
  const AppRoute(this.path, this.routeName);
}

enum AppTab { layout, content, animation }

extension AppTabX on AppTab {
  String get title {
    switch (this) {
      case AppTab.layout:
        return 'Layout Modules';
      case AppTab.content:
        return 'Content Modules';
      case AppTab.animation:
        return 'Animation Modules';
    }
  }

  String get label {
    switch (this) {
      case AppTab.layout:
        return 'Layout';
      case AppTab.content:
        return 'Content';
      case AppTab.animation:
        return 'Animation';
    }
  }

  IconData get icon {
    switch (this) {
      case AppTab.layout:
        return Icons.view_quilt_outlined;
      case AppTab.content:
        return Icons.widgets_outlined;
      case AppTab.animation:
        return Icons.animation_outlined;
    }
  }

  IconData get selectedIcon {
    switch (this) {
      case AppTab.layout:
        return Icons.view_quilt;
      case AppTab.content:
        return Icons.widgets;
      case AppTab.animation:
        return Icons.animation;
    }
  }

  NavigationDestination get destination => NavigationDestination(
    icon: Icon(icon),
    selectedIcon: Icon(selectedIcon),
    label: label,
  );

  PageRouteInfo<void> get tabRoute {
    switch (this) {
      case AppTab.layout:
        return const LayoutTabRoute();
      case AppTab.content:
        return const ContentTabRoute();
      case AppTab.animation:
        return const AnimationTabRoute();
    }
  }

  PageRouteInfo<void> get route {
    switch (this) {
      case AppTab.layout:
        return const HomeRoute(
          children: <PageRouteInfo<void>>[LayoutTabRoute()],
        );
      case AppTab.content:
        return const HomeRoute(
          children: <PageRouteInfo<void>>[ContentTabRoute()],
        );
      case AppTab.animation:
        return const HomeRoute(
          children: <PageRouteInfo<void>>[AnimationTabRoute()],
        );
    }
  }
}

enum AppRouteTarget {
  home,
  login,
  signUp,
  autoRouteUsage,
  autoRouteNested,
  autoRouteBooks,
  profile,
  wrappedDemo,
  observerDemo,
}

extension AppRouteTargetX on AppRouteTarget {
  PageRouteInfo<void> get route {
    switch (this) {
      case AppRouteTarget.home:
        return AppTab.layout.route;
      case AppRouteTarget.login:
        return LoginRoute();
      case AppRouteTarget.signUp:
        return const AutoRouteSignupRoute();
      case AppRouteTarget.autoRouteUsage:
        return const AutoRouteUsageRoute();
      case AppRouteTarget.autoRouteNested:
        return const AutoRouteNestedRoute();
      case AppRouteTarget.autoRouteBooks:
        return const AutoRouteBooksRoute();
      case AppRouteTarget.profile:
        return const ProfileRoute();
      case AppRouteTarget.wrappedDemo:
        return const AutoRouteWrappedRoute();
      case AppRouteTarget.observerDemo:
        return const AutoRouteObserverRoute();
    }
  }
}

enum AutoRouteNestedTab { books, profile, settings }

extension AutoRouteNestedTabX on AutoRouteNestedTab {
  String get label {
    switch (this) {
      case AutoRouteNestedTab.books:
        return 'Books';
      case AutoRouteNestedTab.profile:
        return 'Profile';
      case AutoRouteNestedTab.settings:
        return 'Settings';
    }
  }

  IconData get icon {
    switch (this) {
      case AutoRouteNestedTab.books:
        return Icons.menu_book_outlined;
      case AutoRouteNestedTab.profile:
        return Icons.person_outline;
      case AutoRouteNestedTab.settings:
        return Icons.settings_outlined;
    }
  }

  IconData get selectedIcon {
    switch (this) {
      case AutoRouteNestedTab.books:
        return Icons.menu_book;
      case AutoRouteNestedTab.profile:
        return Icons.person;
      case AutoRouteNestedTab.settings:
        return Icons.settings;
    }
  }

  NavigationDestination get destination => NavigationDestination(
    icon: Icon(icon),
    selectedIcon: Icon(selectedIcon),
    label: label,
  );

  PageRouteInfo<void> get route {
    switch (this) {
      case AutoRouteNestedTab.books:
        return const AutoRouteBooksTabRoute();
      case AutoRouteNestedTab.profile:
        return const AutoRouteProfileTabRoute();
      case AutoRouteNestedTab.settings:
        return const AutoRouteSettingsTabRoute();
    }
  }
}
