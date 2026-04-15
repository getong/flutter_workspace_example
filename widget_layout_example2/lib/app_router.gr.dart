// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ActionChipPage]
class ActionChipRoute extends PageRouteInfo<void> {
  const ActionChipRoute({List<PageRouteInfo>? children})
    : super(ActionChipRoute.name, initialChildren: children);

  static const String name = 'ActionChipRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ActionChipPage();
    },
  );
}

/// generated route for
/// [AlertDialogExamplePage]
class AlertDialogExampleRoute extends PageRouteInfo<void> {
  const AlertDialogExampleRoute({List<PageRouteInfo>? children})
    : super(AlertDialogExampleRoute.name, initialChildren: children);

  static const String name = 'AlertDialogExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AlertDialogExamplePage();
    },
  );
}

/// generated route for
/// [AlignPage]
class AlignRoute extends PageRouteInfo<void> {
  const AlignRoute({List<PageRouteInfo>? children})
    : super(AlignRoute.name, initialChildren: children);

  static const String name = 'AlignRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AlignPage();
    },
  );
}

/// generated route for
/// [AnimatedDefaultTextStylePage]
class AnimatedDefaultTextStyleRoute extends PageRouteInfo<void> {
  const AnimatedDefaultTextStyleRoute({List<PageRouteInfo>? children})
    : super(AnimatedDefaultTextStyleRoute.name, initialChildren: children);

  static const String name = 'AnimatedDefaultTextStyleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AnimatedDefaultTextStylePage();
    },
  );
}

/// generated route for
/// [AnimatedSwitcherPage]
class AnimatedSwitcherRoute extends PageRouteInfo<void> {
  const AnimatedSwitcherRoute({List<PageRouteInfo>? children})
    : super(AnimatedSwitcherRoute.name, initialChildren: children);

  static const String name = 'AnimatedSwitcherRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AnimatedSwitcherPage();
    },
  );
}

/// generated route for
/// [AnimatedToggleSwitchPage]
class AnimatedToggleSwitchRoute extends PageRouteInfo<void> {
  const AnimatedToggleSwitchRoute({List<PageRouteInfo>? children})
    : super(AnimatedToggleSwitchRoute.name, initialChildren: children);

  static const String name = 'AnimatedToggleSwitchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AnimatedToggleSwitchPage();
    },
  );
}

/// generated route for
/// [AnimationControllerPage]
class AnimationControllerRoute extends PageRouteInfo<void> {
  const AnimationControllerRoute({List<PageRouteInfo>? children})
    : super(AnimationControllerRoute.name, initialChildren: children);

  static const String name = 'AnimationControllerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AnimationControllerPage();
    },
  );
}

/// generated route for
/// [AnimationTabPage]
class AnimationTabRoute extends PageRouteInfo<void> {
  const AnimationTabRoute({List<PageRouteInfo>? children})
    : super(AnimationTabRoute.name, initialChildren: children);

  static const String name = 'AnimationTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AnimationTabPage();
    },
  );
}

/// generated route for
/// [AspectRatioPage]
class AspectRatioRoute extends PageRouteInfo<void> {
  const AspectRatioRoute({List<PageRouteInfo>? children})
    : super(AspectRatioRoute.name, initialChildren: children);

  static const String name = 'AspectRatioRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AspectRatioPage();
    },
  );
}

/// generated route for
/// [AutoRouteArticlePage]
class AutoRouteArticleRoute extends PageRouteInfo<AutoRouteArticleRouteArgs> {
  AutoRouteArticleRoute({
    Key? key,
    required String category,
    required String slug,
    String? ref,
    List<PageRouteInfo>? children,
  }) : super(
         AutoRouteArticleRoute.name,
         args: AutoRouteArticleRouteArgs(
           key: key,
           category: category,
           slug: slug,
           ref: ref,
         ),
         rawPathParams: {'category': category, 'slug': slug},
         rawQueryParams: {'ref': ref},
         initialChildren: children,
       );

  static const String name = 'AutoRouteArticleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<AutoRouteArticleRouteArgs>(
        orElse: () => AutoRouteArticleRouteArgs(
          category: pathParams.getString('category'),
          slug: pathParams.getString('slug'),
          ref: queryParams.optString('ref'),
        ),
      );
      return AutoRouteArticlePage(
        key: args.key,
        category: args.category,
        slug: args.slug,
        ref: args.ref,
      );
    },
  );
}

class AutoRouteArticleRouteArgs {
  const AutoRouteArticleRouteArgs({
    this.key,
    required this.category,
    required this.slug,
    this.ref,
  });

  final Key? key;

  final String category;

  final String slug;

  final String? ref;

  @override
  String toString() {
    return 'AutoRouteArticleRouteArgs{key: $key, category: $category, slug: $slug, ref: $ref}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AutoRouteArticleRouteArgs) return false;
    return key == other.key &&
        category == other.category &&
        slug == other.slug &&
        ref == other.ref;
  }

  @override
  int get hashCode =>
      key.hashCode ^ category.hashCode ^ slug.hashCode ^ ref.hashCode;
}

/// generated route for
/// [AutoRouteBookDetailsPage]
class AutoRouteBookDetailsRoute
    extends PageRouteInfo<AutoRouteBookDetailsRouteArgs> {
  AutoRouteBookDetailsRoute({
    Key? key,
    required int id,
    String? tab,
    String? filter,
    List<PageRouteInfo>? children,
  }) : super(
         AutoRouteBookDetailsRoute.name,
         args: AutoRouteBookDetailsRouteArgs(
           key: key,
           id: id,
           tab: tab,
           filter: filter,
         ),
         rawPathParams: {'id': id},
         rawQueryParams: {'tab': tab, 'filter': filter},
         initialChildren: children,
       );

  static const String name = 'AutoRouteBookDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<AutoRouteBookDetailsRouteArgs>(
        orElse: () => AutoRouteBookDetailsRouteArgs(
          id: pathParams.getInt('id'),
          tab: queryParams.optString('tab'),
          filter: queryParams.optString('filter'),
        ),
      );
      return AutoRouteBookDetailsPage(
        key: args.key,
        id: args.id,
        tab: args.tab,
        filter: args.filter,
      );
    },
  );
}

class AutoRouteBookDetailsRouteArgs {
  const AutoRouteBookDetailsRouteArgs({
    this.key,
    required this.id,
    this.tab,
    this.filter,
  });

  final Key? key;

  final int id;

  final String? tab;

  final String? filter;

  @override
  String toString() {
    return 'AutoRouteBookDetailsRouteArgs{key: $key, id: $id, tab: $tab, filter: $filter}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AutoRouteBookDetailsRouteArgs) return false;
    return key == other.key &&
        id == other.id &&
        tab == other.tab &&
        filter == other.filter;
  }

  @override
  int get hashCode =>
      key.hashCode ^ id.hashCode ^ tab.hashCode ^ filter.hashCode;
}

/// generated route for
/// [AutoRouteBooksPage]
class AutoRouteBooksRoute extends PageRouteInfo<void> {
  const AutoRouteBooksRoute({List<PageRouteInfo>? children})
    : super(AutoRouteBooksRoute.name, initialChildren: children);

  static const String name = 'AutoRouteBooksRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoRouteBooksPage();
    },
  );
}

/// generated route for
/// [AutoRouteBooksTabPage]
class AutoRouteBooksTabRoute extends PageRouteInfo<void> {
  const AutoRouteBooksTabRoute({List<PageRouteInfo>? children})
    : super(AutoRouteBooksTabRoute.name, initialChildren: children);

  static const String name = 'AutoRouteBooksTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoRouteBooksTabPage();
    },
  );
}

