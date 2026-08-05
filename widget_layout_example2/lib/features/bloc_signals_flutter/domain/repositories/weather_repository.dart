import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/entities/weather.dart';

abstract interface class WeatherRepository {
  Future<Weather> getWeather(String city);
}

final class WeatherLookupException implements Exception {
  const WeatherLookupException(this.message);

  final String message;

  @override
  String toString() => message;
}
