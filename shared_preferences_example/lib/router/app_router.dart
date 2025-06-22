import 'package:go_router/go_router.dart';
import '../pages/counter_page.dart';
import '../pages/settings_page.dart';
import '../pages/profile_page.dart';

/// Router configuration for the app
class AppRouter {
  static final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const CounterPage()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