/// generated route for
/// [AutoRouteGlobalProtectedPage]
class AutoRouteGlobalProtectedRoute extends PageRouteInfo<void> {
  const AutoRouteGlobalProtectedRoute({List<PageRouteInfo>? children})
    : super(AutoRouteGlobalProtectedRoute.name, initialChildren: children);

  static const String name = 'AutoRouteGlobalProtectedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoRouteGlobalProtectedPage();
    },
  );
}

/// generated route for
/// [AutoRouteLoginPage]
class AutoRouteLoginRoute extends PageRouteInfo<AutoRouteLoginRouteArgs> {
  AutoRouteLoginRoute({
    Key? key,
    void Function(bool)? onResult,
    List<PageRouteInfo>? children,
  }) : super(
         AutoRouteLoginRoute.name,
         args: AutoRouteLoginRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'AutoRouteLoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AutoRouteLoginRouteArgs>(
        orElse: () => const AutoRouteLoginRouteArgs(),
      );
      return AutoRouteLoginPage(key: args.key, onResult: args.onResult);
    },
  );
}

class AutoRouteLoginRouteArgs {
  const AutoRouteLoginRouteArgs({this.key, this.onResult});

  final Key? key;

  final void Function(bool)? onResult;

  @override
  String toString() {
    return 'AutoRouteLoginRouteArgs{key: $key, onResult: $onResult}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AutoRouteLoginRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [AutoRouteNestedPage]
class AutoRouteNestedRoute extends PageRouteInfo<void> {
  const AutoRouteNestedRoute({List<PageRouteInfo>? children})
    : super(AutoRouteNestedRoute.name, initialChildren: children);

  static const String name = 'AutoRouteNestedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoRouteNestedPage();
    },
  );
}

/// generated route for
/// [AutoRouteObserverPage]
class AutoRouteObserverRoute extends PageRouteInfo<void> {
  const AutoRouteObserverRoute({List<PageRouteInfo>? children})
    : super(AutoRouteObserverRoute.name, initialChildren: children);

  static const String name = 'AutoRouteObserverRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoRouteObserverPage();
    },
  );
}

/// generated route for
/// [AutoRouteProductOverviewPage]
class AutoRouteProductOverviewRoute extends PageRouteInfo<void> {
  const AutoRouteProductOverviewRoute({List<PageRouteInfo>? children})
    : super(AutoRouteProductOverviewRoute.name, initialChildren: children);

  static const String name = 'AutoRouteProductOverviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoRouteProductOverviewPage();
    },
  );
}

/// generated route for
/// [AutoRouteProductPage]
class AutoRouteProductRoute extends PageRouteInfo<AutoRouteProductRouteArgs> {
  AutoRouteProductRoute({
    Key? key,
    required String id,
    String? tab,
    List<PageRouteInfo>? children,
  }) : super(
         AutoRouteProductRoute.name,
         args: AutoRouteProductRouteArgs(key: key, id: id, tab: tab),
         rawPathParams: {'id': id},
         rawQueryParams: {'tab': tab},
         initialChildren: children,
       );

  static const String name = 'AutoRouteProductRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<AutoRouteProductRouteArgs>(
        orElse: () => AutoRouteProductRouteArgs(
          id: pathParams.getString('id'),
          tab: queryParams.optString('tab'),
        ),
      );
      return AutoRouteProductPage(key: args.key, id: args.id, tab: args.tab);
    },
  );
}

class AutoRouteProductRouteArgs {
  const AutoRouteProductRouteArgs({this.key, required this.id, this.tab});

  final Key? key;

  final String id;

  final String? tab;

  @override
  String toString() {
    return 'AutoRouteProductRouteArgs{key: $key, id: $id, tab: $tab}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AutoRouteProductRouteArgs) return false;
    return key == other.key && id == other.id && tab == other.tab;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode ^ tab.hashCode;
}

/// generated route for
/// [AutoRouteProductReviewPage]
class AutoRouteProductReviewRoute
    extends PageRouteInfo<AutoRouteProductReviewRouteArgs> {
  AutoRouteProductReviewRoute({
    Key? key,
    String? source,
    List<PageRouteInfo>? children,
  }) : super(
         AutoRouteProductReviewRoute.name,
         args: AutoRouteProductReviewRouteArgs(key: key, source: source),
         rawQueryParams: {'source': source},
         initialChildren: children,
       );

  static const String name = 'AutoRouteProductReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<AutoRouteProductReviewRouteArgs>(
        orElse: () => AutoRouteProductReviewRouteArgs(
          source: queryParams.optString('source'),
        ),
      );
      return AutoRouteProductReviewPage(
        key: args.key,
        productId: pathParams.getString('id'),
        source: args.source,
      );
    },
  );
}

class AutoRouteProductReviewRouteArgs {
  const AutoRouteProductReviewRouteArgs({this.key, this.source});

  final Key? key;

  final String? source;

  @override
  String toString() {
    return 'AutoRouteProductReviewRouteArgs{key: $key, source: $source}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AutoRouteProductReviewRouteArgs) return false;
    return key == other.key && source == other.source;
  }

  @override
  int get hashCode => key.hashCode ^ source.hashCode;
}

/// generated route for
/// [AutoRouteProfileTabPage]
class AutoRouteProfileTabRoute extends PageRouteInfo<void> {
  const AutoRouteProfileTabRoute({List<PageRouteInfo>? children})
    : super(AutoRouteProfileTabRoute.name, initialChildren: children);

  static const String name = 'AutoRouteProfileTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoRouteProfileTabPage();
    },
  );
}

/// generated route for
/// [AutoRouteProtectedPage]
class AutoRouteProtectedRoute extends PageRouteInfo<void> {
  const AutoRouteProtectedRoute({List<PageRouteInfo>? children})
    : super(AutoRouteProtectedRoute.name, initialChildren: children);

  static const String name = 'AutoRouteProtectedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoRouteProtectedPage();
    },
  );
}

/// generated route for
/// [AutoRouteSettingsTabPage]
class AutoRouteSettingsTabRoute extends PageRouteInfo<void> {
  const AutoRouteSettingsTabRoute({List<PageRouteInfo>? children})
    : super(AutoRouteSettingsTabRoute.name, initialChildren: children);

  static const String name = 'AutoRouteSettingsTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoRouteSettingsTabPage();
    },
  );
}

/// generated route for
/// [AutoRouteUnknownPage]
class AutoRouteUnknownRoute extends PageRouteInfo<void> {
  const AutoRouteUnknownRoute({List<PageRouteInfo>? children})
    : super(AutoRouteUnknownRoute.name, initialChildren: children);

  static const String name = 'AutoRouteUnknownRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoRouteUnknownPage();
    },
  );
}

/// generated route for
/// [AutoRouteUsagePage]
class AutoRouteUsageRoute extends PageRouteInfo<void> {
  const AutoRouteUsageRoute({List<PageRouteInfo>? children})
    : super(AutoRouteUsageRoute.name, initialChildren: children);

  static const String name = 'AutoRouteUsageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoRouteUsagePage();
    },
  );
}

/// generated route for
/// [AutoRouteWrappedPage]
class AutoRouteWrappedRoute extends PageRouteInfo<void> {
  const AutoRouteWrappedRoute({List<PageRouteInfo>? children})
    : super(AutoRouteWrappedRoute.name, initialChildren: children);

  static const String name = 'AutoRouteWrappedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const AutoRouteWrappedPage());
    },
  );
}

/// generated route for
/// [BlockSemanticsPage]
class BlockSemanticsRoute extends PageRouteInfo<void> {
  const BlockSemanticsRoute({List<PageRouteInfo>? children})
    : super(BlockSemanticsRoute.name, initialChildren: children);

