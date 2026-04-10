import 'package:bloc_drift_example/app/app.dart';
import 'package:bloc_drift_example/offline_orders/data/app_database.dart';
import 'package:bloc_drift_example/offline_orders/data/fake_orders_api.dart';
import 'package:bloc_drift_example/offline_orders/data/network_info.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_repository.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_snapshot_cache.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();

  final networkInfo = NetworkInfoImpl(
    connectivity: Connectivity(),
    internetConnectionChecker: InternetConnectionChecker.createInstance(),
  );
  final repository = OfflineOrdersRepository(
    database: AppDatabase(),
    api: const FakeOrdersApi(),
    networkInfo: networkInfo,
    snapshotCache: OfflineOrdersSnapshotCache(preferences: preferences),
  );

  runApp(BlocDriftExampleApp(repository: repository));
}
