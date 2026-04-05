import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/counter.dart';
import '../repositories/counter_repository.dart';

// Events
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class CounterLoadRequested extends CounterEvent {}

class CounterIncrementRequested extends CounterEvent {}

class CounterDecrementRequested extends CounterEvent {}

class CounterResetRequested extends CounterEvent {}

// States
abstract class CounterState extends Equatable {
  const CounterState();

  @override
  List<Object> get props => [];
}

class CounterInitial extends CounterState {}

class CounterLoading extends CounterState {}

class CounterLoaded extends CounterState {
  final Counter counter;

  const CounterLoaded({required this.counter});

  @override
  List<Object> get props => [counter];
}

class CounterError extends CounterState {
  final String message;

  const CounterError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final CounterRepository _repository;

  CounterBloc({required CounterRepository repository})
      : _repository = repository,
        super(CounterInitial()) {
    on<CounterLoadRequested>(_onLoadRequested);
    on<CounterIncrementRequested>(_onIncrementRequested);
    on<CounterDecrementRequested>(_onDecrementRequested);
    on<CounterResetRequested>(_onResetRequested);
  }

  Future<void> _onLoadRequested(
    CounterLoadRequested event,
    Emitter<CounterState> emit,
  ) async {
    emit(CounterLoading());
    try {
      final counter = await _repository.getCounter();
      emit(CounterLoaded(counter: counter));
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  Future<void> _onIncrementRequested(
    CounterIncrementRequested event,
    Emitter<CounterState> emit,
  ) async {
    emit(CounterLoading());
    try {
      final counter = await _repository.incrementCounter();
      emit(CounterLoaded(counter: counter));
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  Future<void> _onDecrementRequested(
    CounterDecrementRequested event,
    Emitter<CounterState> emit,
  ) async {
    emit(CounterLoading());
    try {
      final counter = await _repository.decrementCounter();
      emit(CounterLoaded(counter: counter));
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  Future<void> _onResetRequested(
    CounterResetRequested event,
    Emitter<CounterState> emit,
  ) async {
    emit(CounterLoading());
    try {
      await _repository.resetCounter();
      final counter = await _repository.getCounter();
      emit(CounterLoaded(counter: counter));
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }
}
