/// Represents the state of an asynchronous task
class TaskState {
  final String status;
  final int progress;
  final bool isLoading;
  final String? error;

  const TaskState({
    required this.status,
    this.progress = 0,
    this.isLoading = false,
    this.error,
  });

  TaskState copyWith({
    String? status,
    int? progress,
    bool? isLoading,
    String? error,
  }) {
    return TaskState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  // Predefined states
  static const TaskState ready = TaskState(status: 'Ready to start');
  static const TaskState running = TaskState(status: 'Task is running...', isLoading: true);
  static const TaskState cancelled = TaskState(status: 'Task cancelled by user');
  static const TaskState completed = TaskState(status: 'Task completed successfully!');
  static const TaskState networkLoading = TaskState(status: 'Making network request...', isLoading: true);
  static const TaskState timeout = TaskState(status: 'Request timed out and was cancelled');
}
