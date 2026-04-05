import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Global navigation service demonstrating _rootNavigatorKey usage
///
/// This service provides global navigation methods that can be called
/// from anywhere in the app without requiring a BuildContext.
/// It demonstrates the power of _rootNavigatorKey for global navigation control.
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  /// Root navigator key - allows global navigation control
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  /// Get the current context from root navigator
  BuildContext? get currentContext => rootNavigatorKey.currentContext;

  /// Navigate to any route globally without BuildContext
  void navigateToRoute(String route) {
    final context = currentContext;
    if (context != null) {
      GoRouter.of(context).go(route);
    }
  }

  /// Push route globally without BuildContext
  void pushRoute(String route) {
    final context = currentContext;
    if (context != null) {
      GoRouter.of(context).push(route);
    }
  }

  /// Show global dialog using _rootNavigatorKey
  Future<T?> showGlobalDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    final context = currentContext;
    if (context != null) {
      return showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => dialog,
      );
    }
    return Future.value(null);
  }

  /// Show global snackbar using _rootNavigatorKey
  void showGlobalSnackBar(String message) {
    final context = currentContext;
    if (context != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  /// Navigate to login page (authentication example)
  void navigateToLogin() {
    navigateToRoute('/auth');
  }

  /// Show fullscreen overlay globally
  void showFullscreenOverlay() {
    pushRoute('/fullscreen-overlay');
  }

  /// Handle deep link navigation
  void handleDeepLink(String deepLink) {
    // Example: Handle external deep links
    if (deepLink.contains('profile')) {
      navigateToRoute('/profile');
    } else if (deepLink.contains('settings')) {
      navigateToRoute('/settings');
    } else {
      navigateToRoute('/home');
    }
  }

  /// Pop current route globally
  void popRoute() {
    final context = currentContext;
    if (context != null && GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    }
  }

  /// Check if can pop (useful for handling back button)
  bool canPop() {
    final context = currentContext;
    if (context != null) {
      return GoRouter.of(context).canPop();
    }
    return false;
  }
}
