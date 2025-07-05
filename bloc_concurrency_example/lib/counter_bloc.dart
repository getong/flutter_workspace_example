import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

// Export all counter-related files
export 'events/counter_events.dart';
export 'state/counter_state.dart';
export 'blocs/concurrent_counter_bloc.dart';
export 'blocs/sequential_counter_bloc.dart';
export 'blocs/droppable_counter_bloc.dart';
export 'blocs/restartable_counter_bloc.dart';

// Events
abstract class CounterEvent {}

class CounterIncremented extends CounterEvent {}

class CounterDecremented extends CounterEvent {}

class CounterReset extends CounterEvent {}

class CounterMultiplied extends CounterEvent {
  final int multiplier;
  CounterMultiplied(this.multiplier);
}

class CounterBatchIncrement extends CounterEvent {
  final int amount;
  CounterBatchIncrement(this.amount);
}

// Enhanced State
class CounterState {
  final int count;
  final bool isLoading;
  final List<String> operations;
  final DateTime lastUpdated;
  final int pendingOperations;
  final String? error;

  const CounterState({
    required this.count,
    this.isLoading = false,
    this.operations = const [],
    required this.lastUpdated,
    this.pendingOperations = 0,
    this.error,
  });

  CounterState copyWith({
    int? count,
    bool? isLoading,
    List<String>? operations,
    DateTime? lastUpdated,
    int? pendingOperations,
    String? error,
  }) {
    return CounterState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      operations: operations ?? this.operations,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      pendingOperations: pendingOperations ?? this.pendingOperations,
      error: error ?? this.error,
    );
  }
}

// Bloc with concurrent transformer
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

// Bloc with sequential transformer
class SequentialCounterBloc extends Bloc<CounterEvent, CounterState> {
  SequentialCounterBloc()
      : super(CounterState(count: 0, lastUpdated: DateTime.now())) {
    // Using sequential transformer - events are processed one at a time
    on<CounterIncremented>(_onIncrement, transformer: sequential());
    on<CounterDecremented>(_onDecrement, transformer: sequential());
    on<CounterMultiplied>(_onMultiply, transformer: sequential());
    on<CounterBatchIncrement>(_onBatchIncrement, transformer: sequential());
    on<CounterReset>(_onReset);
  }

  Future<void> _onIncrement(
      CounterIncremented event, Emitter<CounterState> emit) async {
    final timestamp = DateTime.now();
    emit(state.copyWith(
      isLoading: true,
      operations: [
        ...state.operations,
        'Queued +1 at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    await Future.delayed(const Duration(seconds: 1));

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
        'Queued -1 at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    await Future.delayed(const Duration(seconds: 1));

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
        'Queued *${event.multiplier} at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    await Future.delayed(const Duration(seconds: 2));

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
        'Queued batch +${event.amount} at ${timestamp.millisecondsSinceEpoch}'
      ],
    ));

    await Future.delayed(Duration(milliseconds: 500 * event.amount));

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

// Bloc with droppable transformer
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

// New Bloc with restartable transformer
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