  static const String name = 'BlockSemanticsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BlockSemanticsPage();
    },
  );
}

/// generated route for
/// [BottomNavigationBarExamplePage]
class BottomNavigationBarExampleRoute extends PageRouteInfo<void> {
  const BottomNavigationBarExampleRoute({List<PageRouteInfo>? children})
    : super(BottomNavigationBarExampleRoute.name, initialChildren: children);

  static const String name = 'BottomNavigationBarExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BottomNavigationBarExamplePage();
    },
  );
}

/// generated route for
/// [ButtonShowcasePage]
class ButtonShowcaseRoute extends PageRouteInfo<void> {
  const ButtonShowcaseRoute({List<PageRouteInfo>? children})
    : super(ButtonShowcaseRoute.name, initialChildren: children);

  static const String name = 'ButtonShowcaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ButtonShowcasePage();
    },
  );
}

/// generated route for
/// [CachedNetworkImageCePage]
class CachedNetworkImageCeRoute extends PageRouteInfo<void> {
  const CachedNetworkImageCeRoute({List<PageRouteInfo>? children})
    : super(CachedNetworkImageCeRoute.name, initialChildren: children);

  static const String name = 'CachedNetworkImageCeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CachedNetworkImageCePage();
    },
  );
}

/// generated route for
/// [CenterBoxPage]
class CenterBoxRoute extends PageRouteInfo<void> {
  const CenterBoxRoute({List<PageRouteInfo>? children})
    : super(CenterBoxRoute.name, initialChildren: children);

  static const String name = 'CenterBoxRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CenterBoxPage();
    },
  );
}

/// generated route for
/// [CheckboxExamplePage]
class CheckboxExampleRoute extends PageRouteInfo<void> {
  const CheckboxExampleRoute({List<PageRouteInfo>? children})
    : super(CheckboxExampleRoute.name, initialChildren: children);

  static const String name = 'CheckboxExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CheckboxExamplePage();
    },
  );
}

/// generated route for
/// [ChoiceChipPage]
class ChoiceChipRoute extends PageRouteInfo<void> {
  const ChoiceChipRoute({List<PageRouteInfo>? children})
    : super(ChoiceChipRoute.name, initialChildren: children);

  static const String name = 'ChoiceChipRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChoiceChipPage();
    },
  );
}

/// generated route for
/// [CircularProgressIndicatorExamplePage]
class CircularProgressIndicatorExampleRoute extends PageRouteInfo<void> {
  const CircularProgressIndicatorExampleRoute({List<PageRouteInfo>? children})
    : super(
        CircularProgressIndicatorExampleRoute.name,
        initialChildren: children,
      );

  static const String name = 'CircularProgressIndicatorExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CircularProgressIndicatorExamplePage();
    },
  );
}

/// generated route for
/// [ClipOvalExamplePage]
class ClipOvalExampleRoute extends PageRouteInfo<void> {
  const ClipOvalExampleRoute({List<PageRouteInfo>? children})
    : super(ClipOvalExampleRoute.name, initialChildren: children);

  static const String name = 'ClipOvalExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ClipOvalExamplePage();
    },
  );
}

/// generated route for
/// [ClipPathExamplePage]
class ClipPathExampleRoute extends PageRouteInfo<void> {
  const ClipPathExampleRoute({List<PageRouteInfo>? children})
    : super(ClipPathExampleRoute.name, initialChildren: children);

  static const String name = 'ClipPathExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ClipPathExamplePage();
    },
  );
}

/// generated route for
/// [ClipRRectExamplePage]
class ClipRRectExampleRoute extends PageRouteInfo<void> {
  const ClipRRectExampleRoute({List<PageRouteInfo>? children})
    : super(ClipRRectExampleRoute.name, initialChildren: children);

  static const String name = 'ClipRRectExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ClipRRectExamplePage();
    },
  );
}

/// generated route for
/// [ClipRectExamplePage]
class ClipRectExampleRoute extends PageRouteInfo<void> {
  const ClipRectExampleRoute({List<PageRouteInfo>? children})
    : super(ClipRectExampleRoute.name, initialChildren: children);

  static const String name = 'ClipRectExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ClipRectExamplePage();
    },
  );
}

/// generated route for
/// [ClipboardPage]
class ClipboardRoute extends PageRouteInfo<void> {
  const ClipboardRoute({List<PageRouteInfo>? children})
    : super(ClipboardRoute.name, initialChildren: children);

  static const String name = 'ClipboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ClipboardPage();
    },
  );
}

/// generated route for
/// [ColumnPage]
class ColumnRoute extends PageRouteInfo<void> {
  const ColumnRoute({List<PageRouteInfo>? children})
    : super(ColumnRoute.name, initialChildren: children);

  static const String name = 'ColumnRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ColumnPage();
    },
  );
}

/// generated route for
/// [ColumnSavedPage]
class ColumnSavedRoute extends PageRouteInfo<void> {
  const ColumnSavedRoute({List<PageRouteInfo>? children})
    : super(ColumnSavedRoute.name, initialChildren: children);

  static const String name = 'ColumnSavedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ColumnSavedPage();
    },
  );
}

/// generated route for
/// [ColumnSavedStatelessPage]
class ColumnSavedStatelessRoute extends PageRouteInfo<void> {
  const ColumnSavedStatelessRoute({List<PageRouteInfo>? children})
    : super(ColumnSavedStatelessRoute.name, initialChildren: children);

  static const String name = 'ColumnSavedStatelessRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ColumnSavedStatelessPage();
    },
  );
}

/// generated route for
/// [ConstrainedBoxPage]
class ConstrainedBoxRoute extends PageRouteInfo<void> {
  const ConstrainedBoxRoute({List<PageRouteInfo>? children})
    : super(ConstrainedBoxRoute.name, initialChildren: children);

  static const String name = 'ConstrainedBoxRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ConstrainedBoxPage();
    },
  );
}

/// generated route for
/// [ContainerPage]
class ContainerRoute extends PageRouteInfo<void> {
  const ContainerRoute({List<PageRouteInfo>? children})
    : super(ContainerRoute.name, initialChildren: children);

  static const String name = 'ContainerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContainerPage();
    },
  );
}

/// generated route for
/// [ContentTabPage]
class ContentTabRoute extends PageRouteInfo<void> {
  const ContentTabRoute({List<PageRouteInfo>? children})
    : super(ContentTabRoute.name, initialChildren: children);

  static const String name = 'ContentTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContentTabPage();
    },
  );
}

/// generated route for
/// [CryptoPage]
class CryptoRoute extends PageRouteInfo<void> {
  const CryptoRoute({List<PageRouteInfo>? children})
    : super(CryptoRoute.name, initialChildren: children);

  static const String name = 'CryptoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CryptoPage();
    },
  );
}

/// generated route for
/// [CuePage]
class CueRoute extends PageRouteInfo<void> {
  const CueRoute({List<PageRouteInfo>? children})
    : super(CueRoute.name, initialChildren: children);

  static const String name = 'CueRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CuePage();
    },
  );
}

/// generated route for
/// [CustomClipperExamplePage]
class CustomClipperExampleRoute extends PageRouteInfo<void> {
  const CustomClipperExampleRoute({List<PageRouteInfo>? children})
    : super(CustomClipperExampleRoute.name, initialChildren: children);

  static const String name = 'CustomClipperExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CustomClipperExamplePage();
    },
  );
}

/// generated route for
/// [CustomMultiChildLayoutPage]
class CustomMultiChildLayoutRoute extends PageRouteInfo<void> {
  const CustomMultiChildLayoutRoute({List<PageRouteInfo>? children})
    : super(CustomMultiChildLayoutRoute.name, initialChildren: children);

