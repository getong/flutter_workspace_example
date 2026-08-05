import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/entities/weather.dart';

final class WeatherModel {
  const WeatherModel({
    required this.cityName,
    required this.temperatureCelsius,
    required this.condition,
    required this.humidityPercent,
    required this.windSpeedKph,
  });

  factory WeatherModel.fromMap(Map<String, Object> map) {
    return WeatherModel(
      cityName: map['cityName']! as String,
      temperatureCelsius: (map['temperatureCelsius']! as num).toDouble(),
      condition: map['condition']! as String,
      humidityPercent: map['humidityPercent']! as int,
      windSpeedKph: (map['windSpeedKph']! as num).toDouble(),
    );
  }

  final String cityName;
  final double temperatureCelsius;
  final String condition;
  final int humidityPercent;
  final double windSpeedKph;

  Weather toEntity() {
    return Weather(
      cityName: cityName,
      temperatureCelsius: temperatureCelsius,
      condition: switch (condition) {
        'sunny' => WeatherCondition.sunny,
        'rainy' => WeatherCondition.rainy,
        'windy' => WeatherCondition.windy,
        _ => WeatherCondition.cloudy,
      },
      humidityPercent: humidityPercent,
      windSpeedKph: windSpeedKph,
    );
  }
}
