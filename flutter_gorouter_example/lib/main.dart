import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

void main(List<String> args) {
  setPathUrlStrategy();
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: "Go router",
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      name: "home",
      path: "/",
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          name: "settings",
          path: "settings/:name",
          builder: (context, state) {
            return SettingsPage(
              name: state.params["name"]!,
            );
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.goNamed("settings", params: {
            "name": "codemagic"
          }, queryParams: {
            "email": "example@gmail.com",
            "age": "25",
            "place": "India"
          }),
          child: const Text("Go to Settings page"),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final String name;

  const SettingsPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(name),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.goNamed("home"),
          child: const Text("Go to home page"),
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Error Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go("/"),
          child: const Text("Go to home page"),
        ),
      ),
    );
  }
}