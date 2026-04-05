import 'package:flutter/material.dart';
import 'router.dart';

/// Main entry point for the GoRouter ShellRoute example
///
/// This example demonstrates how to use GoRouter with ShellRoute to create
/// a persistent navigation structure in Flutter applications.
void main() {
  runApp(const MyApp());
}

/// Root application widget using GoRouter for navigation
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter ShellRoute Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