  static const String name = 'CustomMultiChildLayoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CustomMultiChildLayoutPage();
    },
  );
}

/// generated route for
/// [CustomPaintPage]
class CustomPaintRoute extends PageRouteInfo<void> {
  const CustomPaintRoute({List<PageRouteInfo>? children})
    : super(CustomPaintRoute.name, initialChildren: children);

  static const String name = 'CustomPaintRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CustomPaintPage();
    },
  );
}

/// generated route for
/// [DataTablePage]
class DataTableRoute extends PageRouteInfo<void> {
  const DataTableRoute({List<PageRouteInfo>? children})
    : super(DataTableRoute.name, initialChildren: children);

  static const String name = 'DataTableRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DataTablePage();
    },
  );
}

/// generated route for
/// [DatePickerPage]
class DatePickerRoute extends PageRouteInfo<void> {
  const DatePickerRoute({List<PageRouteInfo>? children})
    : super(DatePickerRoute.name, initialChildren: children);

  static const String name = 'DatePickerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DatePickerPage();
    },
  );
}

/// generated route for
/// [DecoratedBoxPage]
class DecoratedBoxRoute extends PageRouteInfo<void> {
  const DecoratedBoxRoute({List<PageRouteInfo>? children})
    : super(DecoratedBoxRoute.name, initialChildren: children);

  static const String name = 'DecoratedBoxRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DecoratedBoxPage();
    },
  );
}

/// generated route for
/// [DialogExamplePage]
class DialogExampleRoute extends PageRouteInfo<void> {
  const DialogExampleRoute({List<PageRouteInfo>? children})
    : super(DialogExampleRoute.name, initialChildren: children);

  static const String name = 'DialogExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DialogExamplePage();
    },
  );
}

/// generated route for
/// [DragTargetExamplePage]
class DragTargetExampleRoute extends PageRouteInfo<void> {
  const DragTargetExampleRoute({List<PageRouteInfo>? children})
    : super(DragTargetExampleRoute.name, initialChildren: children);

  static const String name = 'DragTargetExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DragTargetExamplePage();
    },
  );
}

/// generated route for
/// [DraggableExamplePage]
class DraggableExampleRoute extends PageRouteInfo<void> {
  const DraggableExampleRoute({List<PageRouteInfo>? children})
    : super(DraggableExampleRoute.name, initialChildren: children);

  static const String name = 'DraggableExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DraggableExamplePage();
    },
  );
}

/// generated route for
/// [DriftFlutterPage]
class DriftFlutterRoute extends PageRouteInfo<void> {
  const DriftFlutterRoute({List<PageRouteInfo>? children})
    : super(DriftFlutterRoute.name, initialChildren: children);

  static const String name = 'DriftFlutterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriftFlutterPage();
    },
  );
}

/// generated route for
/// [EncrypterPlusPage]
class EncrypterPlusRoute extends PageRouteInfo<void> {
  const EncrypterPlusRoute({List<PageRouteInfo>? children})
    : super(EncrypterPlusRoute.name, initialChildren: children);

  static const String name = 'EncrypterPlusRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EncrypterPlusPage();
    },
  );
}

/// generated route for
/// [ExcludeSemanticsPage]
class ExcludeSemanticsRoute extends PageRouteInfo<void> {
  const ExcludeSemanticsRoute({List<PageRouteInfo>? children})
    : super(ExcludeSemanticsRoute.name, initialChildren: children);

  static const String name = 'ExcludeSemanticsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ExcludeSemanticsPage();
    },
  );
}

/// generated route for
/// [ExpandedPage]
class ExpandedRoute extends PageRouteInfo<void> {
  const ExpandedRoute({List<PageRouteInfo>? children})
    : super(ExpandedRoute.name, initialChildren: children);

  static const String name = 'ExpandedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ExpandedPage();
    },
  );
}

/// generated route for
/// [FfigenPage]
class FfigenRoute extends PageRouteInfo<void> {
  const FfigenRoute({List<PageRouteInfo>? children})
    : super(FfigenRoute.name, initialChildren: children);

  static const String name = 'FfigenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FfigenPage();
    },
  );
}

/// generated route for
/// [FilledButtonPage]
class FilledButtonRoute extends PageRouteInfo<void> {
  const FilledButtonRoute({List<PageRouteInfo>? children})
    : super(FilledButtonRoute.name, initialChildren: children);

  static const String name = 'FilledButtonRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FilledButtonPage();
    },
  );
}

/// generated route for
/// [FilterChipPage]
class FilterChipRoute extends PageRouteInfo<void> {
  const FilterChipRoute({List<PageRouteInfo>? children})
    : super(FilterChipRoute.name, initialChildren: children);

  static const String name = 'FilterChipRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FilterChipPage();
    },
  );
}

/// generated route for
/// [FittedBoxPage]
class FittedBoxRoute extends PageRouteInfo<void> {
  const FittedBoxRoute({List<PageRouteInfo>? children})
    : super(FittedBoxRoute.name, initialChildren: children);

  static const String name = 'FittedBoxRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FittedBoxPage();
    },
  );
}

/// generated route for
/// [FlChartPage]
class FlChartRoute extends PageRouteInfo<void> {
  const FlChartRoute({List<PageRouteInfo>? children})
    : super(FlChartRoute.name, initialChildren: children);

  static const String name = 'FlChartRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlChartPage();
    },
  );
}

/// generated route for
/// [FlexSeedSchemePage]
class FlexSeedSchemeRoute extends PageRouteInfo<void> {
  const FlexSeedSchemeRoute({List<PageRouteInfo>? children})
    : super(FlexSeedSchemeRoute.name, initialChildren: children);

  static const String name = 'FlexSeedSchemeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlexSeedSchemePage();
    },
  );
}

/// generated route for
/// [FlexiblePage]
class FlexibleRoute extends PageRouteInfo<void> {
  const FlexibleRoute({List<PageRouteInfo>? children})
    : super(FlexibleRoute.name, initialChildren: children);

  static const String name = 'FlexibleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlexiblePage();
    },
  );
}

/// generated route for
/// [FloatingActionButtonExamplePage]
class FloatingActionButtonExampleRoute extends PageRouteInfo<void> {
  const FloatingActionButtonExampleRoute({List<PageRouteInfo>? children})
    : super(FloatingActionButtonExampleRoute.name, initialChildren: children);

  static const String name = 'FloatingActionButtonExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FloatingActionButtonExamplePage();
    },
  );
}

/// generated route for
/// [FlowExamplePage]
class FlowExampleRoute extends PageRouteInfo<void> {
  const FlowExampleRoute({List<PageRouteInfo>? children})
    : super(FlowExampleRoute.name, initialChildren: children);

  static const String name = 'FlowExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlowExamplePage();
    },
  );
}

/// generated route for
/// [FlutterAutoSizeTextPage]
class FlutterAutoSizeTextRoute extends PageRouteInfo<void> {
  const FlutterAutoSizeTextRoute({List<PageRouteInfo>? children})
    : super(FlutterAutoSizeTextRoute.name, initialChildren: children);

  static const String name = 'FlutterAutoSizeTextRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlutterAutoSizeTextPage();
    },
  );
}

/// generated route for
/// [FlutterBlocPage]
class FlutterBlocRoute extends PageRouteInfo<void> {
  const FlutterBlocRoute({List<PageRouteInfo>? children})
    : super(FlutterBlocRoute.name, initialChildren: children);

  static const String name = 'FlutterBlocRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlutterBlocPage();
    },
  );
}

