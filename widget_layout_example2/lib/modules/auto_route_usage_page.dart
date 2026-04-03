import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_router.dart';
import 'package:widget_layout_example2/auto_route_demo_support.dart';

@RoutePage(name: 'AutoRouteUsageRoute')
class AutoRouteUsagePage extends StatelessWidget {
  const AutoRouteUsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('auto_route Module')),
      body: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[
          demoAuthController,
          demoNavigationLog,
        ]),
        builder: (BuildContext context, Widget? child) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              const Text(
                'This module turns the main auto_route concepts into working code inside this app. The buttons below navigate to real demo routes for nested navigation, paths, deep-link-friendly route setup, guards, wrappers, and observers.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              _StatusCard(
                isLoggedIn: demoAuthController.isLoggedIn,
                logCount: demoNavigationLog.entries.length,
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                title: 'Router Config Concepts',
                subtitle:
                    'These concepts live at the root router config level and are implemented in main.dart.',
              ),
              const SizedBox(height: 12),
              const _CodeCard(
                title:
                    'Deep-link transformer, builder, observers, reevaluation',
                code: '''
MaterialApp.router(
  routerConfig: _appRouter.config(
    includePrefixMatches: true,
    deepLinkTransformer: DeepLink.prefixStripper('demo'),
    deepLinkBuilder: (deepLink) {
      if (deepLink.path.startsWith('/blocked')) {
        return DeepLink.path('/auto-route-page');
      }
      return deepLink;
    },
    reevaluateListenable: demoAuthController,
    navigatorObservers: () => <NavigatorObserver>[
      DemoAutoRouterObserver(demoNavigationLog),
      AutoRouteObserver(),
    ],
  ),
);
''',
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                title: 'Nested Navigation And PageView',
                subtitle:
                    'This demo uses child routes and AutoTabsRouter.pageView to manage nested tabs.',
              ),
              const SizedBox(height: 12),
              const _CodeCard(
                title: 'Nested PageView tabs',
                code: '''
AutoRoute(
  page: AutoRouteNestedRoute.page,
  path: '/auto-route-page/nested',
  children: <AutoRoute>[
    AutoRoute(page: AutoRouteBooksTabRoute.page, path: 'books', initial: true),
    AutoRoute(page: AutoRouteProfileTabRoute.page, path: 'profile'),
    AutoRoute(page: AutoRouteSettingsTabRoute.page, path: 'settings'),
  ],
)
''',
              ),
              const SizedBox(height: 12),
              _ActionCard(
                title: 'Open nested page-view demo',
                description:
                    'Shows nested child routes, PageView-based tab navigation, and tab observer callbacks.',
                primaryLabel: 'Open Nested Demo',
                onPrimaryPressed: () =>
                    context.pushRoute(const AutoRouteNestedRoute()),
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                title: 'Deep Linking, Paths, And Dynamic Segments',
                subtitle:
                    'These demos focus on route ordering, includePrefixMatches, path parameters, inherited path parameters, and query parameters.',
              ),
              const SizedBox(height: 12),
              const _CodeCard(
                title: 'Linear non-nested routes for deep links',
                code: '''
AutoRoute(page: AutoRouteUsageRoute.page, path: '/auto-route-page'),
AutoRoute(page: AutoRouteBooksRoute.page, path: '/auto-route-page/books'),
AutoRoute(
  page: AutoRouteBookDetailsRoute.page,
  path: '/auto-route-page/books/:id',
)
''',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: () =>
                        context.pushRoute(const AutoRouteBooksRoute()),
                    icon: const Icon(Icons.menu_book_outlined),
                    label: const Text('Books List'),
                  ),
                  FilledButton.icon(
                    onPressed: () => context.navigateToPath(
                      '/auto-route-page/books/42?tab=overview&filter=popular',
                      includePrefixMatches: true,
                    ),
                    icon: const Icon(Icons.link),
                    label: const Text('Deep-link Style Path'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _CodeCard(
                title: 'Path params, inherited params, query params',
                code: '''
AutoRoute(
  page: AutoRouteProductRoute.page,
  path: '/auto-route-page/products/:id',
  children: <AutoRoute>[
    AutoRoute(page: AutoRouteProductOverviewRoute.page, path: '', initial: true),
    AutoRoute(page: AutoRouteProductReviewRoute.page, path: 'review'),
  ],
)

class AutoRouteBookDetailsPage extends StatelessWidget {
  const AutoRouteBookDetailsPage({
    super.key,
    @PathParam('id') required this.id,
    @QueryParam('tab') this.tab,
    @QueryParam('filter') this.filter,
  });
}

class AutoRouteProductReviewPage extends StatelessWidget {
  const AutoRouteProductReviewPage({
    super.key,
    @PathParam.inherit('id') required this.productId,
    @QueryParam('source') this.source,
  });
}
''',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: () => context.navigateToPath(
                      '/auto-route-page/products/7',
                      includePrefixMatches: true,
                    ),
                    icon: const Icon(Icons.inventory_2_outlined),
                    label: const Text('Product Overview'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.navigateToPath(
                      '/auto-route-page/products/7/review?source=hub',
                      includePrefixMatches: true,
                    ),
                    icon: const Icon(Icons.rate_review_outlined),
                    label: const Text('Inherited Param Review'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                title: 'Redirects And Wildcards',
                subtitle:
                    'RedirectRoute handles legacy paths, and the wildcard catches undefined auto-route demo paths.',
              ),
              const SizedBox(height: 12),
              const _CodeCard(
                title: 'RedirectRoute and wildcard',
                code: '''
RedirectRoute(
  path: '/auto-route-page/legacy',
  redirectTo: '/auto-route-page/books',
),
RedirectRoute(
  path: '/auto-route-page/books/:id/legacy',
  redirectTo: '/auto-route-page/books/:id',
),
AutoRoute(
  page: AutoRouteUnknownRoute.page,
  path: '/auto-route-page/*',
)
''',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: () =>
                        context.router.pushPath('/auto-route-page/legacy'),
                    icon: const Icon(Icons.redo),
                    label: const Text('Follow Redirect'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.router.pushPath(
                      '/auto-route-page/not-a-real-demo-page',
                    ),
                    icon: const Icon(Icons.error_outline),
                    label: const Text('Trigger Wildcard'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                title: 'Route Guards And Reevaluate Listenable',
                subtitle:
                    'One route uses a per-route guard and another is protected through the router-level global guards list.',
              ),
              const SizedBox(height: 12),
              const _CodeCard(
                title: 'Per-route guard and global stack guard',
                code: '''
AutoRoute(
  page: AutoRouteProtectedRoute.page,
  path: '/auto-route-page/protected',
  guards: <AutoRouteGuard>[
    AutoRouteGuard.simple((resolver, router) {
      if (demoAuthController.isLoggedIn) {
        resolver.next();
      } else {
        resolver.redirectUntil(
          AutoRouteLoginRoute(
            onResult: (didLogin) {
              resolver.resolveNext(didLogin, reevaluateNext: false);
            },
          ),
        );
      }
    }),
  ],
)

@override
late final List<AutoRouteGuard> guards = <AutoRouteGuard>[
  AutoRouteGuard.simple((resolver, router) {
    if (resolver.routeName != AutoRouteGlobalProtectedRoute.name ||
        demoAuthController.isLoggedIn ||
        resolver.routeName == AutoRouteLoginRoute.name) {
      resolver.next();
      return;
    }
    resolver.redirectUntil(
      AutoRouteLoginRoute(
        onResult: (didLogin) {
          resolver.resolveNext(didLogin, reevaluateNext: false);
        },
      ),
    );
  }),
];
''',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: demoAuthController.login,
                    icon: const Icon(Icons.lock_open),
                    label: const Text('Log In'),
                  ),
                  OutlinedButton.icon(
                    onPressed: demoAuthController.logout,
                    icon: const Icon(Icons.lock_outline),
                    label: const Text('Log Out'),
                  ),
                  FilledButton.icon(
                    onPressed: () =>
                        context.pushRoute(const AutoRouteProtectedRoute()),
                    icon: const Icon(Icons.verified_user_outlined),
                    label: const Text('Route Guard Demo'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.pushRoute(
                      const AutoRouteGlobalProtectedRoute(),
                    ),
                    icon: const Icon(Icons.shield_outlined),
                    label: const Text('Global Guard Demo'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                title: 'Wrapping Routes And Observers',
                subtitle:
                    'The wrapped route uses AutoRouteWrapper. The observer demo uses AutoRouteObserver and live navigation logs.',
              ),
              const SizedBox(height: 12),
              const _CodeCard(
                title: 'AutoRouteWrapper and observer setup',
                code: '''
class AutoRouteWrappedPage extends StatelessWidget
    implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    return _WrappedMessageScope(
      message: 'Provided by AutoRouteWrapper',
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        child: this,
      ),
    );
  }
}

class AutoRouteObserverPageState extends State<AutoRouteObserverPage>
    with AutoRouteAwareStateMixin<AutoRouteObserverPage> {
  @override
  void didPush() {}

  @override
  void didPopNext() {}
}
''',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: () =>
                        context.pushRoute(const AutoRouteWrappedRoute()),
                    icon: const Icon(Icons.wrap_text),
                    label: const Text('Wrapped Route'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        context.pushRoute(const AutoRouteObserverRoute()),
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Observer Demo'),
                  ),
                  OutlinedButton.icon(
                    onPressed: demoNavigationLog.clear,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Clear Logs'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _LogPanel(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

@RoutePage()
class AutoRouteBooksPage extends StatelessWidget {
  const AutoRouteBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Books Path Demo')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const Text(
            'This route is part of the linear path chain used to explain deep-linking to non-nested routes: /auto-route-page -> /auto-route-page/books -> /auto-route-page/books/:id',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          const _CodeCard(
            title: 'Generated route object',
            code: '''
context.pushRoute(
  const AutoRouteBookDetailsRoute(
    id: 42,
    tab: 'overview',
    filter: 'popular',
  ),
);
''',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: () => context.pushRoute(
                  AutoRouteBookDetailsRoute(
                    id: 42,
                    tab: 'overview',
                    filter: 'popular',
                  ),
                ),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open Book 42'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.navigateToPath(
                  '/auto-route-page/books/108?tab=history&filter=recent',
                  includePrefixMatches: true,
                ),
                icon: const Icon(Icons.link),
                label: const Text('Navigate By Path'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@RoutePage()
class AutoRouteBookDetailsPage extends StatelessWidget {
  const AutoRouteBookDetailsPage({
    super.key,
    @PathParam('id') required this.id,
    @QueryParam('tab') this.tab,
    @QueryParam('filter') this.filter,
  });

  final int id;
  final String? tab;
  final String? filter;

  @override
  Widget build(BuildContext context) {
    final Parameters pathParams = context.routeData.params;
    final Parameters queryParams = context.routeData.queryParams;

    return Scaffold(
      appBar: AppBar(title: Text('Book $id')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          _InfoCard(
            title: 'Injected constructor values',
            description: 'id=$id, tab=${tab ?? '-'}, filter=${filter ?? '-'}',
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: 'RouteData values',
            description:
                'pathParams=${pathParams.rawMap}, queryParams=${queryParams.rawMap}',
          ),
          const SizedBox(height: 12),
          const _CodeCard(
            title: 'Path + query example',
            code: '''
AutoRoute(
  page: AutoRouteBookDetailsRoute.page,
  path: '/auto-route-page/books/:id',
)

class AutoRouteBookDetailsPage extends StatelessWidget {
  const AutoRouteBookDetailsPage({
    super.key,
    @PathParam('id') required this.id,
    @QueryParam('tab') this.tab,
    @QueryParam('filter') this.filter,
  });
}
''',
          ),
        ],
      ),
    );
  }
}

@RoutePage()
class AutoRouteNestedPage extends StatelessWidget {
  const AutoRouteNestedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: const <PageRouteInfo>[
        AutoRouteBooksTabRoute(),
        AutoRouteProfileTabRoute(),
        AutoRouteSettingsTabRoute(),
      ],
      builder: (BuildContext context, Widget child, PageController pageController) {
        final TabsRouter tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Nested PageView Demo'),
            actions: <Widget>[
              IconButton(
                tooltip: 'Back to hub',
                onPressed: () =>
                    context.router.navigate(const AutoRouteUsageRoute()),
                icon: const Icon(Icons.home_outlined),
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'This page uses nested child routes rendered with AutoTabsRouter.pageView.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(child: child),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: tabsRouter.setActiveIndex,
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book),
                label: 'Books',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}

@RoutePage()
class AutoRouteBooksTabPage extends StatefulWidget {
  const AutoRouteBooksTabPage({super.key});

  @override
  State<AutoRouteBooksTabPage> createState() => _AutoRouteBooksTabPageState();
}

class _AutoRouteBooksTabPageState extends State<AutoRouteBooksTabPage>
    with AutoRouteAwareStateMixin<AutoRouteBooksTabPage> {
  @override
  void didInitTabRoute(TabPageRoute? previousRoute) {
    demoNavigationLog.add(
      'AutoRouteBooksTab didInitTabRoute from ${previousRoute?.name ?? 'none'}',
    );
  }

  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    demoNavigationLog.add(
      'AutoRouteBooksTab didChangeTabRoute from ${previousRoute.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        const Text(
          'Books tab: this tab participates in nested navigation and observer tab callbacks.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => context.pushRoute(AutoRouteBookDetailsRoute(id: 5)),
          icon: const Icon(Icons.open_in_new),
          label: const Text('Push Stack Route'),
        ),
      ],
    );
  }
}

@RoutePage()
class AutoRouteProfileTabPage extends StatefulWidget {
  const AutoRouteProfileTabPage({super.key});

  @override
  State<AutoRouteProfileTabPage> createState() =>
      _AutoRouteProfileTabPageState();
}

class _AutoRouteProfileTabPageState extends State<AutoRouteProfileTabPage>
    with AutoRouteAwareStateMixin<AutoRouteProfileTabPage> {
  @override
  void didInitTabRoute(TabPageRoute? previousRoute) {
    demoNavigationLog.add(
      'AutoRouteProfileTab didInitTabRoute from ${previousRoute?.name ?? 'none'}',
    );
  }

  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    demoNavigationLog.add(
      'AutoRouteProfileTab didChangeTabRoute from ${previousRoute.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Profile tab: switching to this tab triggers observer events from AutoRouteObserver and DemoAutoRouterObserver.',
        ),
      ),
    );
  }
}

@RoutePage()
class AutoRouteSettingsTabPage extends StatefulWidget {
  const AutoRouteSettingsTabPage({super.key});

  @override
  State<AutoRouteSettingsTabPage> createState() =>
      _AutoRouteSettingsTabPageState();
}

class _AutoRouteSettingsTabPageState extends State<AutoRouteSettingsTabPage>
    with AutoRouteAwareStateMixin<AutoRouteSettingsTabPage> {
  @override
  void didInitTabRoute(TabPageRoute? previousRoute) {
    demoNavigationLog.add(
      'AutoRouteSettingsTab didInitTabRoute from ${previousRoute?.name ?? 'none'}',
    );
  }

  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    demoNavigationLog.add(
      'AutoRouteSettingsTab didChangeTabRoute from ${previousRoute.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Settings tab: AutoTabsRouter.pageView keeps each child route as a real route, not just a plain widget page.',
        ),
      ),
    );
  }
}

@RoutePage()
class AutoRouteProductPage extends StatelessWidget {
  const AutoRouteProductPage({
    super.key,
    @PathParam('id') required this.id,
    @QueryParam('tab') this.tab,
  });

  final String id;
  final String? tab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product $id')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Parent route path param id=$id, tab=${tab ?? '-'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: () => context.navigateToPath(
                        '/auto-route-page/products/$id',
                        includePrefixMatches: true,
                      ),
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Overview'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.navigateToPath(
                        '/auto-route-page/products/$id/review?source=product-page',
                        includePrefixMatches: true,
                      ),
                      icon: const Icon(Icons.rate_review_outlined),
                      label: const Text('Review Child'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const Expanded(child: AutoRouter()),
        ],
      ),
    );
  }
}

