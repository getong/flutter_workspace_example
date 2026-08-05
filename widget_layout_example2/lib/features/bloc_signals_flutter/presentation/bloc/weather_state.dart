import 'package:flutter/foundation.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/entities/weather.dart';

@immutable
sealed class WeatherState {
  const WeatherState();

  bool get isLoading => this is WeatherLoading;
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

final class WeatherLoading extends WeatherState {
  const WeatherLoading(this.city);

  final String city;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WeatherLoading && city == other.city;
  }

  @override
  int get hashCode => city.hashCode;
}

final class WeatherSuccess extends WeatherState {
  const WeatherSuccess(this.weather);

  final Weather weather;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WeatherSuccess && weather == other.weather;
  }

  @override
  int get hashCode => weather.hashCode;
}

final class WeatherFailure extends WeatherState {
  const WeatherFailure(this.message);

  final String message;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WeatherFailure && message == other.message;
  }

  @override
  int get hashCode => message.hashCode;
}
