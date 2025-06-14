import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class PageCounterEvent {}

class PageCounterIncrement extends PageCounterEvent {}

class PageCounterDecrement extends PageCounterEvent {}

class PageCounterReset extends PageCounterEvent {}

// State
class PageCounterState {
  final int count;
  const PageCounterState(this.count);
}

// BLoC
class PageCounterBloc extends Bloc<PageCounterEvent, PageCounterState> {
  PageCounterBloc() : super(const PageCounterState(0)) {
    on<PageCounterIncrement>((event, emit) {
      emit(PageCounterState(state.count + 1));
    });

    on<PageCounterDecrement>((event, emit) {
      emit(PageCounterState(state.count - 1));
    });

    on<PageCounterReset>((event, emit) {
      emit(const PageCounterState(0));
    });
  }
}
