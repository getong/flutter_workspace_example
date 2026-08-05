import 'package:auto_route/auto_route.dart';
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/data/datasources/in_memory_weather_data_source.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/data/repositories/in_memory_weather_repository.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/entities/weather.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/domain/repositories/weather_repository.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/presentation/bloc/weather_bloc.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/presentation/bloc/weather_event.dart';
import 'package:widget_layout_example2/features/bloc_signals_flutter/presentation/bloc/weather_state.dart';

@RoutePage(name: RouteName.blocSignalsFlutter)
class BlocSignalsFlutterPage extends StatelessWidget {
  const BlocSignalsFlutterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BlocSignalsFlutterDemo(
      repository: InMemoryWeatherRepository(
        dataSource: InMemoryWeatherDataSource(),
      ),
    );
  }
}

class BlocSignalsFlutterDemo extends StatelessWidget {
  const BlocSignalsFlutterDemo({required this.repository, super.key});

  final WeatherRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocSignalProvider<WeatherBloc>(
      create: (_) => WeatherBloc(repository: repository),
      child: const _WeatherView(),
    );
  }
}

class _WeatherView extends StatefulWidget {
  const _WeatherView();

  @override
  State<_WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<_WeatherView> {
  static const double _pagePadding = 24;
  static const double _sectionSpacing = 16;
  static const double _itemSpacing = 12;
  static const double _compactSpacing = 8;
  static const double _maxContentWidth = 760;
  static const double _compactLayoutWidth = 560;

  final TextEditingController _cityController = TextEditingController(
    text: 'Tokyo',
  );

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _requestWeather([String? city]) {
    final String query = city ?? _cityController.text;
    if (city != null) {
      _cityController.text = city;
    }
    context.read<WeatherBloc>().add(WeatherRequested(query));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'bloc_signals_flutter',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: ListView(
              padding: const EdgeInsets.all(_pagePadding),
              children: <Widget>[
                Text(
                  'Weather snapshots',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: _compactSpacing),
                Text(
                  'Search the local catalog through a BlocSignal-backed clean architecture flow.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: _sectionSpacing),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(_sectionSpacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints box) {
                            final Widget cityField = TextField(
                              key: const Key('blocSignals.cityField'),
                              controller: _cityController,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (_) => _requestWeather(),
                              decoration: const InputDecoration(
                                labelText: 'City',
                                hintText: 'Tokyo, London, Shanghai, or Sydney',
                                prefixIcon: Icon(Icons.location_city_outlined),
                                border: OutlineInputBorder(),
                              ),
                            );
                            final Widget searchButton =
                                BlocSignalSelector<
                                  WeatherBloc,
                                  WeatherState,
                                  bool
                                >(
                                  selector: (WeatherState state) =>
                                      state.isLoading,
                                  builder:
                                      (BuildContext context, bool isLoading) {
                                        return FilledButton.icon(
                                          key: const Key(
                                            'blocSignals.searchButton',
                                          ),
                                          onPressed: isLoading
                                              ? null
                                              : _requestWeather,
                                          icon: isLoading
                                              ? const SizedBox.square(
                                                  dimension: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : const Icon(Icons.search),
                                          label: Text(
                                            isLoading ? 'Loading' : 'Search',
                                          ),
                                        );
                                      },
                                );

                            if (box.maxWidth < _compactLayoutWidth) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  cityField,
                                  const SizedBox(height: _itemSpacing),
                                  searchButton,
                                ],
                              );
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(child: cityField),
                                const SizedBox(width: _itemSpacing),
                                searchButton,
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: _itemSpacing),
                        Wrap(
                          spacing: _compactSpacing,
                          runSpacing: _compactSpacing,
                          children: <Widget>[
                            for (final String city in const <String>[
                              'Tokyo',
                              'London',
                              'Shanghai',
                              'Sydney',
                            ])
                              ActionChip(
                                avatar: const Icon(
                                  Icons.near_me_outlined,
                                  size: 18,
                                ),
                                label: Text(city),
                                onPressed: () => _requestWeather(city),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: _sectionSpacing),
                BlocSignalListener<WeatherBloc, WeatherState>(
                  listenWhen: (WeatherState previous, WeatherState current) =>
                      current is WeatherFailure,
                  listener: (BuildContext context, WeatherState state) {
                    final WeatherFailure failure = state as WeatherFailure;
                    final ScaffoldMessengerState messenger =
                        ScaffoldMessenger.of(context);
                    messenger
                      ..clearSnackBars()
                      ..showSnackBar(SnackBar(content: Text(failure.message)));
                  },
                  child: BlocSignalBuilder<WeatherBloc, WeatherState>(
                    builder: (BuildContext context, WeatherState state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: _buildWeatherPanel(context, state),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherPanel(BuildContext context, WeatherState state) {
    return switch (state) {
      WeatherInitial() => const _WeatherStatePanel(
        key: ValueKey<String>('initial'),
        icon: Icons.travel_explore_outlined,
        title: 'Choose a city',
        message: 'A saved weather snapshot will appear here.',
      ),
      WeatherLoading(:final city) => _WeatherStatePanel(
        key: const ValueKey<String>('loading'),
        icon: Icons.cloud_sync_outlined,
        title: 'Loading $city',
        message: 'Reading the local weather catalog.',
        showProgress: true,
      ),
      WeatherFailure(:final message) => _WeatherStatePanel(
        key: const ValueKey<String>('failure'),
        icon: Icons.cloud_off_outlined,
        title: 'No snapshot found',
        message: message,
      ),
      WeatherSuccess(:final weather) => _WeatherDetails(
        key: const ValueKey<String>('success'),
        weather: weather,
      ),
    };
  }
}

class _WeatherStatePanel extends StatelessWidget {
  const _WeatherStatePanel({
    required this.icon,
    required this.title,
    required this.message,
    this.showProgress = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 260),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, size: 56, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (showProgress) ...<Widget>[
                  const SizedBox(height: 20),
                  const SizedBox(width: 160, child: LinearProgressIndicator()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeatherDetails extends StatelessWidget {
  const _WeatherDetails({required this.weather, super.key});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final (IconData, String) condition = switch (weather.condition) {
      WeatherCondition.sunny => (Icons.wb_sunny_outlined, 'Sunny'),
      WeatherCondition.cloudy => (Icons.cloud_outlined, 'Cloudy'),
      WeatherCondition.rainy => (Icons.water_drop_outlined, 'Rainy'),
      WeatherCondition.windy => (Icons.air_outlined, 'Windy'),
    };

    return Card(
      key: const Key('blocSignals.weatherResult'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Widget identity = Row(
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          condition.$1,
                          size: 40,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            weather.cityName,
                            key: const Key('blocSignals.resultCity'),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            condition.$2,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
                final Widget temperature = Text(
                  '${weather.temperatureCelsius.toStringAsFixed(1)}\u00B0C',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                );

                if (constraints.maxWidth < 460) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      identity,
                      const SizedBox(height: 16),
                      temperature,
                    ],
                  );
                }
                return Row(
                  children: <Widget>[
                    Expanded(child: identity),
                    const SizedBox(width: 16),
                    temperature,
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                _Metric(
                  icon: Icons.water_drop_outlined,
                  label: 'Humidity',
                  value: '${weather.humidityPercent}%',
                ),
                _Metric(
                  icon: Icons.air_outlined,
                  label: 'Wind',
                  value: '${weather.windSpeedKph.toStringAsFixed(1)} km/h',
                ),
                const _Metric(
                  icon: Icons.inventory_2_outlined,
                  label: 'Source',
                  value: 'Offline catalog',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: theme.colorScheme.secondary),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: theme.textTheme.labelMedium),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
