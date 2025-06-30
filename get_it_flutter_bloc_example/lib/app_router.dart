import 'package:go_router/go_router.dart';
import 'home_page.dart';
import 'time_page.dart';
import 'param_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const MyHomePage(title: 'Flutter Demo Home Page'),
    ),
    GoRoute(path: '/time', builder: (context, state) => const TimePage()),
    GoRoute(
      path: '/param/:value',
      builder: (context, state) =>
          ParamPage(value: state.pathParameters['value'] ?? ''),
    ),
  ],
);
