// Example: Custom class (old way before Records)
class ProgressData {
  final double progress;
  final bool isDone;

  ProgressData(this.progress, this.isDone);

  @override
  String toString() => 'ProgressData(progress: $progress, isDone: $isDone)';
}
