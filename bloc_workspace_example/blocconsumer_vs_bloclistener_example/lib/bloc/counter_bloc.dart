import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CounterEvent {}

class IncrementCounter extends CounterEvent {}

class DecrementCounter extends CounterEvent {}

class ResetCounter extends CounterEvent {}

// States
class CounterState {
  final int count;
  final String message;

  CounterState({required this.count, this.message = ''});

  CounterState copyWith({int? count, String? message}) {
    return CounterState(
      count: count ?? this.count,
      message: message ?? this.message,
    );
  }
}

// Bloc
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(count: 0)) {
    on<IncrementCounter>((event, emit) {
      final newCount = state.count + 1;
      String message = '';

      if (newCount % 5 == 0) {
        message = 'Multiple of 5 reached!';
      } else if (newCount > 10) {
        message = 'Counter is getting high!';
      }

      emit(state.copyWith(count: newCount, message: message));
    });

    on<DecrementCounter>((event, emit) {
      final newCount = state.count - 1;
      String message = '';

      if (newCount < 0) {
        message = 'Counter went negative!';
      }

      emit(state.copyWith(count: newCount, message: message));
    });

    on<ResetCounter>((event, emit) {
      emit(CounterState(count: 0, message: 'Counter reset!'));
    });
  }
}