@RoutePage()
class AutoRouteProductOverviewPage extends StatelessWidget {
  const AutoRouteProductOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        _InfoCard(
          title: 'Overview child route',
          description:
              'This is the initial child route under /auto-route-page/products/:id.',
        ),
        const SizedBox(height: 12),
        const _CodeCard(
          title: 'Nested child route setup',
          code: '''
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
)
''',
        ),
      ],
    );
  }
}

@RoutePage()
class AutoRouteProductReviewPage extends StatelessWidget {
  const AutoRouteProductReviewPage({
    super.key,
    @PathParam.inherit('id') required this.productId,
    @QueryParam('source') this.source,
  });

  final String productId;
  final String? source;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        _InfoCard(
          title: 'Inherited Path Parameter',
          description:
              'productId=$productId inherited from the parent /products/:id path. source=${source ?? '-'} came from query params.',
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'RouteData snapshot',
          description:
              'pathParams=${context.routeData.params.rawMap}, queryParams=${context.routeData.queryParams.rawMap}',
        ),
      ],
    );
  }
}

@RoutePage()
class AutoRouteProtectedPage extends StatelessWidget {
  const AutoRouteProtectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _GuardedDemoScaffold(
      title: 'Route Guard Demo',
      description:
          'This page is protected by a guard attached directly to the route definition. Logging out will trigger reevaluation because reevaluateListenable is wired to demoAuthController.',
    );
  }
}

