import 'package:flutter/material.dart';
import 'get_it_setup.dart';
import 'package:go_router/go_router.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: getIt<GoRouter>(), // Now GoRouter is recognized
    );
  }
}