/// generated route for
/// [FlutterCustomTabsPage]
class FlutterCustomTabsRoute extends PageRouteInfo<void> {
  const FlutterCustomTabsRoute({List<PageRouteInfo>? children})
    : super(FlutterCustomTabsRoute.name, initialChildren: children);

  static const String name = 'FlutterCustomTabsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlutterCustomTabsPage();
    },
  );
}

/// generated route for
/// [FlutterDotenvPage]
class FlutterDotenvRoute extends PageRouteInfo<void> {
  const FlutterDotenvRoute({List<PageRouteInfo>? children})
    : super(FlutterDotenvRoute.name, initialChildren: children);

  static const String name = 'FlutterDotenvRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlutterDotenvPage();
    },
  );
}

/// generated route for
/// [FlutterHooksPage]
class FlutterHooksRoute extends PageRouteInfo<void> {
  const FlutterHooksRoute({List<PageRouteInfo>? children})
    : super(FlutterHooksRoute.name, initialChildren: children);

  static const String name = 'FlutterHooksRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlutterHooksPage();
    },
  );
}

/// generated route for
/// [FlutterLocalNotificationsPage]
class FlutterLocalNotificationsRoute extends PageRouteInfo<void> {
  const FlutterLocalNotificationsRoute({List<PageRouteInfo>? children})
    : super(FlutterLocalNotificationsRoute.name, initialChildren: children);

  static const String name = 'FlutterLocalNotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlutterLocalNotificationsPage();
    },
  );
}

/// generated route for
/// [FlutterSecureStoragePage]
class FlutterSecureStorageRoute extends PageRouteInfo<void> {
  const FlutterSecureStorageRoute({List<PageRouteInfo>? children})
    : super(FlutterSecureStorageRoute.name, initialChildren: children);

  static const String name = 'FlutterSecureStorageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlutterSecureStoragePage();
    },
  );
}

/// generated route for
/// [FlutterSlidablePage]
class FlutterSlidableRoute extends PageRouteInfo<void> {
  const FlutterSlidableRoute({List<PageRouteInfo>? children})
    : super(FlutterSlidableRoute.name, initialChildren: children);

  static const String name = 'FlutterSlidableRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlutterSlidablePage();
    },
  );
}

/// generated route for
/// [FlutterSvgPage]
class FlutterSvgRoute extends PageRouteInfo<void> {
  const FlutterSvgRoute({List<PageRouteInfo>? children})
    : super(FlutterSvgRoute.name, initialChildren: children);

  static const String name = 'FlutterSvgRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlutterSvgPage();
    },
  );
}

/// generated route for
/// [FlutterTtsPage]
class FlutterTtsRoute extends PageRouteInfo<void> {
  const FlutterTtsRoute({List<PageRouteInfo>? children})
    : super(FlutterTtsRoute.name, initialChildren: children);

  static const String name = 'FlutterTtsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlutterTtsPage();
    },
  );
}

/// generated route for
/// [FlutterVideoCachingFvpPage]
class FlutterVideoCachingFvpRoute extends PageRouteInfo<void> {
  const FlutterVideoCachingFvpRoute({List<PageRouteInfo>? children})
    : super(FlutterVideoCachingFvpRoute.name, initialChildren: children);

  static const String name = 'FlutterVideoCachingFvpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlutterVideoCachingFvpPage();
    },
  );
}

/// generated route for
/// [FluttertoastPage]
class FluttertoastRoute extends PageRouteInfo<void> {
  const FluttertoastRoute({List<PageRouteInfo>? children})
    : super(FluttertoastRoute.name, initialChildren: children);

  static const String name = 'FluttertoastRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FluttertoastPage();
    },
  );
}

/// generated route for
/// [FocusTraversalGroupPage]
class FocusTraversalGroupRoute extends PageRouteInfo<void> {
  const FocusTraversalGroupRoute({List<PageRouteInfo>? children})
    : super(FocusTraversalGroupRoute.name, initialChildren: children);

  static const String name = 'FocusTraversalGroupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FocusTraversalGroupPage();
    },
  );
}

/// generated route for
/// [FocusableActionDetectorPage]
class FocusableActionDetectorRoute extends PageRouteInfo<void> {
  const FocusableActionDetectorRoute({List<PageRouteInfo>? children})
    : super(FocusableActionDetectorRoute.name, initialChildren: children);

  static const String name = 'FocusableActionDetectorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FocusableActionDetectorPage();
    },
  );
}

/// generated route for
/// [FontAwesomeFlutterPage]
class FontAwesomeFlutterRoute extends PageRouteInfo<void> {
  const FontAwesomeFlutterRoute({List<PageRouteInfo>? children})
    : super(FontAwesomeFlutterRoute.name, initialChildren: children);

  static const String name = 'FontAwesomeFlutterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FontAwesomeFlutterPage();
    },
  );
}

/// generated route for
/// [FormFieldPage]
class FormFieldRoute extends PageRouteInfo<void> {
  const FormFieldRoute({List<PageRouteInfo>? children})
    : super(FormFieldRoute.name, initialChildren: children);

  static const String name = 'FormFieldRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FormFieldPage();
    },
  );
}

/// generated route for
/// [FormPage]
class FormRoute extends PageRouteInfo<void> {
  const FormRoute({List<PageRouteInfo>? children})
    : super(FormRoute.name, initialChildren: children);

  static const String name = 'FormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FormPage();
    },
  );
}

/// generated route for
/// [FractionallySizedBoxPage]
class FractionallySizedBoxRoute extends PageRouteInfo<void> {
  const FractionallySizedBoxRoute({List<PageRouteInfo>? children})
    : super(FractionallySizedBoxRoute.name, initialChildren: children);

  static const String name = 'FractionallySizedBoxRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FractionallySizedBoxPage();
    },
  );
}

/// generated route for
/// [FreezedAnnotationPage]
class FreezedAnnotationRoute extends PageRouteInfo<void> {
  const FreezedAnnotationRoute({List<PageRouteInfo>? children})
    : super(FreezedAnnotationRoute.name, initialChildren: children);

  static const String name = 'FreezedAnnotationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FreezedAnnotationPage();
    },
  );
}

/// generated route for
/// [FutureBuilderPage]
class FutureBuilderRoute extends PageRouteInfo<void> {
  const FutureBuilderRoute({List<PageRouteInfo>? children})
    : super(FutureBuilderRoute.name, initialChildren: children);

  static const String name = 'FutureBuilderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FutureBuilderPage();
    },
  );
}

/// generated route for
/// [GenuiPage]
class GenuiRoute extends PageRouteInfo<void> {
  const GenuiRoute({List<PageRouteInfo>? children})
    : super(GenuiRoute.name, initialChildren: children);

  static const String name = 'GenuiRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GenuiPage();
    },
  );
}

/// generated route for
/// [GesturedetectorPage]
class GesturedetectorRoute extends PageRouteInfo<void> {
  const GesturedetectorRoute({List<PageRouteInfo>? children})
    : super(GesturedetectorRoute.name, initialChildren: children);

  static const String name = 'GesturedetectorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GesturedetectorPage();
    },
  );
}

/// generated route for
/// [GraphqlFlutterPage]
class GraphqlFlutterRoute extends PageRouteInfo<void> {
  const GraphqlFlutterRoute({List<PageRouteInfo>? children})
    : super(GraphqlFlutterRoute.name, initialChildren: children);

  static const String name = 'GraphqlFlutterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GraphqlFlutterPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [ImageWidgetPage]
class ImageWidgetRoute extends PageRouteInfo<void> {
  const ImageWidgetRoute({List<PageRouteInfo>? children})
    : super(ImageWidgetRoute.name, initialChildren: children);

