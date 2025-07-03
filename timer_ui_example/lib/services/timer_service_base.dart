typedef VoidCallback = void Function();

abstract class TimerServiceBase {
  final VoidCallback onUpdate;

  TimerServiceBase(this.onUpdate);

  String formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String getFormattedTime();
  void dispose();
}
