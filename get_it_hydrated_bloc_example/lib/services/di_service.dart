import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_service_bloc.dart';
import 'counter_service.dart';
import 'router_service.dart';

final GetIt getIt = GetIt.instance;

class DIService {
  static Future<void> init() async {
    // Register services as singletons
    final counterService = CounterService();
    getIt.registerSingleton<CounterService>(counterService);
    getIt.registerSingleton<CounterServiceBloc>(
      CounterServiceBloc(counterService),
    );
    getIt.registerSingleton<CounterBloc>(CounterBloc());

    // Register go_router
    getIt.registerSingleton<GoRouter>(RouterService.createRouter());
  }
}