  static const String name = 'ImageWidgetRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ImageWidgetPage();
    },
  );
}

/// generated route for
/// [IndexedStackPage]
class IndexedStackRoute extends PageRouteInfo<void> {
  const IndexedStackRoute({List<PageRouteInfo>? children})
    : super(IndexedStackRoute.name, initialChildren: children);

  static const String name = 'IndexedStackRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IndexedStackPage();
    },
  );
}

/// generated route for
/// [InjectablePage]
class InjectableRoute extends PageRouteInfo<void> {
  const InjectableRoute({List<PageRouteInfo>? children})
    : super(InjectableRoute.name, initialChildren: children);

  static const String name = 'InjectableRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InjectablePage();
    },
  );
}

/// generated route for
/// [InkWidgetsPage]
class InkWidgetsRoute extends PageRouteInfo<void> {
  const InkWidgetsRoute({List<PageRouteInfo>? children})
    : super(InkWidgetsRoute.name, initialChildren: children);

  static const String name = 'InkWidgetsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InkWidgetsPage();
    },
  );
}

/// generated route for
/// [InputChipPage]
class InputChipRoute extends PageRouteInfo<void> {
  const InputChipRoute({List<PageRouteInfo>? children})
    : super(InputChipRoute.name, initialChildren: children);

  static const String name = 'InputChipRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InputChipPage();
    },
  );
}

/// generated route for
/// [IntlPage]
class IntlRoute extends PageRouteInfo<void> {
  const IntlRoute({List<PageRouteInfo>? children})
    : super(IntlRoute.name, initialChildren: children);

  static const String name = 'IntlRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntlPage();
    },
  );
}

/// generated route for
/// [IntroductionScreenPage]
class IntroductionScreenRoute extends PageRouteInfo<void> {
  const IntroductionScreenRoute({List<PageRouteInfo>? children})
    : super(IntroductionScreenRoute.name, initialChildren: children);

  static const String name = 'IntroductionScreenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntroductionScreenPage();
    },
  );
}

/// generated route for
/// [JnigenPage]
class JnigenRoute extends PageRouteInfo<void> {
  const JnigenRoute({List<PageRouteInfo>? children})
    : super(JnigenRoute.name, initialChildren: children);

  static const String name = 'JnigenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const JnigenPage();
    },
  );
}

/// generated route for
/// [JsonAnnotationPage]
class JsonAnnotationRoute extends PageRouteInfo<void> {
  const JsonAnnotationRoute({List<PageRouteInfo>? children})
    : super(JsonAnnotationRoute.name, initialChildren: children);

  static const String name = 'JsonAnnotationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const JsonAnnotationPage();
    },
  );
}

/// generated route for
/// [KeyboardListenerPage]
class KeyboardListenerRoute extends PageRouteInfo<void> {
  const KeyboardListenerRoute({List<PageRouteInfo>? children})
    : super(KeyboardListenerRoute.name, initialChildren: children);

  static const String name = 'KeyboardListenerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const KeyboardListenerPage();
    },
  );
}

/// generated route for
/// [LayoutBuilderExamplePage]
class LayoutBuilderExampleRoute extends PageRouteInfo<void> {
  const LayoutBuilderExampleRoute({List<PageRouteInfo>? children})
    : super(LayoutBuilderExampleRoute.name, initialChildren: children);

  static const String name = 'LayoutBuilderExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LayoutBuilderExamplePage();
    },
  );
}

/// generated route for
/// [LayoutTabPage]
class LayoutTabRoute extends PageRouteInfo<void> {
  const LayoutTabRoute({List<PageRouteInfo>? children})
    : super(LayoutTabRoute.name, initialChildren: children);

  static const String name = 'LayoutTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LayoutTabPage();
    },
  );
}

/// generated route for
/// [LinearProgressIndicatorExamplePage]
class LinearProgressIndicatorExampleRoute extends PageRouteInfo<void> {
  const LinearProgressIndicatorExampleRoute({List<PageRouteInfo>? children})
    : super(
        LinearProgressIndicatorExampleRoute.name,
        initialChildren: children,
      );

  static const String name = 'LinearProgressIndicatorExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LinearProgressIndicatorExamplePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    void Function(bool)? onResult,
    List<PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return LoginPage(key: args.key, onResult: args.onResult);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.onResult});

  final Key? key;

  final void Function(bool)? onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [MaterialColorUtilitiesPage]
class MaterialColorUtilitiesRoute extends PageRouteInfo<void> {
  const MaterialColorUtilitiesRoute({List<PageRouteInfo>? children})
    : super(MaterialColorUtilitiesRoute.name, initialChildren: children);

  static const String name = 'MaterialColorUtilitiesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MaterialColorUtilitiesPage();
    },
  );
}

/// generated route for
/// [MaterialStatePropertyPage]
class MaterialStatePropertyRoute extends PageRouteInfo<void> {
  const MaterialStatePropertyRoute({List<PageRouteInfo>? children})
    : super(MaterialStatePropertyRoute.name, initialChildren: children);

  static const String name = 'MaterialStatePropertyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MaterialStatePropertyPage();
    },
  );
}

/// generated route for
/// [MaterialSymbolsIconsPage]
class MaterialSymbolsIconsRoute extends PageRouteInfo<void> {
  const MaterialSymbolsIconsRoute({List<PageRouteInfo>? children})
    : super(MaterialSymbolsIconsRoute.name, initialChildren: children);

  static const String name = 'MaterialSymbolsIconsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MaterialSymbolsIconsPage();
    },
  );
}

/// generated route for
/// [MediaQueryPage]
class MediaQueryRoute extends PageRouteInfo<void> {
  const MediaQueryRoute({List<PageRouteInfo>? children})
    : super(MediaQueryRoute.name, initialChildren: children);

  static const String name = 'MediaQueryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MediaQueryPage();
    },
  );
}

/// generated route for
/// [MergeSemanticsPage]
class MergeSemanticsRoute extends PageRouteInfo<void> {
  const MergeSemanticsRoute({List<PageRouteInfo>? children})
    : super(MergeSemanticsRoute.name, initialChildren: children);

  static const String name = 'MergeSemanticsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MergeSemanticsPage();
    },
  );
}

/// generated route for
/// [MouseRegionPage]
class MouseRegionRoute extends PageRouteInfo<void> {
  const MouseRegionRoute({List<PageRouteInfo>? children})
    : super(MouseRegionRoute.name, initialChildren: children);

  static const String name = 'MouseRegionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MouseRegionPage();
    },
  );
}

/// generated route for
/// [OpenFilePage]
class OpenFileRoute extends PageRouteInfo<void> {
  const OpenFileRoute({List<PageRouteInfo>? children})
    : super(OpenFileRoute.name, initialChildren: children);

  static const String name = 'OpenFileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OpenFilePage();
    },
  );
}

/// generated route for
/// [OrientationBuilderPage]
class OrientationBuilderRoute extends PageRouteInfo<void> {
  const OrientationBuilderRoute({List<PageRouteInfo>? children})
    : super(OrientationBuilderRoute.name, initialChildren: children);

  static const String name = 'OrientationBuilderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OrientationBuilderPage();
    },
  );
}

/// generated route for
/// [PaddingPage]
class PaddingRoute extends PageRouteInfo<void> {
  const PaddingRoute({List<PageRouteInfo>? children})
    : super(PaddingRoute.name, initialChildren: children);

  static const String name = 'PaddingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PaddingPage();
    },
  );
}

/// generated route for
/// [PermissionHandlerPage]
class PermissionHandlerRoute extends PageRouteInfo<void> {
  const PermissionHandlerRoute({List<PageRouteInfo>? children})
    : super(PermissionHandlerRoute.name, initialChildren: children);

