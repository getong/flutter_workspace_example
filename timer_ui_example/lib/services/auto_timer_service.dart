import 'dart:async';
import 'timer_service_base.dart';

class AutoTimerService extends TimerServiceBase {
  Timer? _timer;
  int _seconds = 0;

  AutoTimerService(VoidCallback onUpdate) : super(onUpdate);

  int get seconds => _seconds;

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      onUpdate();
    });
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
