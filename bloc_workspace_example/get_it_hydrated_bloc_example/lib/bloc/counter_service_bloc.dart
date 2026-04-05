import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../services/counter_service.dart';

// Events
abstract class CounterServiceEvent {}

class CounterServiceIncrement extends CounterServiceEvent {}

class CounterServiceDecrement extends CounterServiceEvent {}

class CounterServiceReset extends CounterServiceEvent {}

// State
class CounterServiceState {
  final int count;
  const CounterServiceState(this.count);

  Map<String, dynamic> toJson() => {'count': count};
  static CounterServiceState fromJson(Map<String, dynamic> json) =>
      CounterServiceState(json['count'] as int);
}

// BLoC
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
      _counterService.count = state.count;
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
