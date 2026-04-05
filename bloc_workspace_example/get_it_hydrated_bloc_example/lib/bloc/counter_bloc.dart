import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// Events
abstract class CounterEvent {}

class CounterIncrement extends CounterEvent {}

class CounterDecrement extends CounterEvent {}

class CounterReset extends CounterEvent {}

// States
class CounterState {
  final int count;

  const CounterState(this.count);

  // Add serialization methods
  Map<String, dynamic> toJson() => {'count': count};

  static CounterState fromJson(Map<String, dynamic> json) {
    return CounterState(json['count'] as int);
  }
}

// BLoC
class CounterBloc extends HydratedBloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<CounterIncrement>((event, emit) {
      emit(CounterState(state.count + 1));
    });

    on<CounterDecrement>((event, emit) {
      emit(CounterState(state.count - 1));
    });

    on<CounterReset>((event, emit) {
      emit(const CounterState(0));
    });
  }

  @override
  CounterState? fromJson(Map<String, dynamic> json) {
    try {
      return CounterState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CounterState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
