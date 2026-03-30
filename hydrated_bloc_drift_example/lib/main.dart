import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app_router.dart';
import 'data/local/app_database.dart';
import 'data/local/drift_hydrated_storage.dart';
import 'data/remote/layout_api_client.dart';
import 'data/repositories/fetch_history_repository.dart';
import 'presentation/fetch_request_bloc.dart';
import 'presentation/layout_catalog_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final Future<_AppServices> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = _createServices();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AppServices>(
      future: _bootstrapFuture,
      builder: (BuildContext context, AsyncSnapshot<_AppServices> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(title: const Text('HydratedBloc + Drift + Dio')),
              body: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(title: const Text('Startup Error')),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  'App failed to start.\n\n${snapshot.error}',
                ),
              ),
            ),
          );
        }

        final _AppServices services = snapshot.data!;
        return AppRoot(
          database: services.database,
          hydratedStorage: services.hydratedStorage,
          fetchHistoryRepository: services.fetchHistoryRepository,
          layoutCatalogBloc: services.layoutCatalogBloc,
          fetchRequestBloc: services.fetchRequestBloc,
        );
      },
    );
  }

  Future<_AppServices> _createServices() async {
    final AppDatabase database = await AppDatabase.create();
    final DriftHydratedStorage hydratedStorage =
        await DriftHydratedStorage.build(database);
    HydratedBloc.storage = hydratedStorage;

    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: <String, Object>{
          'accept': 'application/json',
          'user-agent': 'hydrated-bloc-drift-example/1.0',
        },
      ),
    );
    final FetchHistoryRepository fetchHistoryRepository =
        FetchHistoryRepository(dio: dio, database: database);
    final Dio layoutDio = Dio(
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
    final LayoutApiClient layoutApiClient = LayoutApiClient(layoutDio);
    final LayoutCatalogBloc layoutCatalogBloc = LayoutCatalogBloc(
      layoutApiClient,
    )..add(const LayoutCatalogBootstrapRequested());
    final FetchRequestBloc fetchRequestBloc = FetchRequestBloc(
      fetchHistoryRepository,
    );

    return _AppServices(
      database: database,
      hydratedStorage: hydratedStorage,
      fetchHistoryRepository: fetchHistoryRepository,
      layoutCatalogBloc: layoutCatalogBloc,
      fetchRequestBloc: fetchRequestBloc,
    );
  }
}

class _AppServices {
  const _AppServices({
    required this.database,
    required this.hydratedStorage,
    required this.fetchHistoryRepository,
    required this.layoutCatalogBloc,
    required this.fetchRequestBloc,
  });

  final AppDatabase database;
  final DriftHydratedStorage hydratedStorage;
  final FetchHistoryRepository fetchHistoryRepository;
  final LayoutCatalogBloc layoutCatalogBloc;
  final FetchRequestBloc fetchRequestBloc;
}

class AppRoot extends StatelessWidget {
  const AppRoot({
    required this.database,
    required this.hydratedStorage,
    required this.fetchHistoryRepository,
    required this.layoutCatalogBloc,
    required this.fetchRequestBloc,
    super.key,
  });

  final AppDatabase database;
  final DriftHydratedStorage hydratedStorage;
  final FetchHistoryRepository fetchHistoryRepository;
  final LayoutCatalogBloc layoutCatalogBloc;
  final FetchRequestBloc fetchRequestBloc;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: <RepositoryProvider<dynamic>>[
        RepositoryProvider<AppDatabase>.value(value: database),
        RepositoryProvider<DriftHydratedStorage>.value(value: hydratedStorage),
        RepositoryProvider<FetchHistoryRepository>.value(
          value: fetchHistoryRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<LayoutCatalogBloc>.value(value: layoutCatalogBloc),
          BlocProvider<FetchRequestBloc>.value(value: fetchRequestBloc),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: const Locale('en', 'US'),
          supportedLocales: const <Locale>[Locale('en', 'US')],
          routerConfig: buildAppRouter(
            hydratedStorage: hydratedStorage,
            fetchHistoryRepository: fetchHistoryRepository,
          ),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
