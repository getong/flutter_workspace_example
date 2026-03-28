import 'package:flutter/material.dart';

import 'app_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ).copyWith(secondary: Colors.amber),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
