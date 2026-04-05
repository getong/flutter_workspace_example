import 'package:go_router/go_router.dart';
import '../pages/counter_page.dart';
import '../pages/hello_world_page.dart';
import '../pages/di_page.dart';
import '../enums/router_enum.dart';

class RouterService {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: RouterEnum.homePage.routeName,
      routes: [
        GoRoute(
          path: RouterEnum.initialLocation.routeName,
          builder: (context, state) => const DIPage(),
        ),
        GoRoute(
          path: RouterEnum.homePage.routeName,
          builder: (context, state) => const DIPage(),
        ),
        GoRoute(
          path: RouterEnum.counterView.routeName,
          builder: (context, state) => const CounterPage(),
        ),
        GoRoute(
          path: RouterEnum.helloWorldView.routeName,
          builder: (context, state) => HelloWorldPage(
            resetCounter: state.uri.queryParameters['reset'] ?? 'none',
          ),
        ),
      ],
    );
  }
}
