import 'dart:async';
import 'timer_service_base.dart';

class PeriodicTimerService extends TimerServiceBase {
  Timer? _timer;
  int _counter = 0;
  bool _isRunning = false;

  PeriodicTimerService(VoidCallback onUpdate) : super(onUpdate);

  int get counter => _counter;
  bool get isRunning => _isRunning;

  void start() {
    if (_isRunning) return;

    _isRunning = true;
    onUpdate();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _counter++;
      onUpdate();
    });
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
    onUpdate();
  }

  void reset() {
    stop();
    _counter = 0;
    onUpdate();
  }

  @override
  String getFormattedTime() {
    return 'Count: $_counter';
  }

  @override
  void dispose() {
    _timer?.cancel();
  }
}
