import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import 'package:widget_layout_example2/modules/native_device_orientation_demo_support.dart';

@RoutePage(name: 'NativeDeviceOrientationCommunicatorRoute')
class NativeDeviceOrientationCommunicatorPage extends StatefulWidget {
  const NativeDeviceOrientationCommunicatorPage({super.key});

  @override
  State<NativeDeviceOrientationCommunicatorPage> createState() =>
      _NativeDeviceOrientationCommunicatorPageState();
}

class _NativeDeviceOrientationCommunicatorPageState
    extends State<NativeDeviceOrientationCommunicatorPage> {
  final NativeDeviceOrientationCommunicator _communicator =
      NativeDeviceOrientationCommunicator();

  StreamSubscription<NativeDeviceOrientation>? _subscription;
  NativeDeviceOrientation _latestOrientation = NativeDeviceOrientation.unknown;
  NativeDeviceOrientation _defaultOrientation =
      NativeDeviceOrientation.portraitUp;
  bool _useSensor = false;
  bool _isListening = false;
  bool _isPaused = false;
  String _status =
      'Call orientation() or start the stream to inspect live native values.';
  final List<String> _log = <String>[];

  @override
  void initState() {
    super.initState();
    if (supportsNativeDeviceOrientation) {
      _fetchOnce();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _pushLog(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    _log.insert(0, '$timestamp  $message');
    if (_log.length > 12) {
      _log.removeRange(12, _log.length);
    }
  }

  Future<void> _fetchOnce() async {
    if (!supportsNativeDeviceOrientation) {
      setState(() {
        _status = 'Live communicator calls are disabled outside Android/iOS.';
      });
      return;
    }

    try {
      final NativeDeviceOrientation orientation = await _communicator
          .orientation(
            useSensor: _useSensor,
            defaultOrientation: _defaultOrientation,
          );

      if (!mounted) {
        return;
      }

      setState(() {
        _latestOrientation = orientation;
        _status =
            'orientation() returned ${nativeOrientationLabel(orientation)}.';
        _pushLog(
          'orientation(useSensor: $_useSensor, defaultOrientation: ${_defaultOrientation.name}) -> ${orientation.name}',
        );
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'orientation() failed: $error';
        _pushLog('orientation() failed: $error');
      });
    }
  }

  Future<void> _startListening() async {
    if (!supportsNativeDeviceOrientation) {
      setState(() {
        _status = 'Live stream listening is disabled outside Android/iOS.';
      });
      return;
    }

    await _subscription?.cancel();
    _subscription = _communicator
        .onOrientationChanged(
          useSensor: _useSensor,
          defaultOrientation: _defaultOrientation,
        )
        .listen(
          (NativeDeviceOrientation orientation) {
            if (!mounted) {
              return;
            }

            setState(() {
              _latestOrientation = orientation;
              _status =
                  'Stream event received: ${nativeOrientationLabel(orientation)}.';
              _pushLog('stream event -> ${orientation.name}');
            });
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!mounted) {
              return;
            }

            setState(() {
              _status = 'Stream failed: $error';
              _isListening = false;
              _pushLog('stream failed: $error');
            });
          },
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _isListening = true;
      _isPaused = false;
      _status =
          'Listening to onOrientationChanged(useSensor: $_useSensor, defaultOrientation: ${_defaultOrientation.name}).';
      _pushLog('stream subscribed');
    });
  }

  Future<void> _stopListening() async {
    await _subscription?.cancel();
    _subscription = null;

    if (!mounted) {
      return;
    }

    setState(() {
      _isListening = false;
      _isPaused = false;
      _status = 'Stream subscription cancelled.';
      _pushLog('stream cancelled');
    });
  }

  Future<void> _pauseNativeStream() async {
    if (!supportsNativeDeviceOrientation) {
      return;
    }

    try {
      await _communicator.pause();
      if (!mounted) {
        return;
      }

      setState(() {
        _isPaused = true;
        _status = 'pause() requested on the native communicator.';
        _pushLog('pause() called');
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'pause() failed: $error';
        _pushLog('pause() failed: $error');
      });
    }
  }

  Future<void> _resumeNativeStream() async {
    if (!supportsNativeDeviceOrientation) {
      return;
    }

    try {
      await _communicator.resume();
      if (!mounted) {
        return;
      }

      setState(() {
        _isPaused = false;
        _status = 'resume() requested on the native communicator.';
        _pushLog('resume() called');
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'resume() failed: $error';
        _pushLog('resume() failed: $error');
      });
    }
  }

  Future<void> _updateUseSensor(bool value) async {
    setState(() {
      _useSensor = value;
      _status = 'Switched to ${nativeOrientationSignalLabel(value)}.';
      _pushLog('useSensor set to $value');
    });

    if (_isListening) {
      await _startListening();
    }
  }

  Future<void> _updateDefaultOrientation(NativeDeviceOrientation? value) async {
    if (value == null) {
      return;
    }

    setState(() {
      _defaultOrientation = value;
      _status = 'defaultOrientation set to ${nativeOrientationLabel(value)}.';
      _pushLog('defaultOrientation set to ${value.name}');
    });

    if (_isListening) {
      await _startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = nativeOrientationColor(_latestOrientation);

    return Scaffold(
      appBar: AppBar(
        title: const Text('native_device_orientation Communicator Module'),
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'NativeDeviceOrientationCommunicator is the direct API. It exposes `orientation()`, `onOrientationChanged()`, `pause()`, and `resume()` without requiring helper widgets.',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates one-shot reads, stream subscriptions, fallback configuration, and lifecycle-like pause/resume controls.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            if (!supportsNativeDeviceOrientation)
              const NativeOrientationSupportNotice(
                featureName: 'NativeDeviceOrientationCommunicator',
              ),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _useSensor,
                      onChanged: supportsNativeDeviceOrientation
                          ? _updateUseSensor
                          : null,
                      title: const Text('Use device sensors'),
                      subtitle: Text(nativeOrientationSignalLabel(_useSensor)),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<NativeDeviceOrientation>(
                      initialValue: _defaultOrientation,
                      decoration: const InputDecoration(
                        labelText: 'defaultOrientation argument',
                        border: OutlineInputBorder(),
                      ),
                      items: NativeDeviceOrientation.values
                          .where(
                            (NativeDeviceOrientation orientation) =>
                                orientation != NativeDeviceOrientation.unknown,
                          )
                          .map((NativeDeviceOrientation orientation) {
                            return DropdownMenuItem<NativeDeviceOrientation>(
                              value: orientation,
                              child: Text(nativeOrientationLabel(orientation)),
                            );
                          })
                          .toList(),
                      onChanged: supportsNativeDeviceOrientation
                          ? _updateDefaultOrientation
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: supportsNativeDeviceOrientation
                              ? _fetchOnce
                              : null,
                          icon: const Icon(Icons.search),
                          label: const Text('Call orientation()'),
                        ),
                        OutlinedButton.icon(
                          onPressed: supportsNativeDeviceOrientation
                              ? _startListening
                              : null,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start stream'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _isListening ? _stopListening : null,
                          icon: const Icon(Icons.stop),
                          label: const Text('Stop stream'),
                        ),
                        TextButton.icon(
                          onPressed: _isListening && !_isPaused
                              ? _pauseNativeStream
                              : null,
                          icon: const Icon(Icons.pause),
                          label: const Text('Pause native'),
                        ),
                        TextButton.icon(
                          onPressed: _isListening && _isPaused
                              ? _resumeNativeStream
                              : null,
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text('Resume native'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    NativeOrientationBadge(orientation: _latestOrientation),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _CommunicatorMetric(
                          label: 'Listening',
                          value: _isListening ? 'yes' : 'no',
                          color: accent,
                        ),
                        _CommunicatorMetric(
                          label: 'Paused',
                          value: _isPaused ? 'yes' : 'no',
                          color: accent,
                        ),
                        _CommunicatorMetric(
                          label: 'Mode',
                          value: _useSensor ? 'sensor' : 'window/page',
                          color: accent,
                        ),
                        _CommunicatorMetric(
                          label: 'Fallback',
                          value: _defaultOrientation.name,
                          color: accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(_status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            NativeOrientationExampleCard(
              title: 'Event log',
              description:
                  'The log helps verify how one-shot queries and stream events arrive over time.',
              api:
                  'Uses: communicator.orientation(...), communicator.onOrientationChanged(...), pause(), resume()',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _log.isEmpty
                    ? const Text('No events yet.')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _log
                            .map(
                              (String item) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(item),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _CommunicatorMetric extends StatelessWidget {
  const _CommunicatorMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
