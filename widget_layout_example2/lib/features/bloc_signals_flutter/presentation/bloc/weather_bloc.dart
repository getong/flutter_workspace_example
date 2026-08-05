import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/entities/weather.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/repositories/weather_repository.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/presentation/bloc/weather_event.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/presentation/bloc/weather_state.dart';

final class WeatherBloc extends BlocSignal<WeatherEvent, WeatherState> {
  WeatherBloc({required WeatherRepository repository})
    : _repository = repository,
      super(initialState: const WeatherInitial()) {
    on<WeatherRequested>(_onWeatherRequested, transformer: restartable());
  }

  final WeatherRepository _repository;

  Future<void> _onWeatherRequested(
    WeatherRequested event,
    void Function(WeatherState state) emit,
  ) async {
    final String city = event.city.trim();
    if (city.isEmpty) {
      emit(const WeatherFailure('Enter a city before searching.'));
      return;
    }

    emit(WeatherLoading(city));
    try {
      final Weather weather = await _repository.getWeather(city);
      emit(WeatherSuccess(weather));
    } on WeatherLookupException catch (error) {
      emit(WeatherFailure(error.message));
    } on Object {
      emit(const WeatherFailure('Weather is temporarily unavailable.'));
    }
  }
}
