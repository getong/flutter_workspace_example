import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../events/counter_events.dart';
import '../state/counter_state.dart';

class DroppableCounterBloc extends Bloc<CounterEvent, CounterState> {
  DroppableCounterBloc()
      : super(CounterState(count: 0, lastUpdated: DateTime.now())) {
    // Using droppable transformer - new events are ignored while processing
    on<CounterIncremented>(_onIncrement, transformer: droppable());
    on<CounterDecremented>(_onDecrement, transformer: droppable());
    on<CounterMultiplied>(_onMultiply, transformer: droppable());
    on<CounterBatchIncrement>(_onBatchIncrement, transformer: droppable());
    on<CounterReset>(_onReset);
  }

  Future<void> _onIncrement(
      CounterIncremented event, Emitter<CounterState> emit) async {
    final timestamp = DateTime.now();
    emit(state.copyWith(
      isLoading: true,
      operations: [
        ...state.operations,
        'Processing +1 at ${timestamp.millisecondsSinceEpoch}'
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
        'Processing -1 at ${timestamp.millisecondsSinceEpoch}'
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
        'Processing *${event.multiplier} at ${timestamp.millisecondsSinceEpoch}'
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
        'Processing batch +${event.amount} at ${timestamp.millisecondsSinceEpoch}'
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
