import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task_state.dart';
import '../services/future_service.dart';

/// Controller class for managing Future operations and their cancellation
class FutureController extends ChangeNotifier {
  TaskState _taskState = TaskState.ready;
  Completer<String>? _completer;
  Timer? _timer;

  TaskState get taskState => _taskState;

  /// Starts a long-running task that can be cancelled
  Future<void> startTask() async {
    _updateState(TaskState.running);
    
    try {
      _completer = Completer<String>();
      
      final result = await FutureService.simulateLongTask(
        _completer!,
        (progress) {
          _updateState(_taskState.copyWith(progress: progress));
        },
      );
      
      // Only update UI if the task wasn't cancelled
      if (!_completer!.isCompleted) {
        _updateState(TaskState(status: result, isLoading: false));
      }
    } catch (e) {
      _updateState(TaskState(status: 'Error: $e', isLoading: false, error: e.toString()));
    }
  }

  /// Cancels the currently running task
  void cancelTask() {
    if (_completer != null && !_completer!.isCompleted) {
      _timer?.cancel();
      _completer!.complete('Task was cancelled');
      _updateState(TaskState.cancelled);
    }
  }

  /// Makes a network request with timeout
  Future<void> makeNetworkRequest() async {
    _updateState(TaskState.networkLoading);
    
    try {
      final result = await FutureService.cancellableNetworkRequest();
      _updateState(TaskState(status: result, isLoading: false));
    } catch (e) {
      _updateState(TaskState(status: 'Error: $e', isLoading: false, error: e.toString()));
    }
  }

  /// Updates the current task state and notifies listeners
  void _updateState(TaskState newState) {
    _taskState = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up resources
    _timer?.cancel();
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete('Controller disposed');
    }
    super.dispose();
  }
}
