import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'services/navigation_service.dart';
import 'shell_widget.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/details_page.dart';
import 'pages/auth_page.dart';
import 'pages/fullscreen_overlay_page.dart';

/// Navigator keys for managing navigation state
/// Using NavigationService.rootNavigatorKey for global access
final GlobalKey<NavigatorState> _rootNavigatorKey =
    NavigationService.rootNavigatorKey;
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

/// Router configuration demonstrating comprehensive _rootNavigatorKey usage
///
/// This configuration shows:
/// - ShellRoute for persistent navigation (bottom navigation bar)
/// - Full-screen routes using parentNavigatorKey: _rootNavigatorKey
/// - Authentication flow outside of shell
/// - Modal overlays and dialogs
/// - Global navigation control via NavigationService
final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',

  /// Global redirect logic using _rootNavigatorKey
  redirect: (context, state) {
    // Example: Redirect logic for authentication
    // This demonstrates how _rootNavigatorKey enables global state management
    final isAuthRequired = state.uri.path.startsWith('/protected');
    if (isAuthRequired) {
      // Could check authentication state here
      // return '/auth';
    }
    return null; // No redirect needed
  },

  /// Error handling using _rootNavigatorKey
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            Text('Error: ${state.error}'),
            ElevatedButton(
              onPressed: () => NavigationService().navigateToRoute('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },

  routes: [
    /// Authentication route - uses _rootNavigatorKey for full-screen display
    GoRoute(
      path: '/auth',
      name: 'auth',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          MaterialPage(child: const AuthPage(), fullscreenDialog: true),
    ),

    /// Fullscreen overlay route - demonstrates modal navigation
    GoRoute(
      path: '/fullscreen-overlay',
      name: 'fullscreenOverlay',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        child: const FullscreenOverlayPage(),
        fullscreenDialog: true,
      ),
    ),

    /// ShellRoute maintains persistent widget across child routes
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ShellWidget(child: child);
      },
      routes: [
        /// Home tab route with nested routes
        GoRoute(
          path: '/home',
          name: 'home',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomePage()),
          routes: [
            /// Details route - uses _rootNavigatorKey for full-screen display
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
