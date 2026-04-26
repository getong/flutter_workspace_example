import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/advice.dart';
import '../../domain/usecases/get_random_advice_usecase.dart';

abstract class AdviceEvent {
  const AdviceEvent();
}

class FetchAdviceEvent extends AdviceEvent {
  const FetchAdviceEvent();
}

abstract class AdviceState {
  const AdviceState();
}

class AdviceInitial extends AdviceState {
  const AdviceInitial();
}

class AdviceLoading extends AdviceState {
  const AdviceLoading();
}

class AdviceLoaded extends AdviceState {
  final Advice advice;

  const AdviceLoaded(this.advice);
}

class AdviceRefreshing extends AdviceState {
  final Advice advice;

  const AdviceRefreshing(this.advice);
}

class AdviceError extends AdviceState {
  final String message;

  const AdviceError(this.message);
}

class AdviceBloc extends Bloc<AdviceEvent, AdviceState> {
  final GetRandomAdviceUseCase _getRandomAdviceUseCase;

  AdviceBloc(this._getRandomAdviceUseCase) : super(const AdviceInitial()) {
    on<FetchAdviceEvent>(_onFetchAdvice);
  }

  Future<void> _onFetchAdvice(
    FetchAdviceEvent event,
    Emitter<AdviceState> emit,
  ) async {
    final previousAdvice = switch (state) {
      AdviceLoaded(:final advice) => advice,
      AdviceRefreshing(:final advice) => advice,
      _ => null,
    };

    if (previousAdvice != null) {
      emit(AdviceRefreshing(previousAdvice));
    } else {
      emit(const AdviceLoading());
    }

    try {
      final advice = await _getRandomAdviceUseCase();
      emit(AdviceLoaded(advice));
    } catch (error) {
      emit(AdviceError(error.toString().replaceFirst('Exception: ', '')));
    }
  }
}
