import 'package:auto_route/auto_route.dart';

import 'package:mai_ui_demo/app/shell/app_shell.dart';
import 'package:mai_ui_demo/features/destinations/pages/destination_page.dart';
import 'package:mai_ui_demo/features/home/pages/home_page.dart';
import 'package:mai_ui_demo/features/notifications/pages/notifications_page.dart';
import 'package:mai_ui_demo/features/profile/pages/profile_page.dart';
import 'package:mai_ui_demo/features/saved/pages/saved_page.dart';
import 'package:mai_ui_demo/features/trips/pages/trips_page.dart';

class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    NamedRouteDef(
      name: 'ShellRoute',
      path: '/',
      builder: (_, _) => const AppShell(),
      children: [
        NamedRouteDef(
          name: 'HomeRoute',
          path: '',
          initial: true,
          builder: (_, _) => const HomePage(),
        ),
        NamedRouteDef(
          name: 'TripsRoute',
          path: 'trips',
          builder: (_, _) => const TripsPage(),
        ),
        NamedRouteDef(
          name: 'SavedRoute',
          path: 'saved',
          builder: (_, _) => const SavedPage(),
        ),
        NamedRouteDef(
          name: 'ProfileRoute',
          path: 'profile',
          builder: (_, _) => const ProfilePage(),
        ),
      ],
    ),
    NamedRouteDef(
      name: 'DestinationRoute',
      path: '/destination/:id',
      builder: (_, data) => DestinationPage(id: data.params.getString('id')),
    ),
    NamedRouteDef(
      name: 'NotificationsRoute',
      path: '/notifications',
      builder: (_, _) => const NotificationsPage(),
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ];
}
