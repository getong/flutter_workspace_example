import 'package:auto_route/auto_route.dart';
import 'package:bloc_drift_example/home/view/home_page.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_repository.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_snapshot_cache.dart';
import 'package:bloc_drift_example/offline_orders/view/offline_orders_page.dart';
import 'package:flutter/widgets.dart';

class AppRouter {
  AppRouter({
    required OfflineOrdersRepository repository,
    required OfflineOrdersSnapshotCache snapshotCache,
  }) : _router = RootStackRouter.build(
         routes: [
           NamedRouteDef(
             name: HomeRoute.name,
             path: '/',
             initial: true,
             builder: (_, _) => const HomePage(),
           ),
           NamedRouteDef(
             name: OfflineOrdersRoute.name,
             path: '/offline-orders',
             builder: (_, _) => OfflineOrdersPage(
               repository: repository,
               snapshotCache: snapshotCache,
             ),
           ),
         ],
       );

  final RootStackRouter _router;

  RouterConfig<Object> config() => _router.config();
}

class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute() : super(name);

  static const String name = 'HomeRoute';
}

class OfflineOrdersRoute extends PageRouteInfo<void> {
  const OfflineOrdersRoute() : super(name);

  static const String name = 'OfflineOrdersRoute';
}
