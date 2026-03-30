import 'package:flutter/material.dart';

import 'app_router.dart';

void main() {
  runApp(const AssortedLayoutWidgetsApp());
}

class AssortedLayoutWidgetsApp extends StatelessWidget {
  const AssortedLayoutWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
      brightness: Brightness.light,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Assorted Layout Widgets',
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF7F2EA),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
        ),
      ),
    );
  }
}
