import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

const List<_ModuleLink> _layoutModules = <_ModuleLink>[
  _ModuleLink(label: 'Center Box Module', path: '/center-box'),
  _ModuleLink(label: 'Constrained Box Module', path: '/constrained-box'),
  _ModuleLink(
    label: 'UnconstrainedBox Module',
    path: '/unconstrained-box-page',
  ),
  _ModuleLink(label: 'Row Expanded Module', path: '/row-expand-page'),
  _ModuleLink(label: 'Flexible Module', path: '/flexible-page'),
  _ModuleLink(label: 'gesturedector Module', path: '/gesturedector-page'),
  _ModuleLink(label: 'Column Module', path: '/column-page'),
  _ModuleLink(label: 'Column Saved Module', path: '/column-saved-page'),
  _ModuleLink(label: 'Flow Module', path: '/flow-page'),
  _ModuleLink(label: 'LayoutBuilder Module', path: '/layout-builder-page'),
  _ModuleLink(label: 'Padding Module', path: '/padding-page'),
  _ModuleLink(label: 'Wrap Module', path: '/wrap-page'),
  _ModuleLink(label: 'Positioned Module', path: '/positioned-page'),
  _ModuleLink(label: 'Align Module', path: '/align-page'),
  _ModuleLink(label: 'Transform Module', path: '/transform-page'),
  _ModuleLink(label: 'RotatedBox Module', path: '/rotated-box-page'),
  _ModuleLink(label: 'SafeArea Module', path: '/safe-area-page'),
  _ModuleLink(label: 'ClipOval Module', path: '/clip-oval-page'),
  _ModuleLink(label: 'ClipRRect Module', path: '/clip-r-rect-page'),
  _ModuleLink(label: 'ClipRect Module', path: '/clip-rect-page'),
  _ModuleLink(label: 'ClipPath Module', path: '/clip-path-page'),
  _ModuleLink(label: 'CustomClipper Module', path: '/custom-clipper-page'),
  _ModuleLink(label: 'Table Module', path: '/table-page'),
  _ModuleLink(label: 'MediaQuery Module', path: '/media-query-page'),
  _ModuleLink(
    label: 'SingleChildScrollView Module',
    path: '/single-child-scroll-view-page',
  ),
  _ModuleLink(
    label:
        'SliverToBoxAdapter + SliverList + SliverPadding + SliverFillRemaining Module',
    path: '/sliver-widgets-page',
  ),
  _ModuleLink(label: 'Scrollbar Module', path: '/scrollbar-page'),
  _ModuleLink(label: 'FilledButton Module', path: '/filled-button-page'),
  _ModuleLink(label: 'Classic Buttons Module', path: '/classic-buttons-page'),
  _ModuleLink(label: 'DecoratedBox Module', path: '/decorated-box-page'),
];

const List<_ModuleLink> _contentModules = <_ModuleLink>[
  _ModuleLink(label: 'auto_route Module', path: '/auto-route-page'),
  _ModuleLink(label: 'Intl Module', path: '/intl-page'),
  _ModuleLink(label: 'Switch Module', path: '/switch-page'),
  _ModuleLink(label: 'Checkbox Module', path: '/checkbox-page'),
  _ModuleLink(label: 'Radio Module', path: '/radio-page'),
  _ModuleLink(label: 'InputChip Module', path: '/input-chip-page'),
  _ModuleLink(label: 'ChoiceChip Module', path: '/choice-chip-page'),
  _ModuleLink(label: 'FilterChip Module', path: '/filter-chip-page'),
  _ModuleLink(label: 'ActionChip Module', path: '/action-chip-page'),
  _ModuleLink(
    label: 'LinearProgressIndicator Module',
    path: '/linear-progress-indicator-page',
  ),
  _ModuleLink(
    label: 'CircularProgressIndicator Module',
    path: '/circular-progress-indicator-page',
  ),
  _ModuleLink(label: 'Slider Module', path: '/slider-page'),
  _ModuleLink(label: 'DatePicker Module', path: '/date-picker-page'),
  _ModuleLink(label: 'TimePicker Module', path: '/time-picker-page'),
  _ModuleLink(label: 'Form Module', path: '/form-page'),
  _ModuleLink(label: 'FormField Module', path: '/form-field-page'),
  _ModuleLink(label: 'Draggable Module', path: '/draggable-page'),
  _ModuleLink(label: 'DragTarget Module', path: '/drag-target-page'),
  _ModuleLink(label: 'RichText Module', path: '/rich-text-page'),
  _ModuleLink(label: 'TextStyle Module', path: '/text-style-page'),
  _ModuleLink(label: 'Text.rich Module', path: '/text-rich-page'),
  _ModuleLink(
    label: 'BottomNavigationBar Module',
    path: '/bottom-navigation-bar-page',
  ),
  _ModuleLink(
    label: 'FloatingActionButton Module',
    path: '/floating-action-button-page',
  ),
  _ModuleLink(label: 'SnackBar Module', path: '/snack-bar-page'),
  _ModuleLink(label: 'showDialog Module', path: '/show-dialog-page'),
  _ModuleLink(label: 'AlertDialog Module', path: '/alert-dialog-page'),
  _ModuleLink(label: 'SimpleDialog Module', path: '/simple-dialog-page'),
  _ModuleLink(label: 'Dialog Module', path: '/dialog-page'),
  _ModuleLink(label: 'FutureBuilder Module', path: '/future-builder-page'),
  _ModuleLink(label: 'StreamBuilder Module', path: '/stream-builder-page'),
  _ModuleLink(
    label: 'drift + drift_flutter Module',
    path: '/drift-flutter-page',
  ),
  _ModuleLink(
    label: 'KeyboardListener Module',
    path: '/keyboard-listener-page',
  ),
  _ModuleLink(
    label: 'Ink + InkWell + InkResponse Module',
    path: '/ink-widgets-page',
  ),
  _ModuleLink(label: 'Semantics Module', path: '/semantics-page'),
  _ModuleLink(
    label: 'ExcludeSemantics Module',
    path: '/exclude-semantics-page',
  ),
  _ModuleLink(label: 'MergeSemantics Module', path: '/merge-semantics-page'),
  _ModuleLink(
    label: 'shared_preferences Module',
    path: '/shared-preferences-page',
  ),
  _ModuleLink(
    label: 'TextField + TextEditingController Module',
    path: '/text-field-controller-page',
  ),
  _ModuleLink(
    label: 'flutter_auto_size_text Module',
    path: '/flutter-auto-size-text-page',
  ),
  _ModuleLink(
    label: 'cached_network_image_ce Module',
    path: '/cached-network-image-ce-page',
  ),
  _ModuleLink(
    label: 'DataTable + PaginatedDataTable Module',
    path: '/data-table-page',
  ),
  _ModuleLink(label: 'fl_chart Module', path: '/fl-chart-page'),
  _ModuleLink(
    label: 'font_awesome_flutter Module',
    path: '/font-awesome-flutter-page',
  ),
  _ModuleLink(
    label: 'material_symbols_icons Module',
    path: '/material-symbols-icons-page',
  ),
  _ModuleLink(label: 'flutter_svg Module', path: '/flutter-svg-page'),
  _ModuleLink(label: 'Image Module', path: '/image-widget-page'),
];

