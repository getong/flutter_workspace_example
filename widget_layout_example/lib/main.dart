import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:widget_layout_example/modules/center_box_page.dart';
import 'package:widget_layout_example/modules/constrained_box_page.dart';
import 'package:widget_layout_example/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'center-box',
          builder: (BuildContext context, GoRouterState state) {
            return const CenterBoxPage();
          },
        ),
        GoRoute(
          path: 'constrained-box',
          builder: (BuildContext context, GoRouterState state) {
            return const ConstrainedBoxPage();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Widget Layout Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: _router,
    );
  }
}
