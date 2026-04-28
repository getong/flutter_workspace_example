import 'package:auto_route/auto_route.dart';

import '../../features/advice/presentation/views/advice_view.dart';
import '../../features/serve_pem/presentation/views/app_tabs_view.dart';
import '../../features/serve_pem/presentation/views/home_view.dart';
import '../../features/serve_pem/presentation/views/public_key_view.dart';
import '../../features/serve_pem/presentation/views/register_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route', generateForDir: ['lib'])
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: AppTabsRoute.page,
      initial: true,
      children: [
        AutoRoute(page: AdviceRoute.page, path: 'advice', initial: true),
        AutoRoute(page: HomeRoute.page, path: 'serve-pem'),
      ],
    ),
    AutoRoute(page: PublicKeyRoute.page),
    AutoRoute(page: RegisterRoute.page),
  ];
}
