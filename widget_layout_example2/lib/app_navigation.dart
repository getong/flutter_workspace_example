import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/app_router.dart';

/// Compile-time constant route names for use in @RoutePage annotations.
///
/// Usage: @RoutePage(name: RouteName.login)
abstract final class RouteName {
  static const login = 'LoginRoute';
  static const home = 'HomeRoute';
  static const homeLayout = 'LayoutTabRoute';
  static const homeContent = 'ContentTabRoute';
  static const homeAnimation = 'AnimationTabRoute';
  static const aspectRatio = 'AspectRatioRoute';
  static const centerBox = 'CenterBoxRoute';
  static const constrainedBox = 'ConstrainedBoxRoute';
  static const container = 'ContainerRoute';
  static const unconstrainedBox = 'UnconstrainedBoxExampleRoute';
  static const rowExpanded = 'RowExpandedRoute';
  static const expanded = 'ExpandedRoute';
  static const flexible = 'FlexibleRoute';
  static const gesturedector = 'GesturedetectorRoute';
  static const column = 'ColumnRoute';
  static const columnSaved = 'ColumnSavedRoute';
  static const columnSavedStateless = 'ColumnSavedStatelessRoute';
  static const flow = 'FlowExampleRoute';
  static const fractionallySizedBox = 'FractionallySizedBoxRoute';
  static const layoutBuilder = 'LayoutBuilderExampleRoute';
  static const orientationBuilder = 'OrientationBuilderRoute';
  static const padding = 'PaddingRoute';
  static const spacer = 'SpacerRoute';
  static const responsiveContainer = 'ResponsiveContainerRoute';
  static const wrap = 'WrapRoute';
  static const positioned = 'PositionedRoute';
  static const sizedBox = 'SizedBoxRoute';
  static const stack = 'StackRoute';
  static const align = 'AlignRoute';
  static const transform = 'TransformExampleRoute';
  static const rotatedBox = 'RotatedBoxExampleRoute';
  static const safeArea = 'SafeAreaRoute';
  static const indexedStack = 'IndexedStackRoute';
  static const sliverList = 'SliverListRoute';
  static const sliverGrid = 'SliverGridRoute';
  static const sliverAppBar = 'SliverAppBarRoute';
  static const sliverSnap = 'SliverSnapRoute';
  static const sliverToBoxAdapter = 'SliverToBoxAdapterRoute';
  static const sliverPadding = 'SliverPaddingRoute';
  static const clipOval = 'ClipOvalExampleRoute';
  static const clipRRect = 'ClipRRectExampleRoute';
  static const clipRect = 'ClipRectExampleRoute';
  static const clipPath = 'ClipPathExampleRoute';
  static const customClipper = 'CustomClipperExampleRoute';
  static const customMultiChildLayout = 'CustomMultiChildLayoutRoute';
  static const table = 'TableRoute';
  static const classicButtons = 'ButtonShowcaseRoute';
  static const cascade = 'CascadeRoute';
  static const cascadeCategories = 'CascadeCategoriesRoute';
  static const cascadeCategoryDetails = 'CascadeCategoryDetailsRoute';
  static const cascadeSubcategoryItems = 'CascadeSubcategoryItemsRoute';
  static const cascadeItemDetails = 'CascadeItemDetailsRoute';
  static const autoRouteUsage = 'AutoRouteUsageRoute';
  static const autoRouteBooks = 'AutoRouteBooksRoute';
  static const autoRouteBookDetails = 'AutoRouteBookDetailsRoute';
  static const autoRouteNested = 'AutoRouteNestedRoute';
  static const autoRouteNestedBooks = 'AutoRouteBooksTabRoute';
  static const autoRouteNestedProfile = 'AutoRouteProfileTabRoute';
  static const autoRouteNestedSettings = 'AutoRouteSettingsTabRoute';
  static const autoRouteProduct = 'AutoRouteProductRoute';
  static const autoRouteProductOverview = 'AutoRouteProductOverviewRoute';
  static const autoRouteProductReview = 'AutoRouteProductReviewRoute';
  static const autoRouteArticle = 'AutoRouteArticleRoute';
  static const autoRouteProtected = 'AutoRouteProtectedRoute';
  static const autoRouteGlobalProtected = 'AutoRouteGlobalProtectedRoute';
  static const autoRouteProfile = 'ProfileRoute';
  static const autoRouteWrapped = 'AutoRouteWrappedRoute';
  static const autoRouteObserver = 'AutoRouteObserverRoute';
  static const autoRouteLogin = 'AutoRouteLoginRoute';
  static const autoRouteSignup = 'AutoRouteSignupRoute';
  static const autoRouteUnknown = 'AutoRouteUnknownRoute';
  static const animateDo = 'AnimateDoRoute';
  static const intl = 'IntlRoute';
  static const jnigen = 'JnigenRoute';
  static const characters = 'CharactersRoute';
  static const chatBubbles = 'ChatBubblesRoute';
  static const chopper = 'ChopperRoute';
  static const cookieJar = 'CookieJarRoute';
  static const switchExample = 'SwitchExampleRoute';
  static const checkbox = 'CheckboxExampleRoute';
  static const clipboard = 'ClipboardRoute';
  static const radio = 'RadioExampleRoute';
  static const inputChip = 'InputChipRoute';
  static const choiceChip = 'ChoiceChipRoute';
  static const filterChip = 'FilterChipRoute';
  static const aboutDialog = 'AboutDialogRoute';
  static const advancedProgressIndicator = 'AdvancedProgressIndicatorRoute';
  static const animatedListTile = 'AnimatedListTileRoute';
  static const ffigen = 'FfigenRoute';
  static const flash = 'FlashRoute';
  static const flexColorScheme = 'FlexColorSchemeRoute';
  static const flexSeedScheme = 'FlexSeedSchemeRoute';
  static const actionChip = 'ActionChipRoute';
  static const linearProgressIndicator = 'LinearProgressIndicatorExampleRoute';
  static const localAuth = 'LocalAuthRoute';
  static const lootReel = 'LootReelRoute';
  static const lucideIconsFlutter = 'LucideIconsFlutterRoute';
  static const lottie = 'LottieRoute';
  static const fluentUi = 'FluentUiRoute';
  static const materialColorUtilities = 'MaterialColorUtilitiesRoute';
  static const materialStateProperty = 'MaterialStatePropertyRoute';
  static const macosUi = 'MacosUiRoute';
  static const circularProgressIndicator =
      'CircularProgressIndicatorExampleRoute';
  static const crypto = 'CryptoRoute';
  static const cue = 'CueRoute';
  static const slider = 'SliderExampleRoute';
  static const sensorsPlus = 'SensorsPlusRoute';
  static const shadcnUi = 'ShadcnUiRoute';
  static const shaderGraph = 'ShaderGraphRoute';
  static const datePicker = 'DatePickerRoute';
  static const datePickerDialog = 'DatePickerDialogRoute';
  static const timePicker = 'TimePickerRoute';
  static const timePickerDialog = 'TimePickerDialogRoute';
  static const timeagoFlutter = 'TimeagoFlutterRoute';
  static const toggleSwitch = 'ToggleSwitchRoute';
  static const urlLauncher = 'UrlLauncherRoute';
  static const wasmFfi = 'WasmFfiRoute';
  static const webviewFlutter = 'WebviewFlutterRoute';
  static const form = 'FormRoute';
  static const formField = 'FormFieldRoute';
  static const draggable = 'DraggableExampleRoute';
  static const dragTarget = 'DragTargetExampleRoute';
  static const expandableSection = 'ExpandableSectionRoute';
  static const richText = 'RichTextRoute';
  static const expansionPanelList = 'ExpansionPanelListRoute';
  static const tdesignFlutter = 'TdesignFlutterRoute';
  static const textStyle = 'TextStyleRoute';
  static const themeDataVisualDensity = 'ThemeDataVisualDensityRoute';
  static const bottomNavigationBar = 'BottomNavigationBarExampleRoute';
  static const binarize = 'BinarizeRoute';
  static const binarySerializable = 'BinarySerializableRoute';
  static const builtValue = 'BuiltValueRoute';
  static const floatingActionButton = 'FloatingActionButtonExampleRoute';
  static const focusableActionDetector = 'FocusableActionDetectorRoute';
  static const focusTraversalGroup = 'FocusTraversalGroupRoute';
  static const snackBar = 'SnackBarExampleRoute';
  static const showDialog = 'ShowDialogExampleRoute';
  static const alertDialog = 'AlertDialogExampleRoute';
  static const simpleDialog = 'SimpleDialogExampleRoute';
  static const dialog = 'DialogExampleRoute';
  static const dio = 'DioRoute';
  static const dioSmartRetry = 'DioSmartRetryRoute';
  static const dioMultiUrl = 'DioMultiUrlRoute';
  static const dottedBorder = 'DottedBorderRoute';
  static const drawer = 'DrawerRoute';
  static const futureBuilder = 'FutureBuilderRoute';
  static const genui = 'GenuiRoute';
  static const flutterBloc = 'FlutterBlocRoute';
  static const flutterCardSwiper = 'FlutterCardSwiperRoute';
  static const flutterCustomTabs = 'FlutterCustomTabsRoute';
  static const flutterDebounceThrottle = 'FlutterDebounceThrottleRoute';
  static const flutterDotenv = 'FlutterDotenvRoute';
  static const flutterHooks = 'FlutterHooksRoute';
  static const flutterInappwebview = 'FlutterInappwebviewRoute';
  static const interactiveCard = 'InteractiveCardRoute';
  static const flutterTts = 'FlutterTtsRoute';
  static const freezedAnnotation = 'FreezedAnnotationRoute';
  static const graphqlFlutter = 'GraphqlFlutterRoute';
  static const hero = 'HeroRoute';
  static const hugeicons = 'HugeiconsRoute';
  static const imageCropper = 'ImageCropperRoute';
  static const iconly = 'IconlyRoute';
  static const injectableGetIt = 'InjectableGetItRoute';
  static const injectable = 'InjectableRoute';
  static const iPhoneLikeFloatingButton = 'IPhoneLikeFloatingButtonRoute';
  static const infiniteScrollPagination = 'InfiniteScrollPaginationRoute';
  static const introductionScreen = 'IntroductionScreenRoute';
  static const jsonAnnotation = 'JsonAnnotationRoute';
  static const overlayMenu = 'OverlayMenuRoute';
  static const streamBuilder = 'StreamBuilderRoute';
  static const driftFlutter = 'DriftFlutterRoute';
  static const dynamicColor = 'DynamicColorRoute';
  static const encrypterPlus = 'EncrypterPlusRoute';
  static const extendedImage = 'ExtendedImageRoute';
  static const fluttertoast = 'FluttertoastRoute';
  static const keyboardListener = 'KeyboardListenerRoute';
  static const inkWidgets = 'InkWidgetsRoute';
  static const mediaQuery = 'MediaQueryRoute';
  static const mouseRegion = 'MouseRegionRoute';
  static const nativeDeviceOrientationCommunicator =
      'NativeDeviceOrientationCommunicatorRoute';
  static const nativeDeviceOrientationOrientedWidget =
      'NativeDeviceOrientationOrientedWidgetRoute';
  static const nativeDeviceOrientationReader =
      'NativeDeviceOrientationReaderRoute';
  static const textRich = 'TextRichRoute';
  static const singleChildScrollView = 'SingleChildScrollViewRoute';
  static const sliverWidgets = 'SliverExamplesRoute';
  static const scrollbar = 'ScrollbarRoute';
  static const filledButton = 'FilledButtonRoute';
  static const fittedBox = 'FittedBoxRoute';
  static const decoratedBox = 'DecoratedBoxRoute';
  static const blockSemantics = 'BlockSemanticsRoute';
  static const semantics = 'SemanticsRoute';
  static const excludeSemantics = 'ExcludeSemanticsRoute';
  static const mergeSemantics = 'MergeSemanticsRoute';
  static const onboardingOverlay = 'OnboardingOverlayRoute';
  static const openFile = 'OpenFileRoute';
  static const permissionHandler = 'PermissionHandlerRoute';
  static const packageInfoPlus = 'PackageInfoPlusRoute';
  static const pinput = 'PinputRoute';
  static const pigeon = 'PigeonRoute';
  static const popScope = 'PopScopeRoute';
  static const speechToText = 'SpeechToTextRoute';
  static const shimmer = 'ShimmerRoute';
  static const syncfusionFlutterCharts = 'SyncfusionFlutterChartsRoute';
  static const smoothPageIndicator = 'SmoothPageIndicatorRoute';
  static const superClipboard = 'SuperClipboardRoute';
  static const sharedPreferences = 'SharedPreferencesRoute';
  static const sharePlus = 'SharePlusRoute';
  static const textFieldController = 'TextFieldControllerRoute';
  static const flutterAutoSizeText = 'FlutterAutoSizeTextRoute';
  static const flutterAnimate = 'FlutterAnimateRoute';
  static const flutterLocalNotifications = 'FlutterLocalNotificationsRoute';
  static const flutterScreenutil = 'FlutterScreenutilRoute';
  static const flutterSecureStorage = 'FlutterSecureStorageRoute';
  static const flutterTimezone = 'FlutterTimezoneRoute';
  static const tooltip = 'TooltipRoute';
  static const animatedTextKit = 'AnimatedTextKitRoute';
  static const animationsPackage = 'AnimationsPackageRoute';
  static const universalHtml = 'UniversalHtmlRoute';
  static const fcNativeVideoThumbnail = 'FcNativeVideoThumbnailRoute';
  static const flutterSlidable = 'FlutterSlidableRoute';
  static const flutterVideoCachingFvp = 'FlutterVideoCachingFvpRoute';
  static const cachedNetworkImageCe = 'CachedNetworkImageCeRoute';
  static const dataTable = 'DataTableRoute';
  static const flChart = 'FlChartRoute';
  static const fontAwesomeFlutter = 'FontAwesomeFlutterRoute';
  static const forui = 'ForuiRoute';
  static const materialSymbolsIcons = 'MaterialSymbolsIconsRoute';
  static const imageWidget = 'ImageWidgetRoute';
  static const animatedSwitcher = 'AnimatedSwitcherRoute';
  static const animatedToggleSwitch = 'AnimatedToggleSwitchRoute';
  static const animatedDefaultTextStyle = 'AnimatedDefaultTextStyleRoute';
  static const customPaint = 'CustomPaintRoute';
  static const tweenAnimationBuilder = 'TweenAnimationBuilderRoute';
  static const animationController = 'AnimationControllerRoute';
  static const singleTickerProviderStateMixin =
      'SingleTickerProviderStateMixinRoute';
  static const tween = 'TweenRoute';
  static const tweenSequenceInterval = 'TweenSequenceIntervalRoute';
  static const flutterSvg = 'FlutterSvgRoute';
}