@RoutePage()
class AutoRouteGlobalProtectedPage extends StatelessWidget {
  const AutoRouteGlobalProtectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _GuardedDemoScaffold(
      title: 'Global Guard Demo',
      description:
          'This page is protected by the router-level global guards list. The guard only enforces auth for this route so the rest of the app keeps normal behavior.',
    );
  }
}

@RoutePage()
class AutoRouteLoginPage extends StatelessWidget {
  const AutoRouteLoginPage({super.key, this.onResult});

  final void Function(bool didLogin)? onResult;

  void _completeLogin(BuildContext context) {
    demoAuthController.login();
    demoNavigationLog.add('login completed from AutoRouteLoginPage');
    if (onResult != null) {
      onResult!(true);
      return;
    }
    context.router.replace(const AutoRouteUsageRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('auto_route Login Demo')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const _InfoCard(
            title: 'Guard redirect target',
            description:
                'Guards redirect here using resolver.redirectUntil(...). After login, resolver.resolveNext(...) resumes the original navigation.',
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _completeLogin(context),
            icon: const Icon(Icons.login),
            label: const Text('Log In And Continue'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              demoAuthController.logout();
              onResult?.call(false);
              context.router.replace(const AutoRouteUsageRoute());
            },
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

@RoutePage()
class AutoRouteWrappedPage extends StatelessWidget implements AutoRouteWrapper {
  const AutoRouteWrappedPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return _WrappedMessageScope(
      message: 'Provided by AutoRouteWrapper',
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _WrappedMessageScopeData data = _WrappedMessageScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Wrapped Route Demo')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          _InfoCard(
            title: 'Wrapper effect',
            description:
                '${data.message}. This page is wrapped with a seeded Theme and a custom inherited message before it is rendered.',
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Wrapped color',
            description:
                'Current primary color = ${Theme.of(context).colorScheme.primary}',
          ),
        ],
      ),
    );
  }
}

