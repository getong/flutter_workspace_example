import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// Events
abstract class PageCounterEvent {}

class PageCounterIncrement extends PageCounterEvent {}

class PageCounterDecrement extends PageCounterEvent {}

class PageCounterReset extends PageCounterEvent {}

// State
class PageCounterState {
  final int count;
  const PageCounterState(this.count);

  // Add serialization methods
  Map<String, dynamic> toJson() => {'count': count};
  static PageCounterState fromJson(Map<String, dynamic> json) =>
      PageCounterState(json['count'] as int);
}

// BLoC
class PageCounterBloc extends HydratedBloc<PageCounterEvent, PageCounterState> {
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

  @override
  PageCounterState? fromJson(Map<String, dynamic> json) {
    try {
      return PageCounterState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(PageCounterState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
