import 'dart:async';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.sensorsPlus)
class SensorsPlusPage extends StatefulWidget {
  const SensorsPlusPage({super.key});

  @override
  State<SensorsPlusPage> createState() => _SensorsPlusPageState();
}

class _SensorsPlusPageState extends State<SensorsPlusPage> {
  Duration _samplingPeriod = SensorInterval.normalInterval;
  bool _listening = true;

  AccelerometerEvent? _accelerometer;
  UserAccelerometerEvent? _userAccelerometer;
  GyroscopeEvent? _gyroscope;
  MagnetometerEvent? _magnetometer;
  BarometerEvent? _barometer;

  String? _accelerometerError;
  String? _gyroscopeError;
  String? _magnetometerError;
  String? _barometerError;

  final List<StreamSubscription<dynamic>> _subscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _restartSubscriptions();
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    super.dispose();
  }

  void _cancelSubscriptions() {
    for (final StreamSubscription<dynamic> subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  void _restartSubscriptions() {
    _cancelSubscriptions();
    if (!_listening) {
      return;
    }

    _subscriptions.add(
      accelerometerEventStream(samplingPeriod: _samplingPeriod).listen(
        (AccelerometerEvent event) {
          if (!mounted) {
            return;
          }
          setState(() {
            _accelerometer = event;
            _accelerometerError = null;
          });
        },
        onError: (Object error) {
          if (!mounted) {
            return;
          }
          setState(() {
            _accelerometerError = error.toString();
          });
        },
      ),
    );

    _subscriptions.add(
      userAccelerometerEventStream(samplingPeriod: _samplingPeriod).listen((
        UserAccelerometerEvent event,
      ) {
        if (!mounted) {
          return;
        }
        setState(() {
          _userAccelerometer = event;
        });
      }),
    );

    _subscriptions.add(
      gyroscopeEventStream(samplingPeriod: _samplingPeriod).listen(
        (GyroscopeEvent event) {
          if (!mounted) {
            return;
          }
          setState(() {
            _gyroscope = event;
            _gyroscopeError = null;
          });
        },
        onError: (Object error) {
          if (!mounted) {
            return;
          }
          setState(() {
            _gyroscopeError = error.toString();
          });
        },
      ),
    );

    _subscriptions.add(
      magnetometerEventStream(samplingPeriod: _samplingPeriod).listen(
        (MagnetometerEvent event) {
          if (!mounted) {
            return;
          }
          setState(() {
            _magnetometer = event;
            _magnetometerError = null;
          });
        },
        onError: (Object error) {
          if (!mounted) {
            return;
          }
          setState(() {
            _magnetometerError = error.toString();
          });
        },
      ),
    );

    _subscriptions.add(
      barometerEventStream(samplingPeriod: _samplingPeriod).listen(
        (BarometerEvent event) {
          if (!mounted) {
            return;
          }
          setState(() {
            _barometer = event;
            _barometerError = null;
          });
        },
        onError: (Object error) {
          if (!mounted) {
            return;
          }
          setState(() {
            _barometerError = error.toString();
          });
        },
      ),
    );
  }

  double? get _accelMagnitude {
    final AccelerometerEvent? event = _accelerometer;
    if (event == null) {
      return null;
    }
    return math.sqrt(
      (event.x * event.x) + (event.y * event.y) + (event.z * event.z),
    );
  }

  String get _tiltHint {
    final AccelerometerEvent? event = _accelerometer;
    if (event == null) {
      return 'Awaiting accelerometer data';
    }
    final double absX = event.x.abs();
    final double absY = event.y.abs();

    if (absX > absY && event.x > 4) {
      return 'Tilted left';
    }
    if (absX > absY && event.x < -4) {
      return 'Tilted right';
    }
    if (absY > absX && event.y > 6) {
      return 'Portrait-ish';
    }
    if (absY > absX && event.y < -6) {
      return 'Upside down-ish';
    }
    return 'Mostly flat or neutral';
  }

  String _axis(double? value) {
    if (value == null) {
      return '?';
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? environmentError = () {
      final List<String> errors = <String>[
        if (_magnetometerError != null) 'Magnetometer: $_magnetometerError',
        if (_barometerError != null) 'Barometer: $_barometerError',
      ];
      if (errors.isEmpty) {
        return null;
      }
      return errors.join('\n');
    }();

    return Scaffold(
      appBar: AppBar(title: const Text('sensors_plus Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'sensors_plus exposes live motion and environment streams from the '
            'accelerometer, user accelerometer, gyroscope, magnetometer, and '
            'barometer.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This page demonstrates `accelerometerEventStream`, '
            '`userAccelerometerEventStream`, `gyroscopeEventStream`, '
            '`magnetometerEventStream`, `barometerEventStream`, and '
            '`SensorInterval`. Errors are handled explicitly because not every '
            'device has every sensor.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sampling and lifecycle',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Restart the subscriptions with a different sampling rate or pause the listeners entirely.',
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<Duration>(
                    segments: <ButtonSegment<Duration>>[
                      ButtonSegment<Duration>(
                        value: SensorInterval.gameInterval,
                        label: Text(
                          'Game\n${SensorInterval.gameInterval.inMilliseconds}ms',
                        ),
                      ),
                      ButtonSegment<Duration>(
                        value: SensorInterval.uiInterval,
                        label: Text(
                          'UI\n${SensorInterval.uiInterval.inMilliseconds}ms',
                        ),
                      ),
                      ButtonSegment<Duration>(
                        value: SensorInterval.normalInterval,
                        label: Text(
                          'Normal\n${SensorInterval.normalInterval.inMilliseconds}ms',
                        ),
                      ),
                    ],
                    selected: <Duration>{_samplingPeriod},
                    onSelectionChanged: (Set<Duration> selection) {
                      setState(() {
                        _samplingPeriod = selection.first;
                      });
                      _restartSubscriptions();
                    },
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _listening
                            ? null
                            : () {
                                setState(() => _listening = true);
                                _restartSubscriptions();
                              },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Listening'),
                      ),
                      OutlinedButton.icon(
                        onPressed: !_listening
                            ? null
                            : () {
                                setState(() => _listening = false);
                                _cancelSubscriptions();
                              },
                        icon: const Icon(Icons.pause),
                        label: const Text('Pause Streams'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _restartSubscriptions,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Restart'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SensorCard(
            title: 'Accelerometer',
            subtitle:
                'Raw acceleration includes gravity. This can help infer tilt or free-fall.',
            accent: const Color(0xFF2563EB),
            rows: <(String, String)>[
              ('x', _axis(_accelerometer?.x)),
              ('y', _axis(_accelerometer?.y)),
              ('z', _axis(_accelerometer?.z)),
              (
                'magnitude',
                _accelMagnitude == null
                    ? '?'
                    : _accelMagnitude!.toStringAsFixed(2),
              ),
              ('tilt', _tiltHint),
            ],
            error: _accelerometerError,
          ),
          const SizedBox(height: 16),
          _SensorCard(
            title: 'User accelerometer',
            subtitle:
                'Gravity-filtered acceleration is useful for movement gestures and motion-driven gameplay.',
            accent: const Color(0xFF0F766E),
            rows: <(String, String)>[
              ('x', _axis(_userAccelerometer?.x)),
              ('y', _axis(_userAccelerometer?.y)),
              ('z', _axis(_userAccelerometer?.z)),
            ],
          ),
          const SizedBox(height: 16),
          _SensorCard(
            title: 'Gyroscope',
            subtitle:
                'Rotation speed around each axis can drive camera panning or motion controls.',
            accent: const Color(0xFF7C3AED),
            rows: <(String, String)>[
              ('x', _axis(_gyroscope?.x)),
              ('y', _axis(_gyroscope?.y)),
              ('z', _axis(_gyroscope?.z)),
            ],
            error: _gyroscopeError,
          ),
          const SizedBox(height: 16),
          _SensorCard(
            title: 'Magnetometer and barometer',
            subtitle:
                'These sensors are often missing on cheaper hardware, so `onError` paths matter in production.',
            accent: const Color(0xFFEA580C),
            rows: <(String, String)>[
              ('mag x', _axis(_magnetometer?.x)),
              ('mag y', _axis(_magnetometer?.y)),
              ('mag z', _axis(_magnetometer?.z)),
              (
                'pressure',
                _barometer == null
                    ? '?'
                    : '${_barometer!.pressure.toStringAsFixed(1)} hPa',
              ),
            ],
            error: environmentError,
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Implementation notes',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use `onError` for missing sensors, cancel subscriptions in `dispose`, and remember that iOS requires `NSMotionUsageDescription` when motion APIs are used.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _SensorCard extends StatelessWidget {
  const _SensorCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.rows,
    this.error,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final List<(String, String)> rows;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 16),
            ...rows.map(
              ((String, String) row) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 96,
                      child: Text(
                        row.$1,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: accent,
                        ),
                      ),
                    ),
                    Expanded(child: Text(row.$2)),
                  ],
                ),
              ),
            ),
            if (error != null && error!.isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(error!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