enum AppRoute {
  /// Route definitions combining path and route name.
  ///
  /// Usage: `AppRoute.login.path` for the URL path,
  ///        `RouteName.login` for compile-time const route name (annotations).
  ///        `AppRoute.login.routeName` for runtime route name access.
  login('/login', RouteName.login),
  home('/', RouteName.home),
  homeLayout('layout', RouteName.homeLayout),
  homeContent('content', RouteName.homeContent),
  homeAnimation('animation', RouteName.homeAnimation),
  aspectRatio('/aspect-ratio-page', RouteName.aspectRatio),
  centerBox('/center-box', RouteName.centerBox),
  constrainedBox('/constrained-box', RouteName.constrainedBox),
  container('/container-page', RouteName.container),
  unconstrainedBox('/unconstrained-box-page', RouteName.unconstrainedBox),
  rowExpanded('/row-expand-page', RouteName.rowExpanded),
  expanded('/expanded-page', RouteName.expanded),
  flexible('/flexible-page', RouteName.flexible),
  gesturedector('/gesturedector-page', RouteName.gesturedector),
  column('/column-page', RouteName.column),
  columnSaved('/column-saved-page', RouteName.columnSaved),
  columnSavedStateless(
    '/column-saved-stateless-page',
    RouteName.columnSavedStateless,
  ),
  flow('/flow-page', RouteName.flow),
  fractionallySizedBox(
    '/fractionally-sized-box-page',
    RouteName.fractionallySizedBox,
  ),
  layoutBuilder('/layout-builder-page', RouteName.layoutBuilder),
  orientationBuilder('/orientation-builder-page', RouteName.orientationBuilder),
  padding('/padding-page', RouteName.padding),
  spacer('/spacer-page', RouteName.spacer),
  responsiveContainer(
    '/responsive-container-page',
    RouteName.responsiveContainer,
  ),
  wrap('/wrap-page', RouteName.wrap),
  positioned('/positioned-page', RouteName.positioned),
  sizedBox('/sized-box-page', RouteName.sizedBox),
  stack('/stack-page', RouteName.stack),
  align('/align-page', RouteName.align),
  transform('/transform-page', RouteName.transform),
  rotatedBox('/rotated-box-page', RouteName.rotatedBox),
  safeArea('/safe-area-page', RouteName.safeArea),
  indexedStack('/indexed-stack-page', RouteName.indexedStack),
  sliverList('/sliver-list-page', RouteName.sliverList),
  sliverGrid('/sliver-grid-page', RouteName.sliverGrid),
  sliverAppBar('/sliver-app-bar-page', RouteName.sliverAppBar),
  sliverSnap('/sliver-snap-page', RouteName.sliverSnap),
  sliverToBoxAdapter(
    '/sliver-to-box-adapter-page',
    RouteName.sliverToBoxAdapter,
  ),
  sliverPadding('/sliver-padding-page', RouteName.sliverPadding),
  clipOval('/clip-oval-page', RouteName.clipOval),
  clipRRect('/clip-r-rect-page', RouteName.clipRRect),
  clipRect('/clip-rect-page', RouteName.clipRect),
  clipPath('/clip-path-page', RouteName.clipPath),
  customClipper('/custom-clipper-page', RouteName.customClipper),
  customMultiChildLayout(
    '/custom-multi-child-layout-page',
    RouteName.customMultiChildLayout,
  ),
  table('/table-page', RouteName.table),
  classicButtons('/classic-buttons-page', RouteName.classicButtons),
  cascade('/cascade', RouteName.cascade),
  cascadeCategories('/cascade/categories', RouteName.cascadeCategories),
  cascadeCategoryDetails(
    '/cascade/categories/:categoryId',
    RouteName.cascadeCategoryDetails,
  ),
  cascadeSubcategoryItems(
    '/cascade/categories/:categoryId/:subcategoryName',
    RouteName.cascadeSubcategoryItems,
  ),
  cascadeItemDetails(
    '/cascade/categories/:categoryId/:subcategoryName/:itemId',
    RouteName.cascadeItemDetails,
  ),
  autoRouteUsage('/auto-route-page', RouteName.autoRouteUsage),
  autoRouteLegacy('/auto-route-page/legacy', ''),
  autoRouteBooks('/auto-route-page/books', RouteName.autoRouteBooks),
  autoRouteBookLegacy('/auto-route-page/books/:id/legacy', ''),
  autoRouteBookDetails(
    '/auto-route-page/books/:id',
    RouteName.autoRouteBookDetails,
  ),
  autoRouteNested('/auto-route-page/nested', RouteName.autoRouteNested),
  autoRouteNestedBooks('books', RouteName.autoRouteNestedBooks),
  autoRouteNestedProfile('profile', RouteName.autoRouteNestedProfile),
  autoRouteNestedSettings('settings', RouteName.autoRouteNestedSettings),
  autoRouteProduct('/auto-route-page/products/:id', RouteName.autoRouteProduct),
  autoRouteProductOverview('', RouteName.autoRouteProductOverview),
  autoRouteProductReview('review', RouteName.autoRouteProductReview),
  autoRouteArticle(
    '/auto-route-page/articles/:category/:slug',
    RouteName.autoRouteArticle,
  ),
  autoRouteProtected(
    '/auto-route-page/protected',
    RouteName.autoRouteProtected,
  ),
  autoRouteGlobalProtected(
    '/auto-route-page/global-protected',
    RouteName.autoRouteGlobalProtected,
  ),
  autoRouteProfile('/auto-route-page/profile', RouteName.autoRouteProfile),
  autoRouteWrapped('/auto-route-page/wrapped', RouteName.autoRouteWrapped),
  autoRouteObserver('/auto-route-page/observer', RouteName.autoRouteObserver),
  autoRouteLogin('/auto-route-page/login', RouteName.autoRouteLogin),
  autoRouteSignup('/auto-route-page/signup', RouteName.autoRouteSignup),
  autoRouteUnknown('/auto-route-page/*', RouteName.autoRouteUnknown),
  animateDo('/animate-do-page', RouteName.animateDo),
  intl('/intl-page', RouteName.intl),
  jnigen('/jnigen-page', RouteName.jnigen),
  characters('/characters-page', RouteName.characters),
  chatBubbles('/chat-bubbles-page', RouteName.chatBubbles),
  chopper('/chopper-page', RouteName.chopper),
  cookieJar('/cookie-jar-page', RouteName.cookieJar),
  switchExample('/switch-page', RouteName.switchExample),
  checkbox('/checkbox-page', RouteName.checkbox),
  clipboard('/clipboard-page', RouteName.clipboard),
  radio('/radio-page', RouteName.radio),
  inputChip('/input-chip-page', RouteName.inputChip),
  choiceChip('/choice-chip-page', RouteName.choiceChip),
  filterChip('/filter-chip-page', RouteName.filterChip),
  aboutDialog('/about-dialog-page', RouteName.aboutDialog),
  advancedProgressIndicator(
    '/advanced-progress-indicator-page',
    RouteName.advancedProgressIndicator,
  ),
  animatedListTile('/animated-list-tile-page', RouteName.animatedListTile),
  ffigen('/ffigen-page', RouteName.ffigen),
  flash('/flash-page', RouteName.flash),
  flexColorScheme('/flex-color-scheme-page', RouteName.flexColorScheme),
  flexSeedScheme('/flex-seed-scheme-page', RouteName.flexSeedScheme),
  actionChip('/action-chip-page', RouteName.actionChip),
  linearProgressIndicator(
    '/linear-progress-indicator-page',
    RouteName.linearProgressIndicator,
  ),
  localAuth('/local-auth-page', RouteName.localAuth),
  lootReel('/loot-reel-page', RouteName.lootReel),
  lucideIconsFlutter(
    '/lucide-icons-flutter-page',
    RouteName.lucideIconsFlutter,
  ),
  lottie('/lottie-page', RouteName.lottie),
  fluentUi('/fluent-ui-page', RouteName.fluentUi),
  materialColorUtilities(
    '/material-color-utilities-page',
    RouteName.materialColorUtilities,
  ),
  materialStateProperty(
    '/material-state-property-page',
    RouteName.materialStateProperty,
  ),
  macosUi('/macos-ui-page', RouteName.macosUi),
  circularProgressIndicator(
    '/circular-progress-indicator-page',
    RouteName.circularProgressIndicator,
  ),
  crypto('/crypto-page', RouteName.crypto),
  cue('/cue-page', RouteName.cue),
  slider('/slider-page', RouteName.slider),
  sensorsPlus('/sensors-plus-page', RouteName.sensorsPlus),
  shadcnUi('/shadcn-ui-page', RouteName.shadcnUi),
  shaderGraph('/shader-graph-page', RouteName.shaderGraph),
  datePicker('/date-picker-page', RouteName.datePicker),
  datePickerDialog('/date-picker-dialog-page', RouteName.datePickerDialog),
  timeagoFlutter('/timeago-flutter-page', RouteName.timeagoFlutter),
  timePicker('/time-picker-page', RouteName.timePicker),
  timePickerDialog('/time-picker-dialog-page', RouteName.timePickerDialog),
  toggleSwitch('/toggle-switch-page', RouteName.toggleSwitch),
  urlLauncher('/url-launcher-page', RouteName.urlLauncher),
  wasmFfi('/wasm-ffi-page', RouteName.wasmFfi),
  webviewFlutter('/webview-flutter-page', RouteName.webviewFlutter),
  form('/form-page', RouteName.form),
  formField('/form-field-page', RouteName.formField),
  draggable('/draggable-page', RouteName.draggable),
  dragTarget('/drag-target-page', RouteName.dragTarget),
  expandableSection('/expandable-section-page', RouteName.expandableSection),
  expansionPanelList(
    '/expansion-panel-list-page',
    RouteName.expansionPanelList,
  ),
  richText('/rich-text-page', RouteName.richText),
  tdesignFlutter('/tdesign-flutter-page', RouteName.tdesignFlutter),
  textStyle('/text-style-page', RouteName.textStyle),
  themeDataVisualDensity(
    '/theme-data-visual-density-page',
    RouteName.themeDataVisualDensity,
  ),
  bottomNavigationBar(
    '/bottom-navigation-bar-page',
    RouteName.bottomNavigationBar,
  ),
  binarize('/binarize-page', RouteName.binarize),
  binarySerializable('/binary-serializable-page', RouteName.binarySerializable),
  builtValue('/built-value-page', RouteName.builtValue),
  floatingActionButton(
    '/floating-action-button-page',
    RouteName.floatingActionButton,
  ),
  focusableActionDetector(
    '/focusable-action-detector-page',
    RouteName.focusableActionDetector,
  ),
  focusTraversalGroup(
    '/focus-traversal-group-page',
    RouteName.focusTraversalGroup,
  ),
  snackBar('/snack-bar-page', RouteName.snackBar),
  showDialog('/show-dialog-page', RouteName.showDialog),
  alertDialog('/alert-dialog-page', RouteName.alertDialog),
  simpleDialog('/simple-dialog-page', RouteName.simpleDialog),
  dialog('/dialog-page', RouteName.dialog),
  dio('/dio-page', RouteName.dio),
  dioSmartRetry('/dio-smart-retry-page', RouteName.dioSmartRetry),
  dioMultiUrl('/dio-multi-url-page', RouteName.dioMultiUrl),
  dottedBorder('/dotted-border-page', RouteName.dottedBorder),
  drawer('/drawer-page', RouteName.drawer),
  futureBuilder('/future-builder-page', RouteName.futureBuilder),
  genui('/genui-page', RouteName.genui),
  flutterBloc('/flutter-bloc-page', RouteName.flutterBloc),
  flutterCardSwiper('/flutter-card-swiper-page', RouteName.flutterCardSwiper),
  flutterCustomTabs('/flutter-custom-tabs-page', RouteName.flutterCustomTabs),
  flutterDebounceThrottle(
    '/flutter-debounce-throttle-page',
    RouteName.flutterDebounceThrottle,
  ),
  flutterDotenv('/flutter-dotenv-page', RouteName.flutterDotenv),
  flutterHooks('/flutter-hooks-page', RouteName.flutterHooks),
  flutterInappwebview(
    '/flutter-inappwebview-page',
    RouteName.flutterInappwebview,
  ),
  interactiveCard('/interactive-card-page', RouteName.interactiveCard),
  flutterTts('/flutter-tts-page', RouteName.flutterTts),
  freezedAnnotation('/freezed-annotation-page', RouteName.freezedAnnotation),
  graphqlFlutter('/graphql-flutter-page', RouteName.graphqlFlutter),
  hero('/hero-page', RouteName.hero),
  hugeicons('/hugeicons-page', RouteName.hugeicons),
  imageCropper('/image-cropper-page', RouteName.imageCropper),
  iconly('/iconly-page', RouteName.iconly),
  injectableGetIt('/injectable-get-it-page', RouteName.injectableGetIt),
  injectable('/injectable-page', RouteName.injectable),
  iPhoneLikeFloatingButton(
    '/iphone-like-floating-button-page',
    RouteName.iPhoneLikeFloatingButton,
  ),
  infiniteScrollPagination(
    '/infinite-scroll-pagination-page',
    RouteName.infiniteScrollPagination,
  ),
  introductionScreen('/introduction-screen-page', RouteName.introductionScreen),
  jsonAnnotation('/json-annotation-page', RouteName.jsonAnnotation),
  overlayMenu('/overlay-menu-page', RouteName.overlayMenu),
  streamBuilder('/stream-builder-page', RouteName.streamBuilder),
  driftFlutter('/drift-flutter-page', RouteName.driftFlutter),
  dynamicColor('/dynamic-color-page', RouteName.dynamicColor),
  encrypterPlus('/encrypter-plus-page', RouteName.encrypterPlus),
  extendedImage('/extended-image-page', RouteName.extendedImage),
  fluttertoast('/fluttertoast-page', RouteName.fluttertoast),
  keyboardListener('/keyboard-listener-page', RouteName.keyboardListener),
  inkWidgets('/ink-widgets-page', RouteName.inkWidgets),
  mediaQuery('/media-query-page', RouteName.mediaQuery),
  mouseRegion('/mouse-region-page', RouteName.mouseRegion),
  nativeDeviceOrientationCommunicator(
    '/native-device-orientation-communicator-page',
    RouteName.nativeDeviceOrientationCommunicator,
  ),
  nativeDeviceOrientationOrientedWidget(
    '/native-device-orientation-oriented-widget-page',
    RouteName.nativeDeviceOrientationOrientedWidget,
  ),
  nativeDeviceOrientationReader(
    '/native-device-orientation-reader-page',
    RouteName.nativeDeviceOrientationReader,
  ),
  textRich('/text-rich-page', RouteName.textRich),
  singleChildScrollView(
    '/single-child-scroll-view-page',
    RouteName.singleChildScrollView,
  ),
  sliverWidgets('/sliver-widgets-page', RouteName.sliverWidgets),
  scrollbar('/scrollbar-page', RouteName.scrollbar),
  filledButton('/filled-button-page', RouteName.filledButton),
  fittedBox('/fitted-box-page', RouteName.fittedBox),
  decoratedBox('/decorated-box-page', RouteName.decoratedBox),
  blockSemantics('/block-semantics-page', RouteName.blockSemantics),
  semantics('/semantics-page', RouteName.semantics),
  excludeSemantics('/exclude-semantics-page', RouteName.excludeSemantics),
  mergeSemantics('/merge-semantics-page', RouteName.mergeSemantics),
  onboardingOverlay('/onboarding-overlay-page', RouteName.onboardingOverlay),
  openFile('/open-file-page', RouteName.openFile),
  permissionHandler('/permission-handler-page', RouteName.permissionHandler),
  packageInfoPlus('/package-info-plus-page', RouteName.packageInfoPlus),
  pinput('/pinput-page', RouteName.pinput),
  pigeon('/pigeon-page', RouteName.pigeon),
  popScope('/pop-scope-page', RouteName.popScope),
  speechToText('/speech-to-text-page', RouteName.speechToText),
  shimmer('/shimmer-page', RouteName.shimmer),
  syncfusionFlutterCharts(
    '/syncfusion-flutter-charts-page',
    RouteName.syncfusionFlutterCharts,
  ),
  smoothPageIndicator(
    '/smooth-page-indicator-page',
    RouteName.smoothPageIndicator,
  ),
  superClipboard('/super-clipboard-page', RouteName.superClipboard),
  sharedPreferences('/shared-preferences-page', RouteName.sharedPreferences),
  sharePlus('/share-plus-page', RouteName.sharePlus),
  textFieldController(
    '/text-field-controller-page',
    RouteName.textFieldController,
  ),
  flutterAutoSizeText(
    '/flutter-auto-size-text-page',
    RouteName.flutterAutoSizeText,
  ),
  flutterAnimate('/flutter-animate-page', RouteName.flutterAnimate),
  flutterLocalNotifications(
    '/flutter-local-notifications-page',
    RouteName.flutterLocalNotifications,
  ),
  flutterScreenutil('/flutter-screenutil-page', RouteName.flutterScreenutil),
  flutterSecureStorage(
    '/flutter-secure-storage-page',
    RouteName.flutterSecureStorage,
  ),
  flutterTimezone('/flutter-timezone-page', RouteName.flutterTimezone),
  tooltip('/tooltip-page', RouteName.tooltip),
  animatedTextKit('/animated-text-kit-page', RouteName.animatedTextKit),
  animationsPackage('/animations-page', RouteName.animationsPackage),
  universalHtml('/universal-html-page', RouteName.universalHtml),
  fcNativeVideoThumbnail(
    '/fc-native-video-thumbnail-page',
    RouteName.fcNativeVideoThumbnail,
  ),
  flutterSlidable('/flutter-slidable-page', RouteName.flutterSlidable),
  flutterVideoCachingFvp(
    '/flutter-video-caching-fvp-page',
    RouteName.flutterVideoCachingFvp,
  ),
  cachedNetworkImageCe(
    '/cached-network-image-ce-page',
    RouteName.cachedNetworkImageCe,
  ),
  dataTable('/data-table-page', RouteName.dataTable),
  flChart('/fl-chart-page', RouteName.flChart),
  fontAwesomeFlutter(
    '/font-awesome-flutter-page',
    RouteName.fontAwesomeFlutter,
  ),
  forui('/forui-page', RouteName.forui),
  materialSymbolsIcons(
    '/material-symbols-icons-page',
    RouteName.materialSymbolsIcons,
  ),
  imageWidget('/image-widget-page', RouteName.imageWidget),
  animatedSwitcher('/animated-switcher-page', RouteName.animatedSwitcher),
  animatedToggleSwitch(
    '/animated-toggle-switch-page',
    RouteName.animatedToggleSwitch,
  ),
  animatedDefaultTextStyle(
    '/animated-default-text-style-page',
    RouteName.animatedDefaultTextStyle,
  ),
  customPaint('/custom-paint-page', RouteName.customPaint),
  tweenAnimationBuilder(
    '/tween-animation-builder-page',
    RouteName.tweenAnimationBuilder,
  ),
  animationController(
    '/animation-controller-page',
    RouteName.animationController,
  ),
  singleTickerProviderStateMixin(
    '/single-ticker-provider-state-mixin-page',
    RouteName.singleTickerProviderStateMixin,
  ),
  tween('/tween-page', RouteName.tween),
  tweenSequenceInterval(
    '/tween-sequence-interval-page',
    RouteName.tweenSequenceInterval,
  ),
  flutterSvg('/flutter-svg-page', RouteName.flutterSvg);

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
