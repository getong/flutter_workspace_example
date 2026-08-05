import 'package:flutter/foundation.dart';

enum WeatherCondition { sunny, cloudy, rainy, windy }

@immutable
final class Weather {
  const Weather({
    required this.cityName,
    required this.temperatureCelsius,
    required this.condition,
    required this.humidityPercent,
    required this.windSpeedKph,
  });

  final String cityName;
  final double temperatureCelsius;
  final WeatherCondition condition;
  final int humidityPercent;
  final double windSpeedKph;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Weather &&
            cityName == other.cityName &&
            temperatureCelsius == other.temperatureCelsius &&
            condition == other.condition &&
            humidityPercent == other.humidityPercent &&
            windSpeedKph == other.windSpeedKph;
  }

  @override
  int get hashCode => Object.hash(
    cityName,
    temperatureCelsius,
    condition,
    humidityPercent,
    windSpeedKph,
  );
}
