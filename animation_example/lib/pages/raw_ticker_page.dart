import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../widgets/go_back_icon_button.dart';

class RawTickerPage extends StatefulWidget {
  const RawTickerPage({super.key});

  @override
  State<RawTickerPage> createState() => _RawTickerPageState();
}

class _RawTickerPageState extends State<RawTickerPage>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  Duration _lastTick = Duration.zero;
  bool _isRunning = false;
  double _phase = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  void _onTick(Duration elapsed) {
    final Duration delta = elapsed - _lastTick;
    _lastTick = elapsed;
    _elapsed = elapsed;

    final double deltaSeconds =
        delta.inMicroseconds / Duration.microsecondsPerSecond;
    setState(() {
      _phase += deltaSeconds * 2 * math.pi;
    });
  }

  void _startTicker() {
    if (_ticker.isActive) {
      return;
    }
    _lastTick = Duration.zero;
    _ticker.start();
    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTicker() {
    _ticker.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTicker() {
    _ticker.stop();
    setState(() {
      _isRunning = false;
      _elapsed = Duration.zero;
      _lastTick = Duration.zero;
      _phase = 0;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double wave = math.sin(_phase);
    final double horizontal = wave * 120;

    return Scaffold(
      appBar: AppBar(
        leading: const GoBackIconButton(),
        title: const Text('Raw Ticker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Ticker gives per-frame callbacks without AnimationController.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Text(
              'Elapsed: ${(_elapsed.inMilliseconds / 1000).toStringAsFixed(2)}s',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 300,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(horizontal, 0),
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: _startTicker,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                ),
                FilledButton.tonalIcon(
                  onPressed: _pauseTicker,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                ),
                OutlinedButton.icon(
                  onPressed: _resetTicker,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(_isRunning ? 'Ticker active' : 'Ticker paused'),
          ],
        ),
      ),
    );
  }
}
