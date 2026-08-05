import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/entities/weather.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/repositories/weather_repository.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/presentation/bloc/weather_bloc.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/presentation/bloc/weather_event.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/presentation/bloc/weather_state.dart';

void main() {
  group('WeatherBloc', () {
    late _ControllableWeatherRepository repository;
    late WeatherBloc bloc;

    setUp(() {
      repository = _ControllableWeatherRepository();
      bloc = WeatherBloc(repository: repository);
    });

    tearDown(() async {
      await bloc.close();
    });

    test('starts in WeatherInitial', () {
      expect(bloc.stateValue, isA<WeatherInitial>());
    });

    test('emits loading then success for a weather request', () async {
      bloc.add(const WeatherRequested('Tokyo'));

      expect(bloc.stateValue, const WeatherLoading('Tokyo'));

      repository.complete(
        const Weather(
          cityName: 'Tokyo',
          temperatureCelsius: 18.5,
          condition: WeatherCondition.sunny,
          humidityPercent: 64,
          windSpeedKph: 9.8,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        bloc.stateValue,
        const WeatherSuccess(
          Weather(
            cityName: 'Tokyo',
            temperatureCelsius: 18.5,
            condition: WeatherCondition.sunny,
            humidityPercent: 64,
            windSpeedKph: 9.8,
          ),
        ),
      );
    });

    test('emits a user-facing failure for an empty query', () {
      bloc.add(const WeatherRequested('  '));

      expect(
        bloc.stateValue,
        const WeatherFailure('Enter a city before searching.'),
      );
    });

    test('maps repository failures to WeatherFailure', () async {
      bloc.add(const WeatherRequested('Atlantis'));
      repository.fail(
        const WeatherLookupException('No snapshot for Atlantis.'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        bloc.stateValue,
        const WeatherFailure('No snapshot for Atlantis.'),
      );
    });
  });
}

final class _ControllableWeatherRepository implements WeatherRepository {
  final Completer<Weather> _completer = Completer<Weather>();

  @override
  Future<Weather> getWeather(String city) => _completer.future;

  void complete(Weather weather) => _completer.complete(weather);

  void fail(Object error) => _completer.completeError(error);
}