@RoutePage()
class AutoRouteObserverPage extends StatefulWidget {
  const AutoRouteObserverPage({super.key});

  @override
  State<AutoRouteObserverPage> createState() => _AutoRouteObserverPageState();
}

class _AutoRouteObserverPageState extends State<AutoRouteObserverPage>
    with AutoRouteAwareStateMixin<AutoRouteObserverPage> {
  @override
  void didPush() {
    demoNavigationLog.add('AutoRouteObserverPage didPush');
  }

  @override
  void didPushNext() {
    demoNavigationLog.add('AutoRouteObserverPage didPushNext');
  }

  @override
  void didPopNext() {
    demoNavigationLog.add('AutoRouteObserverPage didPopNext');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Observer Demo')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const _InfoCard(
            title: 'AutoRouteAware screen',
            description:
                'This page subscribes through AutoRouteAwareStateMixin. Pushing another page and returning here will add didPushNext and didPopNext entries to the log.',
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () =>
                context.pushRoute(AutoRouteBookDetailsRoute(id: 3)),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Push Another Page'),
          ),
          const SizedBox(height: 16),
          const _LogPanel(),
        ],
      ),
    );
  }
}

@RoutePage()
class AutoRouteUnknownPage extends StatelessWidget {
  const AutoRouteUnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wildcard Route Demo')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const _InfoCard(
            title: 'Wildcard matched',
            description:
                'This page catches undefined /auto-route-page/* paths. Wildcards should always be placed after the more specific routes they might shadow.',
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Current top route',
            description: context.topRoute.name,
          ),
        ],
      ),
    );
  }
}

