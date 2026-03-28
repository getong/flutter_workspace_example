import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'pages/container_catalog.dart';
import 'pages/container_detail_page.dart';
import 'pages/container_home_page.dart';
import 'pages/button_container.dart';
import 'pages/button_container2.dart';
import 'pages/button_container3.dart';
import 'pages/button_container4.dart';
import 'pages/button_container5.dart';
import 'pages/button_container6.dart';
import 'pages/button_container7.dart';
import 'pages/button_container8.dart';
import 'pages/not_found_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const ContainerHomePage();
      },
    ),
    GoRoute(
      path: '/containers/:slug',
      name: 'container',
      builder: (BuildContext context, GoRouterState state) {
        final String slug = state.pathParameters['slug']!;
        final ContainerPageSpec? page = findContainerPage(slug);
        if (page == null) {
          return NotFoundPage(slug: slug);
        }
        return ContainerDetailPage(page: page);
      },
    ),
    GoRoute(
      path: '/button_container',
      name: 'button_container',
      builder: (BuildContext context, GoRouterState state) {
        return const ButtonContainer();
      },
    ),
    GoRoute(
      path: '/button_container2',
      name: 'button_container2',
      builder: (BuildContext context, GoRouterState state) {
        return const ButtonContainer2();
      },
    ),
    GoRoute(
      path: '/button_container3',
      name: 'button_container3',
      builder: (BuildContext context, GoRouterState state) {
        return const ButtonContainer3();
      },
    ),
    GoRoute(
      path: '/button_container4',
      name: 'button_container4',
      builder: (BuildContext context, GoRouterState state) {
        return const ButtonContainer4();
      },
    ),
    GoRoute(
      path: '/button_container5',
      name: 'button_container5',
      builder: (BuildContext context, GoRouterState state) {
        return const ButtonContainer5();
      },
    ),
    GoRoute(
      path: '/button_container6',
      name: 'button_container6',
      builder: (BuildContext context, GoRouterState state) {
        return const ButtonContainer6();
      },
    ),
    GoRoute(
      path: '/button_container7',
      name: 'button_container7',
      builder: (BuildContext context, GoRouterState state) {
        return const ButtonContainer7();
      },
    ),
    GoRoute(
      path: '/button_container8',
      name: 'button_container8',
      builder: (BuildContext context, GoRouterState state) {
        return const ButtonContainer8();
      },
    ),
  ],
);