  static const String name = 'PermissionHandlerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PermissionHandlerPage();
    },
  );
}

/// generated route for
/// [PigeonPage]
class PigeonRoute extends PageRouteInfo<void> {
  const PigeonRoute({List<PageRouteInfo>? children})
    : super(PigeonRoute.name, initialChildren: children);

  static const String name = 'PigeonRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PigeonPage();
    },
  );
}

/// generated route for
/// [PositionedPage]
class PositionedRoute extends PageRouteInfo<void> {
  const PositionedRoute({List<PageRouteInfo>? children})
    : super(PositionedRoute.name, initialChildren: children);

  static const String name = 'PositionedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PositionedPage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [RadioExamplePage]
class RadioExampleRoute extends PageRouteInfo<void> {
  const RadioExampleRoute({List<PageRouteInfo>? children})
    : super(RadioExampleRoute.name, initialChildren: children);

  static const String name = 'RadioExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RadioExamplePage();
    },
  );
}

/// generated route for
/// [RichTextPage]
class RichTextRoute extends PageRouteInfo<void> {
  const RichTextRoute({List<PageRouteInfo>? children})
    : super(RichTextRoute.name, initialChildren: children);

  static const String name = 'RichTextRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RichTextPage();
    },
  );
}

/// generated route for
/// [RotatedBoxExamplePage]
class RotatedBoxExampleRoute extends PageRouteInfo<void> {
  const RotatedBoxExampleRoute({List<PageRouteInfo>? children})
    : super(RotatedBoxExampleRoute.name, initialChildren: children);

  static const String name = 'RotatedBoxExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RotatedBoxExamplePage();
    },
  );
}

/// generated route for
/// [RowExpandedPage]
class RowExpandedRoute extends PageRouteInfo<void> {
  const RowExpandedRoute({List<PageRouteInfo>? children})
    : super(RowExpandedRoute.name, initialChildren: children);

  static const String name = 'RowExpandedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RowExpandedPage();
    },
  );
}

/// generated route for
/// [SafeAreaPage]
class SafeAreaRoute extends PageRouteInfo<void> {
  const SafeAreaRoute({List<PageRouteInfo>? children})
    : super(SafeAreaRoute.name, initialChildren: children);

  static const String name = 'SafeAreaRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SafeAreaPage();
    },
  );
}

/// generated route for
/// [ScrollbarPage]
class ScrollbarRoute extends PageRouteInfo<void> {
  const ScrollbarRoute({List<PageRouteInfo>? children})
    : super(ScrollbarRoute.name, initialChildren: children);

  static const String name = 'ScrollbarRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ScrollbarPage();
    },
  );
}

/// generated route for
/// [SemanticsPage]
class SemanticsRoute extends PageRouteInfo<void> {
  const SemanticsRoute({List<PageRouteInfo>? children})
    : super(SemanticsRoute.name, initialChildren: children);

  static const String name = 'SemanticsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SemanticsPage();
    },
  );
}

/// generated route for
/// [SharedPreferencesPage]
class SharedPreferencesRoute extends PageRouteInfo<void> {
  const SharedPreferencesRoute({List<PageRouteInfo>? children})
    : super(SharedPreferencesRoute.name, initialChildren: children);

  static const String name = 'SharedPreferencesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SharedPreferencesPage();
    },
  );
}

/// generated route for
/// [ShowDialogExamplePage]
class ShowDialogExampleRoute extends PageRouteInfo<void> {
  const ShowDialogExampleRoute({List<PageRouteInfo>? children})
    : super(ShowDialogExampleRoute.name, initialChildren: children);

  static const String name = 'ShowDialogExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ShowDialogExamplePage();
    },
  );
}

/// generated route for
/// [SimpleDialogExamplePage]
class SimpleDialogExampleRoute extends PageRouteInfo<void> {
  const SimpleDialogExampleRoute({List<PageRouteInfo>? children})
    : super(SimpleDialogExampleRoute.name, initialChildren: children);

  static const String name = 'SimpleDialogExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SimpleDialogExamplePage();
    },
  );
}

/// generated route for
/// [SingleChildScrollViewPage]
class SingleChildScrollViewRoute extends PageRouteInfo<void> {
  const SingleChildScrollViewRoute({List<PageRouteInfo>? children})
    : super(SingleChildScrollViewRoute.name, initialChildren: children);

  static const String name = 'SingleChildScrollViewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SingleChildScrollViewPage();
    },
  );
}

/// generated route for
/// [SingleTickerProviderStateMixinPage]
class SingleTickerProviderStateMixinRoute extends PageRouteInfo<void> {
  const SingleTickerProviderStateMixinRoute({List<PageRouteInfo>? children})
    : super(
        SingleTickerProviderStateMixinRoute.name,
        initialChildren: children,
      );

  static const String name = 'SingleTickerProviderStateMixinRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SingleTickerProviderStateMixinPage();
    },
  );
}

/// generated route for
/// [SizedBoxPage]
class SizedBoxRoute extends PageRouteInfo<void> {
  const SizedBoxRoute({List<PageRouteInfo>? children})
    : super(SizedBoxRoute.name, initialChildren: children);

  static const String name = 'SizedBoxRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SizedBoxPage();
    },
  );
}

/// generated route for
/// [SliderExamplePage]
class SliderExampleRoute extends PageRouteInfo<void> {
  const SliderExampleRoute({List<PageRouteInfo>? children})
    : super(SliderExampleRoute.name, initialChildren: children);

  static const String name = 'SliderExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SliderExamplePage();
    },
  );
}

/// generated route for
/// [SliverAppBarPage]
class SliverAppBarRoute extends PageRouteInfo<void> {
  const SliverAppBarRoute({List<PageRouteInfo>? children})
    : super(SliverAppBarRoute.name, initialChildren: children);

  static const String name = 'SliverAppBarRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SliverAppBarPage();
    },
  );
}

/// generated route for
/// [SliverExamplesPage]
class SliverExamplesRoute extends PageRouteInfo<void> {
  const SliverExamplesRoute({List<PageRouteInfo>? children})
    : super(SliverExamplesRoute.name, initialChildren: children);

  static const String name = 'SliverExamplesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SliverExamplesPage();
    },
  );
}

/// generated route for
/// [SliverGridPage]
class SliverGridRoute extends PageRouteInfo<void> {
  const SliverGridRoute({List<PageRouteInfo>? children})
    : super(SliverGridRoute.name, initialChildren: children);

  static const String name = 'SliverGridRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SliverGridPage();
    },
  );
}

/// generated route for
/// [SliverListPage]
class SliverListRoute extends PageRouteInfo<void> {
  const SliverListRoute({List<PageRouteInfo>? children})
    : super(SliverListRoute.name, initialChildren: children);

  static const String name = 'SliverListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SliverListPage();
    },
  );
}

/// generated route for
/// [SliverPaddingPage]
class SliverPaddingRoute extends PageRouteInfo<void> {
  const SliverPaddingRoute({List<PageRouteInfo>? children})
    : super(SliverPaddingRoute.name, initialChildren: children);

  static const String name = 'SliverPaddingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SliverPaddingPage();
    },
  );
}

/// generated route for
/// [SliverSnapPage]
class SliverSnapRoute extends PageRouteInfo<void> {
  const SliverSnapRoute({List<PageRouteInfo>? children})
    : super(SliverSnapRoute.name, initialChildren: children);

  static const String name = 'SliverSnapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SliverSnapPage();
    },
  );
}

