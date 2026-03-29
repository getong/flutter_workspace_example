import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'pages/animation_home_page.dart';
import 'pages/curved_animation_page.dart';
import 'pages/not_found_page.dart';
import 'pages/raw_ticker_page.dart';
import 'pages/ticker_provider_page.dart';
import 'pages/tween_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const AnimationHomePage();
      },
    ),
    GoRoute(
      path: '/ticker-provider',
      name: 'ticker_provider',
      builder: (BuildContext context, GoRouterState state) {
        return const TickerProviderPage();
      },
    ),
    GoRoute(
      path: '/raw-ticker',
      name: 'raw_ticker',
      builder: (BuildContext context, GoRouterState state) {
        return const RawTickerPage();
      },
    ),
    GoRoute(
      path: '/curved-animation',
      name: 'curved_animation',
      builder: (BuildContext context, GoRouterState state) {
        return const CurvedAnimationPage();
      },
    ),
    GoRoute(
      path: '/tween',
      name: 'tween',
      builder: (BuildContext context, GoRouterState state) {
        return const TweenPage();
      },
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return NotFoundPage(path: state.uri.toString());
  },
);
