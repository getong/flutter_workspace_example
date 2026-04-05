import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../events/counter_events.dart';
import '../state/counter_state.dart';

class RestartableCounterBloc extends Bloc<CounterEvent, CounterState> {
  RestartableCounterBloc()
      : super(CounterState(count: 0, lastUpdated: DateTime.now())) {
    // Using restartable transformer - new events cancel previous ones
    on<CounterIncremented>(_onIncrement, transformer: restartable());
    on<CounterDecremented>(_onDecrement, transformer: restartable());
    on<CounterMultiplied>(_onMultiply, transformer: restartable());
    on<CounterBatchIncrement>(_onBatchIncrement, transformer: restartable());
    on<CounterReset>(_onReset);
  }

  Future<void> _onIncrement(
      CounterIncremented event, Emitter<CounterState> emit) async {
    final timestamp = DateTime.now();
    emit(state.copyWith(
      isLoading: true,
      operations: [
        ...state.operations,
        'Restarting +1 at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      count: state.count + 1,
      isLoading: false,
      lastUpdated: DateTime.now(),
      operations: [
        ...state.operations,
        'Completed +1 at ${DateTime.now().millisecondsSinceEpoch}'
      ],
    ));
  }

  Future<void> _onDecrement(
      CounterDecremented event, Emitter<CounterState> emit) async {
    final timestamp = DateTime.now();
    emit(state.copyWith(
      isLoading: true,
      operations: [
        ...state.operations,
        'Restarting -1 at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      count: state.count - 1,
      isLoading: false,
      lastUpdated: DateTime.now(),
      operations: [
        ...state.operations,
        'Completed -1 at ${DateTime.now().millisecondsSinceEpoch}'
      ],
    ));
  }

  Future<void> _onMultiply(
      CounterMultiplied event, Emitter<CounterState> emit) async {
    final timestamp = DateTime.now();
    emit(state.copyWith(
      isLoading: true,
      operations: [
        ...state.operations,
        'Restarting *${event.multiplier} at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    await Future.delayed(const Duration(seconds: 3));

    emit(state.copyWith(
      count: state.count * event.multiplier,
      isLoading: false,
      lastUpdated: DateTime.now(),
      operations: [
        ...state.operations,
        'Completed *${event.multiplier} at ${DateTime.now().millisecondsSinceEpoch}'
      ],
    ));
  }

  Future<void> _onBatchIncrement(
      CounterBatchIncrement event, Emitter<CounterState> emit) async {
    final timestamp = DateTime.now();
    emit(state.copyWith(
      isLoading: true,
      operations: [
        ...state.operations,
        'Restarting batch +${event.amount} at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    await Future.delayed(const Duration(seconds: 4));

    emit(state.copyWith(
      count: state.count + event.amount,
      isLoading: false,
      lastUpdated: DateTime.now(),
      operations: [
        ...state.operations,
        'Completed batch +${event.amount} at ${DateTime.now().millisecondsSinceEpoch}'
      ],
    ));
  }

  Future<void> _onReset(CounterReset event, Emitter<CounterState> emit) async {
    emit(CounterState(
      count: 0,
      lastUpdated: DateTime.now(),
      operations: ['Reset at ${DateTime.now().millisecondsSinceEpoch}'],
    ));
  }
}
