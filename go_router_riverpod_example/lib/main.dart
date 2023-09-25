import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Create a provider for the current user.
final currentUserProvider = Provider<User>((ref) {
  // TODO: Implement this to return the current user.
  return User();
});

// Define the routes for the app.
final goRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: goRouter,
        title: 'Flutter + Riverpod + GoRouter Example',
      ),
    );
  }
}

class User {
  String name = "a";
}

// Create a widget that displays the current user's name.
class CurrentUserName extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Center(
        child: Column(children: <Widget>[
      Text(user.name),
      ElevatedButton(
        onPressed: () => context.go('/login'),
        child: const Text('Go to the login page'),
      ),
    ]));
  }
}

// Create a widget that displays a button that navigates to the login page.
class LoginButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = GoRouter.of(context);
    return ElevatedButton(
      onPressed: () {
        goRouter.goNamed('/login');
      },
      child: Text('Login'),
    );
  }
}

// Create a widget that displays the login page.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: LoginButton(),
      ),
    );
  }
}

// Create a widget that displays the home page.
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: CurrentUserName(),
      ),
    );
  }
}