const List<_ModuleLink> _animationModules = <_ModuleLink>[
  _ModuleLink(
    label: 'AnimatedSwitcher Module',
    path: '/animated-switcher-page',
  ),
  _ModuleLink(
    label: 'animated_toggle_switch Module',
    path: '/animated-toggle-switch-page',
  ),
  _ModuleLink(
    label: 'AnimatedDefaultTextStyle Module',
    path: '/animated-default-text-style-page',
  ),
  _ModuleLink(label: 'CustomPaint Module', path: '/custom-paint-page'),
  _ModuleLink(
    label: 'TweenAnimationBuilder Module',
    path: '/tween-animation-builder-page',
  ),
  _ModuleLink(
    label: 'AnimationController Module',
    path: '/animation-controller-page',
  ),
  _ModuleLink(
    label: 'SingleTickerProviderStateMixin Module',
    path: '/single-ticker-provider-state-mixin-page',
  ),
  _ModuleLink(label: 'Tween Module', path: '/tween-page'),
  _ModuleLink(
    label: 'TweenSequence + Interval Module',
    path: '/tween-sequence-interval-page',
  ),
];

@RoutePage(name: 'HomeRoute')
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> _titles = <String>[
    'Layout Modules',
    'Content Modules',
    'Animation Modules',
  ];

  List<PageRouteInfo<void>> _routes() {
    return const <PageRouteInfo<void>>[
      NamedRoute<void>('LayoutTabRoute'),
      NamedRoute<void>('ContentTabRoute'),
      NamedRoute<void>('AnimationTabRoute'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: _routes(),
      appBarBuilder: (BuildContext context, TabsRouter tabsRouter) {
        return AppBar(title: Text(_titles[tabsRouter.activeIndex]));
      },
      bottomNavigationBuilder: (BuildContext context, TabsRouter tabsRouter) {
        return NavigationBar(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: tabsRouter.setActiveIndex,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.view_quilt_outlined),
              selectedIcon: Icon(Icons.view_quilt),
              label: 'Layout',
            ),
            NavigationDestination(
              icon: Icon(Icons.widgets_outlined),
              selectedIcon: Icon(Icons.widgets),
              label: 'Content',
            ),
            NavigationDestination(
              icon: Icon(Icons.animation_outlined),
              selectedIcon: Icon(Icons.animation),
              label: 'Animation',
            ),
          ],
        );
      },
    );
  }
}

@RoutePage(name: 'LayoutTabRoute')
class LayoutTabPage extends StatelessWidget {
  const LayoutTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ModuleTabView(modules: _layoutModules);
  }
}

@RoutePage(name: 'ContentTabRoute')
class ContentTabPage extends StatelessWidget {
  const ContentTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ModuleTabView(modules: _contentModules);
  }
}

@RoutePage(name: 'AnimationTabRoute')
class AnimationTabPage extends StatelessWidget {
  const AnimationTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ModuleTabView(modules: _animationModules);
  }
}

class _ModuleTabView extends StatelessWidget {
  const _ModuleTabView({required this.modules});

  final List<_ModuleLink> modules;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: modules.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 16);
        },
        itemBuilder: (BuildContext context, int index) {
          final _ModuleLink module = modules[index];
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.router.root.pushPath(module.path),
              child: Text(module.label),
            ),
          );
        },
      ),
    );
  }
}

class _ModuleLink {
  const _ModuleLink({required this.label, required this.path});

  final String label;
  final String path;
}
