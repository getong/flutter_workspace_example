import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class CustomTransitionBuilder {
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );
}

class FadeTransitionBuilder extends CustomTransitionBuilder {
  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class SlideTransitionBuilder extends CustomTransitionBuilder {
  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: child,
    );
  }
}

class ScaleTransitionBuilder extends CustomTransitionBuilder {
  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: animation.drive(
        Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
      ),
      child: child,
    );
  }
}

class RotationTransitionBuilder extends CustomTransitionBuilder {
  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RotationTransition(
      turns: animation.drive(
        Tween(begin: 0.25, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}

// Helper function to create custom transition pages
Page<T> buildPageWithTransition<T extends Object?>(
  Widget child,
  GoRouterState state, {
  CustomTransitionBuilder? transitionBuilder,
}) {
  if (transitionBuilder != null) {
    return AppCustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionBuilder: transitionBuilder,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }
  return MaterialPage<T>(key: state.pageKey, child: child);
}

class AppCustomTransitionPage<T> extends Page<T> {
  final Widget child;
  final CustomTransitionBuilder transitionBuilder;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;

  const AppCustomTransitionPage({
    required this.child,
    required this.transitionBuilder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    super.key,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return transitionBuilder.buildTransition(
          context,
          animation,
          secondaryAnimation,
          child,
        );
      },
    );
  }
}
