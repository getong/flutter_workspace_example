import 'package:flutter/material.dart';
import 'timer_card.dart';
import '../services/countdown_timer_service.dart';
import '../services/stopwatch_timer_service.dart';
import '../services/periodic_timer_service.dart';
import '../services/auto_timer_service.dart';

class TimerHomePage extends StatefulWidget {
  const TimerHomePage({super.key, required this.title});

  final String title;

  @override
  State<TimerHomePage> createState() => _TimerHomePageState();
}

class _TimerHomePageState extends State<TimerHomePage> {
  late final CountdownTimerService _countdownService;
  late final StopwatchTimerService _stopwatchService;
  late final PeriodicTimerService _periodicService;
  late final AutoTimerService _autoService;

  @override
  void initState() {
    super.initState();
    _countdownService = CountdownTimerService(() => setState(() {}));
    _stopwatchService = StopwatchTimerService(() => setState(() {}));
    _periodicService = PeriodicTimerService(() => setState(() {}));
    _autoService = AutoTimerService(() => setState(() {}));

    _autoService.start();
  }

  @override
  void dispose() {
    _countdownService.dispose();
    _stopwatchService.dispose();
    _periodicService.dispose();
    _autoService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TimerCard(
                title: 'Auto Timer (Always Running)',
                timeDisplay: _autoService.getFormattedTime(),
                hasControls: false,
              ),
              const SizedBox(height: 20),

              TimerCard(
                title: 'Countdown Timer',
                timeDisplay: _countdownService.getFormattedTime(),
                isRunning: _countdownService.isRunning,
                onStart: _countdownService.start,
                onStop: _countdownService.stop,
                onReset: _countdownService.reset,
                timeColor: _countdownService.seconds <= 10
                    ? Colors.red
                    : Colors.black,
              ),
              const SizedBox(height: 20),

              TimerCard(
                title: 'Stopwatch Timer',
                timeDisplay: _stopwatchService.getFormattedTime(),
                isRunning: _stopwatchService.isRunning,
                onStart: _stopwatchService.start,
                onStop: _stopwatchService.stop,
                onReset: _stopwatchService.reset,
              ),
              const SizedBox(height: 20),

              TimerCard(
                title: 'Periodic Timer (Every 2 seconds)',
                timeDisplay: 'Count: ${_periodicService.counter}',
                isRunning: _periodicService.isRunning,
                onStart: _periodicService.start,
                onStop: _periodicService.stop,
                onReset: _periodicService.reset,
                isCountDisplay: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
