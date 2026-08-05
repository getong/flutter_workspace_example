import 'package:flutter/foundation.dart';

@immutable
sealed class WeatherEvent {
  const WeatherEvent();
}

final class WeatherRequested extends WeatherEvent {
  const WeatherRequested(this.city);

  final String city;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WeatherRequested && city == other.city;
  }

  @override
  int get hashCode => city.hashCode;
}
