import 'package:bloc_drift_example/app/app_router.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocDriftExampleApp extends StatefulWidget {
  const BlocDriftExampleApp({super.key, required this.repository});

  final OfflineOrdersRepository repository;

  @override
  State<BlocDriftExampleApp> createState() => _BlocDriftExampleAppState();
}

class _BlocDriftExampleAppState extends State<BlocDriftExampleApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(repository: widget.repository);
  }

  @override
  void dispose() {
    widget.repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: widget.repository,
      child: MaterialApp.router(
        title: 'Bloc + Drift Offline Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
          scaffoldBackgroundColor: const Color(0xFFF3F7F6),
          useMaterial3: true,
        ),
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
