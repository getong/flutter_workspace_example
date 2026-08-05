import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/entities/weather.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/repositories/weather_repository.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/presentation/pages/bloc_signals_flutter_page.dart';

void main() {
  testWidgets('searches through the injected repository and renders weather', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 740));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeWeatherRepository repository = _FakeWeatherRepository();
    await tester.pumpWidget(
      MaterialApp(home: BlocSignalsFlutterDemo(repository: repository)),
    );

    await tester.enterText(
      find.byKey(const Key('blocSignals.cityField')),
      'Shanghai',
    );
    await tester.tap(find.byKey(const Key('blocSignals.searchButton')));
    await tester.pumpAndSettle();

    expect(repository.queries, <String>['Shanghai']);
    expect(find.byKey(const Key('blocSignals.weatherResult')), findsOneWidget);
    final Text city = tester.widget<Text>(
      find.byKey(const Key('blocSignals.resultCity')),
    );
    expect(city.data, 'Shanghai');
    expect(find.text('27.0\u00B0C'), findsOneWidget);
  });
}

final class _FakeWeatherRepository implements WeatherRepository {
  final List<String> queries = <String>[];

  @override
  Future<Weather> getWeather(String city) async {
    queries.add(city);
    return const Weather(
      cityName: 'Shanghai',
      temperatureCelsius: 27,
      condition: WeatherCondition.cloudy,
      humidityPercent: 74,
      windSpeedKph: 12.6,
    );
  }
}
