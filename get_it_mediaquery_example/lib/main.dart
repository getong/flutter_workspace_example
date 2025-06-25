import 'package:flutter/material.dart';
import 'service_locator.dart';
import 'widgets/context_updater.dart';
import 'screens/home_page.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetIt Context Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ContextUpdater(
        child: MyHomePage(title: 'GetIt Context Demo'),
      ),
    );
  }
}
