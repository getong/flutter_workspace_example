import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'src/app_router.dart';
import 'src/data/local/app_database.dart';
import 'src/data/local/drift_hydrated_storage.dart';
import 'src/data/remote/layout_api_client.dart';
import 'src/presentation/layout_catalog_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppDatabase database = await AppDatabase.create();
  final DriftHydratedStorage hydratedStorage = await DriftHydratedStorage.build(
    database,
  );

  HydratedBloc.storage = hydratedStorage;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: <String, Object>{
        'accept': 'application/json',
        'user-agent': 'hydrated-bloc-drift-example/1.0',
      },
    ),
  );
  final LayoutApiClient apiClient = LayoutApiClient(dio);
  final LayoutCatalogBloc catalogBloc = LayoutCatalogBloc(apiClient)
    ..add(const LayoutCatalogBootstrapRequested());

  runApp(AppRoot(catalogBloc: catalogBloc, hydratedStorage: hydratedStorage));
}

class AppRoot extends StatelessWidget {
  const AppRoot({
    required this.catalogBloc,
    required this.hydratedStorage,
    super.key,
  });

  final LayoutCatalogBloc catalogBloc;
  final DriftHydratedStorage hydratedStorage;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: <RepositoryProvider<dynamic>>[
        RepositoryProvider<DriftHydratedStorage>.value(value: hydratedStorage),
      ],
      child: BlocProvider<LayoutCatalogBloc>.value(
        value: catalogBloc,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: const Locale('en', 'US'),
          supportedLocales: const <Locale>[Locale('en', 'US')],
          routerConfig: buildAppRouter(hydratedStorage: hydratedStorage),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
