import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/data/datasources/in_memory_weather_data_source.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/data/repositories/in_memory_weather_repository.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/entities/weather.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/repositories/weather_repository.dart';

void main() {
  const WeatherRepository repository = InMemoryWeatherRepository(
    dataSource: InMemoryWeatherDataSource(responseDelay: Duration.zero),
  );

  test('maps a data source record to the weather entity', () async {
    final Weather weather = await repository.getWeather('  Tokyo  ');

    expect(weather.cityName, 'Tokyo');
    expect(weather.temperatureCelsius, 18.5);
    expect(weather.condition, WeatherCondition.sunny);
    expect(weather.humidityPercent, 64);
  });

  test('maps a missing city to a domain exception', () async {
    await expectLater(
      repository.getWeather('Atlantis'),
      throwsA(
        isA<WeatherLookupException>().having(
          (WeatherLookupException error) => error.message,
          'message',
          contains('Atlantis'),
        ),
      ),
    );
  });
}
