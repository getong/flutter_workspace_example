import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../bloc/counter_bloc.dart';
import '../pages/counter_page.dart';
import '../pages/hello_world_page.dart';
import '../pages/di_page.dart';
import '../enums/router_enum.dart';

final GetIt getIt = GetIt.instance;

class CounterService {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
  }

  void decrement() {
    _count--;
  }

  void reset() {
    _count = 0;
  }
}

// Events for CounterService BLoC
abstract class CounterServiceEvent {}

class CounterServiceIncrement extends CounterServiceEvent {}

class CounterServiceDecrement extends CounterServiceEvent {}

class CounterServiceReset extends CounterServiceEvent {}

// State for CounterService BLoC
class CounterServiceState {
  final int count;
  const CounterServiceState(this.count);

  // Add serialization methods
  Map<String, dynamic> toJson() => {'count': count};

  static CounterServiceState fromJson(Map<String, dynamic> json) {
    return CounterServiceState(json['count'] as int);
  }
}

// BLoC for CounterService
class CounterServiceBloc
    extends HydratedBloc<CounterServiceEvent, CounterServiceState> {
  final CounterService _counterService;

  CounterServiceBloc(this._counterService)
    : super(CounterServiceState(_counterService.count)) {
    on<CounterServiceIncrement>((event, emit) {
      _counterService.increment();
      emit(CounterServiceState(_counterService.count));
    });

    on<CounterServiceDecrement>((event, emit) {
      _counterService.decrement();
      emit(CounterServiceState(_counterService.count));
    });

    on<CounterServiceReset>((event, emit) {
      _counterService.reset();
      emit(CounterServiceState(_counterService.count));
    });
  }

  @override
  CounterServiceState? fromJson(Map<String, dynamic> json) {
    try {
      final state = CounterServiceState.fromJson(json);
      // Sync the counter service with the persisted state
      _counterService._count = state.count;
      return state;
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CounterServiceState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}

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
    getIt.registerSingleton<GoRouter>(_createRouter());
  }

  static GoRouter _createRouter() {
    return GoRouter(
      initialLocation: RouterEnum.initialLocation.routeName,
      routes: [
        GoRoute(
          path: RouterEnum.initialLocation.routeName,
          builder: (context, state) => const DIPage(),
        ),
        GoRoute(
          path: RouterEnum.counterView.routeName,
          builder: (context, state) => const CounterPage(),
        ),
        GoRoute(
          path: RouterEnum.helloWorldView.routeName,
          builder: (context, state) => const HelloWorldPage(),
        ),
      ],
    );
  }
}
