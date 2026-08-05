import 'package:widget_layout_example2/features/bloc_signals_flutter/data/datasources/in_memory_weather_data_source.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/data/models/weather_model.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/entities/weather.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/repositories/weather_repository.dart';

final class InMemoryWeatherRepository implements WeatherRepository {
  const InMemoryWeatherRepository({required WeatherDataSource dataSource})
    : _dataSource = dataSource;

  final WeatherDataSource _dataSource;

  @override
  Future<Weather> getWeather(String city) async {
    try {
      final Map<String, Object> response = await _dataSource.fetchWeather(city);
      return WeatherModel.fromMap(response).toEntity();
    } on WeatherCityNotFoundException catch (error) {
      throw WeatherLookupException(
        'No offline weather snapshot is available for ${error.city}.',
      );
    } on Object {
      throw const WeatherLookupException(
        'The weather snapshot could not be loaded.',
      );
    }
  }
}
