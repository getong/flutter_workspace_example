import 'package:go_router/go_router.dart';
import 'home_page.dart';
import 'time_page.dart';
import 'param_page.dart';

// Enum for route names and paths
enum RouterEnum {
  home('/'),
  time('/time'),
  param('/param/:value');

  final String path;
  const RouterEnum(this.path);
}

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RouterEnum.home.path,
      name: RouterEnum.home.name,
      builder: (context, state) =>
          const MyHomePage(title: 'Flutter Demo Home Page'),
    ),
    GoRoute(
      path: RouterEnum.time.path,
      name: RouterEnum.time.name,
      builder: (context, state) => const TimePage(),
    ),
    GoRoute(
      path: RouterEnum.param.path,
      name: RouterEnum.param.name,
      builder: (context, state) =>
          ParamPage(value: state.pathParameters['value'] ?? ''),
    ),
  ],
);
