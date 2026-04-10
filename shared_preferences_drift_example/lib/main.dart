import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'catalog/data/app_database.dart';
import 'catalog/data/datasources/catalog_local_datasource.dart';
import 'catalog/data/datasources/catalog_remote_datasource.dart';
import 'catalog/data/datasources/catalog_sync_preferences.dart';
import 'catalog/data/repositories/catalog_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{CatalogSyncPreferences.lastSyncKey},
    ),
  );

  final repository = CatalogRepositoryImpl(
    localDataSource: CatalogLocalDataSource(AppDatabase()),
    remoteDataSource: const CatalogRemoteDataSource(),
    syncPreferences: CatalogSyncPreferences(preferences),
  );

  runApp(MyApp(repository: repository));
}
