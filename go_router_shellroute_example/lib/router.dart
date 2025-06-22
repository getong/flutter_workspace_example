import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shell_widget.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/details_page.dart';

/// Navigator keys for managing navigation state
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

/// Router configuration for the application using GoRouter with ShellRoute
///
/// This configuration demonstrates:
/// - ShellRoute for persistent navigation (bottom navigation bar)
/// - Nested routes within the shell
/// - Navigation between different pages while maintaining the shell
final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    /// ShellRoute maintains a persistent widget (like bottom navigation)
    /// across multiple child routes. The shell widget will persist while
    /// the content area changes based on the current route.
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ShellWidget(child: child);
      },
      routes: [
        /// Home tab route
        GoRoute(
          path: '/home',
          name: 'home',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomePage()),
          routes: [
            /// Nested route under home - demonstrates navigation within shell
            /// Uses parentNavigatorKey to display on root navigator (full screen)
            GoRoute(
              path: 'details/:id',
              name: 'details',
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) {
                final id = state.pathParameters['id'] ?? '0';
                return MaterialPage(child: DetailsPage(id: id));
              },
            ),
          ],
        ),

        /// Profile tab route
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProfilePage()),
        ),

        /// Settings tab route
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingsPage()),
        ),
      ],
    ),
  ],
);
