abstract interface class WeatherDataSource {
  Future<Map<String, Object>> fetchWeather(String city);
}

final class InMemoryWeatherDataSource implements WeatherDataSource {
  const InMemoryWeatherDataSource({
    this.responseDelay = const Duration(milliseconds: 350),
  });

  final Duration responseDelay;

  static const Map<String, Map<String, Object>> _weatherByCity =
      <String, Map<String, Object>>{
        'london': <String, Object>{
          'cityName': 'London',
          'temperatureCelsius': 12.0,
          'condition': 'rainy',
          'humidityPercent': 81,
          'windSpeedKph': 18.4,
        },
        'shanghai': <String, Object>{
          'cityName': 'Shanghai',
          'temperatureCelsius': 27.0,
          'condition': 'cloudy',
          'humidityPercent': 74,
          'windSpeedKph': 12.6,
        },
        'sydney': <String, Object>{
          'cityName': 'Sydney',
          'temperatureCelsius': 21.5,
          'condition': 'windy',
          'humidityPercent': 58,
          'windSpeedKph': 24.1,
        },
        'tokyo': <String, Object>{
          'cityName': 'Tokyo',
          'temperatureCelsius': 18.5,
          'condition': 'sunny',
          'humidityPercent': 64,
          'windSpeedKph': 9.8,
        },
      };

  @override
  Future<Map<String, Object>> fetchWeather(String city) async {
    if (responseDelay > Duration.zero) {
      await Future<void>.delayed(responseDelay);
    }

    final String normalizedCity = city.trim().toLowerCase();
    final Map<String, Object>? weather = _weatherByCity[normalizedCity];
    if (weather == null) {
      throw WeatherCityNotFoundException(city.trim());
    }
    return weather;
  }
}

final class WeatherCityNotFoundException implements Exception {
  const WeatherCityNotFoundException(this.city);

  final String city;
}
