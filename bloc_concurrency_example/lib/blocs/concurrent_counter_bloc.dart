import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../events/counter_events.dart';
import '../state/counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(count: 0, lastUpdated: DateTime.now())) {
    // Using concurrent transformer - all events are processed concurrently
    on<CounterIncremented>(_onIncrement, transformer: concurrent());
    on<CounterDecremented>(_onDecrement, transformer: concurrent());
    on<CounterMultiplied>(_onMultiply, transformer: concurrent());
    on<CounterBatchIncrement>(_onBatchIncrement, transformer: concurrent());
    on<CounterReset>(_onReset);
  }

  Future<void> _onIncrement(
      CounterIncremented event, Emitter<CounterState> emit) async {
    final timestamp = DateTime.now();
    emit(state.copyWith(
      isLoading: true,
      pendingOperations: state.pendingOperations + 1,
      operations: [
        ...state.operations,
        'Started +1 at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(
      count: state.count + 1,
      isLoading: state.pendingOperations <= 1,
      pendingOperations: state.pendingOperations - 1,
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
      pendingOperations: state.pendingOperations + 1,
      operations: [
        ...state.operations,
        'Started -1 at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(
      count: state.count - 1,
      isLoading: state.pendingOperations <= 1,
      pendingOperations: state.pendingOperations - 1,
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
      pendingOperations: state.pendingOperations + 1,
      operations: [
        ...state.operations,
        'Started *${event.multiplier} at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      count: state.count * event.multiplier,
      isLoading: state.pendingOperations <= 1,
      pendingOperations: state.pendingOperations - 1,
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
      pendingOperations: state.pendingOperations + 1,
      operations: [
        ...state.operations,
        'Started batch +${event.amount} at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    // Simulate batch processing
    for (int i = 0; i < event.amount; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      emit(state.copyWith(
        count: state.count + 1,
        operations: [
          ...state.operations,
          'Batch step ${i + 1}/${event.amount}'
        ],
      ));
    }

    emit(state.copyWith(
      isLoading: state.pendingOperations <= 1,
      pendingOperations: state.pendingOperations - 1,
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
