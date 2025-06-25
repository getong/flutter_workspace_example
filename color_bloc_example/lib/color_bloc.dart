import 'package:flutter_bloc/flutter_bloc.dart';
import 'color_event.dart';
import 'color_state.dart';

class ColorBloc extends Bloc<ColorEvent, ColorState> {
  ColorBloc() : super(const RedColorState()) {
    on<ChangeToRedEvent>((event, emit) {
      emit(const RedColorState());
    });

    on<ChangeToBlueEvent>((event, emit) {
      emit(const BlueColorState());
    });

    on<ChangeToGreenEvent>((event, emit) {
      emit(const GreenColorState());
    });

    on<ChangeToOrangeEvent>((event, emit) {
      emit(const OrangeColorState());
    });
  }
}