/// generated route for
/// [SliverToBoxAdapterPage]
class SliverToBoxAdapterRoute extends PageRouteInfo<void> {
  const SliverToBoxAdapterRoute({List<PageRouteInfo>? children})
    : super(SliverToBoxAdapterRoute.name, initialChildren: children);

  static const String name = 'SliverToBoxAdapterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SliverToBoxAdapterPage();
    },
  );
}

/// generated route for
/// [SnackBarExamplePage]
class SnackBarExampleRoute extends PageRouteInfo<void> {
  const SnackBarExampleRoute({List<PageRouteInfo>? children})
    : super(SnackBarExampleRoute.name, initialChildren: children);

  static const String name = 'SnackBarExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SnackBarExamplePage();
    },
  );
}

/// generated route for
/// [SpeechToTextPage]
class SpeechToTextRoute extends PageRouteInfo<void> {
  const SpeechToTextRoute({List<PageRouteInfo>? children})
    : super(SpeechToTextRoute.name, initialChildren: children);

  static const String name = 'SpeechToTextRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SpeechToTextPage();
    },
  );
}

/// generated route for
/// [StackPage]
class StackRoute extends PageRouteInfo<void> {
  const StackRoute({List<PageRouteInfo>? children})
    : super(StackRoute.name, initialChildren: children);

  static const String name = 'StackRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StackPage();
    },
  );
}

/// generated route for
/// [StreamBuilderPage]
class StreamBuilderRoute extends PageRouteInfo<void> {
  const StreamBuilderRoute({List<PageRouteInfo>? children})
    : super(StreamBuilderRoute.name, initialChildren: children);

  static const String name = 'StreamBuilderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StreamBuilderPage();
    },
  );
}

/// generated route for
/// [SuperClipboardPage]
class SuperClipboardRoute extends PageRouteInfo<void> {
  const SuperClipboardRoute({List<PageRouteInfo>? children})
    : super(SuperClipboardRoute.name, initialChildren: children);

  static const String name = 'SuperClipboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SuperClipboardPage();
    },
  );
}

/// generated route for
/// [SwitchExamplePage]
class SwitchExampleRoute extends PageRouteInfo<void> {
  const SwitchExampleRoute({List<PageRouteInfo>? children})
    : super(SwitchExampleRoute.name, initialChildren: children);

  static const String name = 'SwitchExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SwitchExamplePage();
    },
  );
}

/// generated route for
/// [TablePage]
class TableRoute extends PageRouteInfo<void> {
  const TableRoute({List<PageRouteInfo>? children})
    : super(TableRoute.name, initialChildren: children);

  static const String name = 'TableRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TablePage();
    },
  );
}

/// generated route for
/// [TextFieldControllerPage]
class TextFieldControllerRoute extends PageRouteInfo<void> {
  const TextFieldControllerRoute({List<PageRouteInfo>? children})
    : super(TextFieldControllerRoute.name, initialChildren: children);

  static const String name = 'TextFieldControllerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TextFieldControllerPage();
    },
  );
}

/// generated route for
/// [TextRichPage]
class TextRichRoute extends PageRouteInfo<void> {
  const TextRichRoute({List<PageRouteInfo>? children})
    : super(TextRichRoute.name, initialChildren: children);

  static const String name = 'TextRichRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TextRichPage();
    },
  );
}

/// generated route for
/// [TextStylePage]
class TextStyleRoute extends PageRouteInfo<void> {
  const TextStyleRoute({List<PageRouteInfo>? children})
    : super(TextStyleRoute.name, initialChildren: children);

  static const String name = 'TextStyleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TextStylePage();
    },
  );
}

/// generated route for
/// [ThemeDataVisualDensityPage]
class ThemeDataVisualDensityRoute extends PageRouteInfo<void> {
  const ThemeDataVisualDensityRoute({List<PageRouteInfo>? children})
    : super(ThemeDataVisualDensityRoute.name, initialChildren: children);

  static const String name = 'ThemeDataVisualDensityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ThemeDataVisualDensityPage();
    },
  );
}

/// generated route for
/// [TimePickerPage]
class TimePickerRoute extends PageRouteInfo<void> {
  const TimePickerRoute({List<PageRouteInfo>? children})
    : super(TimePickerRoute.name, initialChildren: children);

  static const String name = 'TimePickerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TimePickerPage();
    },
  );
}

/// generated route for
/// [TooltipPage]
class TooltipRoute extends PageRouteInfo<void> {
  const TooltipRoute({List<PageRouteInfo>? children})
    : super(TooltipRoute.name, initialChildren: children);

  static const String name = 'TooltipRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TooltipPage();
    },
  );
}

/// generated route for
/// [TransformExamplePage]
class TransformExampleRoute extends PageRouteInfo<void> {
  const TransformExampleRoute({List<PageRouteInfo>? children})
    : super(TransformExampleRoute.name, initialChildren: children);

  static const String name = 'TransformExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TransformExamplePage();
    },
  );
}

/// generated route for
/// [TweenAnimationBuilderPage]
class TweenAnimationBuilderRoute extends PageRouteInfo<void> {
  const TweenAnimationBuilderRoute({List<PageRouteInfo>? children})
    : super(TweenAnimationBuilderRoute.name, initialChildren: children);

  static const String name = 'TweenAnimationBuilderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TweenAnimationBuilderPage();
    },
  );
}

/// generated route for
/// [TweenPage]
class TweenRoute extends PageRouteInfo<void> {
  const TweenRoute({List<PageRouteInfo>? children})
    : super(TweenRoute.name, initialChildren: children);

  static const String name = 'TweenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TweenPage();
    },
  );
}

/// generated route for
/// [TweenSequenceIntervalPage]
class TweenSequenceIntervalRoute extends PageRouteInfo<void> {
  const TweenSequenceIntervalRoute({List<PageRouteInfo>? children})
    : super(TweenSequenceIntervalRoute.name, initialChildren: children);

  static const String name = 'TweenSequenceIntervalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TweenSequenceIntervalPage();
    },
  );
}

/// generated route for
/// [UnconstrainedBoxExamplePage]
class UnconstrainedBoxExampleRoute extends PageRouteInfo<void> {
  const UnconstrainedBoxExampleRoute({List<PageRouteInfo>? children})
    : super(UnconstrainedBoxExampleRoute.name, initialChildren: children);

  static const String name = 'UnconstrainedBoxExampleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UnconstrainedBoxExamplePage();
    },
  );
}

/// generated route for
/// [UrlLauncherPage]
class UrlLauncherRoute extends PageRouteInfo<void> {
  const UrlLauncherRoute({List<PageRouteInfo>? children})
    : super(UrlLauncherRoute.name, initialChildren: children);

  static const String name = 'UrlLauncherRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UrlLauncherPage();
    },
  );
}

/// generated route for
/// [WasmFfiPage]
class WasmFfiRoute extends PageRouteInfo<void> {
  const WasmFfiRoute({List<PageRouteInfo>? children})
    : super(WasmFfiRoute.name, initialChildren: children);

  static const String name = 'WasmFfiRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WasmFfiPage();
    },
  );
}

/// generated route for
/// [WebviewFlutterPage]
class WebviewFlutterRoute extends PageRouteInfo<void> {
  const WebviewFlutterRoute({List<PageRouteInfo>? children})
    : super(WebviewFlutterRoute.name, initialChildren: children);

  static const String name = 'WebviewFlutterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WebviewFlutterPage();
    },
  );
}

/// generated route for
/// [WrapPage]
class WrapRoute extends PageRouteInfo<void> {
  const WrapRoute({List<PageRouteInfo>? children})
    : super(WrapRoute.name, initialChildren: children);

  static const String name = 'WrapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WrapPage();
    },
  );
}
