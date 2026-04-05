import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'bloc_detail.dart';
import 'chat_page.dart';

// Create keys for `root` & `section` navigator avoiding unnecessary rebuilds
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/feed',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
        // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
        return ScaffoldWithNavbar(navigationShell);
      },
      branches: [
        // The route branch for the 1º Tab
        StatefulShellBranch(
          navigatorKey: _sectionNavigatorKey,
          // Add this branch routes
          // each routes with its sub routes if available e.g feed/uuid/details
          routes: <RouteBase>[
            GoRoute(
              path: '/feed',
              builder: (context, state) => const FeedPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'details',
                  builder: (context, state) {
                    return const DetailsPage(label: 'FeedDetails');
                  },
                ),
                GoRoute(
                  path: 'homepage',
                  builder: (BuildContext context, GoRouterState state) {
                    return BlocProvider(
                      create: (context) => CounterBloc(),
                      child: MyHomePage(),
                    );
                  },
                ),
                GoRoute(
                  path: 'blocdetails/:value',
                  builder: (BuildContext context, GoRouterState state) {
                    final String value = state.pathParameters['value']!;
                    return BlocDetailsPage(value: value);
                  },
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          // each routes with its sub routes if available e.g shope/uuid/details
          GoRoute(
            path: '/chat_page',
            builder: (context, state) {
              return ChatPage();
            },
          ),
        ]),

        // The route branch for 2º Tab
        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          // each routes with its sub routes if available e.g shope/uuid/details
          GoRoute(
            path: '/shope',
            builder: (context, state) {
              return const DetailsPage(label: 'Shope');
            },
          ),
        ]),
      ],
    ),
  ],
);
