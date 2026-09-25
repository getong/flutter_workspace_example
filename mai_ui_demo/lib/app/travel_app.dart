import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/router/app_router.dart';
import 'package:mai_ui_demo/app/state/travel_scope.dart';
import 'package:mai_ui_demo/app/state/travel_store.dart';
import 'package:mai_ui_demo/core/theme/app_theme.dart';

class TravelApp extends StatefulWidget {
  const TravelApp({super.key, required this.store});
  final TravelStore store;
  @override
  State<TravelApp> createState() => _TravelAppState();
}

class _TravelAppState extends State<TravelApp> {
  final router = AppRouter();
  late final config = router.config();
  @override
  void dispose() {
    router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TravelScope(
    store: widget.store,
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: '远行 · 去有风的地方',
      theme: buildAppTheme(),
      routerConfig: config,
    ),
  );
}