class _GuardedDemoScaffold extends StatelessWidget {
  const _GuardedDemoScaffold({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: AnimatedBuilder(
        animation: demoAuthController,
        builder: (BuildContext context, Widget? child) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              _InfoCard(title: title, description: description),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Auth state',
                description: demoAuthController.isLoggedIn
                    ? 'Logged in'
                    : 'Logged out',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: demoAuthController.login,
                    icon: const Icon(Icons.lock_open),
                    label: const Text('Log In'),
                  ),
                  OutlinedButton.icon(
                    onPressed: demoAuthController.logout,
                    icon: const Icon(Icons.lock_outline),
                    label: const Text('Log Out'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WrappedMessageScope extends InheritedWidget {
  const _WrappedMessageScope({required this.message, required super.child});

  final String message;

  static _WrappedMessageScopeData of(BuildContext context) {
    final _WrappedMessageScope? scope = context
        .dependOnInheritedWidgetOfExactType<_WrappedMessageScope>();
    assert(scope != null, 'No _WrappedMessageScope found in context');
    return _WrappedMessageScopeData(message: scope!.message);
  }

  @override
  bool updateShouldNotify(_WrappedMessageScope oldWidget) {
    return message != oldWidget.message;
  }
}

class _WrappedMessageScopeData {
  const _WrappedMessageScopeData({required this.message});

  final String message;
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.isLoggedIn, required this.logCount});

  final bool isLoggedIn;
  final int logCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            _StatusChip(
              label: isLoggedIn ? 'Auth: logged in' : 'Auth: logged out',
              color: isLoggedIn ? Colors.green : Colors.red,
            ),
            _StatusChip(label: 'Observer logs: $logCount', color: Colors.blue),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.description,
    required this.primaryLabel,
    required this.onPrimaryPressed,
  });

  final String title;
  final String description;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onPrimaryPressed,
              child: Text(primaryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectionArea(
                child: Text(
                  code.trim(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LogPanel extends StatelessWidget {
  const _LogPanel();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: demoNavigationLog,
      builder: (BuildContext context, Widget? child) {
        final List<String> entries = demoNavigationLog.entries;
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Navigation Observer Log',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                if (entries.isEmpty)
                  const Text('No observer events recorded yet.')
                else
                  ...entries
                      .take(10)
                      .map(
                        (String entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(entry),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
