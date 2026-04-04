import 'package:flutter/material.dart';

import 'src/router/app_router.dart';
import 'src/theme.dart';

class StitchChatApp extends StatefulWidget {
  const StitchChatApp({super.key});

  @override
  State<StitchChatApp> createState() => _StitchChatAppState();
}

class _StitchChatAppState extends State<StitchChatApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Stitch Chat',
      debugShowCheckedModeBanner: false,
      theme: buildAtriumTheme(),
      routerConfig: _appRouter.config(),
    );
  }
}
