import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

/// Event being processed by [CounterBloc].
abstract class CounterEvent {}

/// Notifies bloc to increment state.
class CounterIncrementPressed extends CounterEvent {}

/// Notifies bloc to decrement state.
class CounterDecrementPressed extends CounterEvent {}

/// Event for setting counter to a specific value
class CounterSetValue extends CounterEvent {
  final int value;
  CounterSetValue(this.value);
}

/// Event for resetting counter
class CounterReset extends CounterEvent {}

/// Event for batch operations
class CounterBatchUpdate extends CounterEvent {
  final List<CounterEvent> events;
  CounterBatchUpdate(this.events);
}

/// {@template counter_bloc}
/// A simple [Bloc] that manages an `int` as its state.
/// Demonstrates Sink usage for event streaming.
/// {@endtemplate}
class CounterBloc extends Bloc<CounterEvent, int> {
  /// {@macro counter_bloc}
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
    on<CounterDecrementPressed>((event, emit) => emit(state - 1));
    on<CounterSetValue>((event, emit) => emit(event.value));
    on<CounterReset>((event, emit) => emit(0));
    on<CounterBatchUpdate>(_onBatchUpdate);

    // Set up sink stream subscription
    _sinkStreamSubscription = _sinkController.stream.listen((event) {
      add(event); // Forward sink events to the bloc
    });
  }

  // StreamController for sink functionality
  final StreamController<CounterEvent> _sinkController =
      StreamController<CounterEvent>();
  late final StreamSubscription<CounterEvent> _sinkStreamSubscription;

  /// Demonstrates Sink usage - access to event sink
  Sink<CounterEvent> get eventSink => _sinkController.sink;

  /// Stream of events for external monitoring
  Stream<CounterEvent> get eventStream => _sinkController.stream;

  /// Batch update handler using Sink
  void _onBatchUpdate(CounterBatchUpdate event, Emitter<int> emit) {
    int newValue = state;
    for (final batchEvent in event.events) {
      if (batchEvent is CounterIncrementPressed) {
        newValue++;
      } else if (batchEvent is CounterDecrementPressed) {
        newValue--;
      } else if (batchEvent is CounterSetValue) {
        newValue = batchEvent.value;
      } else if (batchEvent is CounterReset) {
        newValue = 0;
      }
    }
    emit(newValue);
  }

  /// Demonstrate Sink usage - add multiple events using sink
  void addEventsBatch(List<CounterEvent> events) {
    // Using sink directly for batch operations
    for (final event in events) {
      eventSink.add(event);
    }
  }

  /// Auto-increment using sink with timer
  Timer? _autoIncrementTimer;

  void startAutoIncrement() {
    _autoIncrementTimer?.cancel();
    _autoIncrementTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => eventSink.add(CounterIncrementPressed()),
    );
  }

  void stopAutoIncrement() {
    _autoIncrementTimer?.cancel();
    _autoIncrementTimer = null;
  }

  @override
  Future<void> close() {
    _autoIncrementTimer?.cancel();
    _sinkStreamSubscription.cancel();
    _sinkController.close();
    return super.close();
  }
}
