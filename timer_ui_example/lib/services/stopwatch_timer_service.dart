import 'dart:async';
import 'timer_service_base.dart';

class StopwatchTimerService extends TimerServiceBase {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;

  StopwatchTimerService(VoidCallback onUpdate) : super(onUpdate);

  int get seconds => _seconds;
  bool get isRunning => _isRunning;

  void start() {
    if (_isRunning) return;

    _isRunning = true;
    onUpdate();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
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
    _seconds = 0;
    onUpdate();
  }

  @override
  String getFormattedTime() {
    return formatTime(_seconds);
  }

  @override
  void dispose() {
    _timer?.cancel();
  }
}
