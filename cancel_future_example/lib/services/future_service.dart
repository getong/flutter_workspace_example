import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// Service class for handling Future operations and cancellation
class FutureService {
  static final Random _random = Random();

  /// Simulates a long-running task that can be cancelled using a Completer
  static Future<String> simulateLongTask(
    Completer<String> completer,
    Function(int progress) onProgress,
  ) async {
    int progress = 0;
    
    // Simulate progress updates every 500ms
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (completer.isCompleted) {
        timer.cancel();
        return;
      }
      
      progress++;
      onProgress(progress);
      
      // Complete after 10 steps (5 seconds)
      if (progress >= 10) {
        timer.cancel();
        if (!completer.isCompleted) {
          completer.complete('Task completed successfully!');
        }
      }
    });
    
    return completer.future;
  }

  /// Simulates a network request that can timeout
  static Future<String> simulateNetworkRequest() async {
    final completer = Completer<String>();
    
    // Simulate network delay
    Timer(const Duration(seconds: 3), () {
      if (!completer.isCompleted) {
        final responses = [
          'Data fetched successfully!',
          'User profile loaded',
          'API call completed',
          'Network request finished',
        ];
        completer.complete(responses[_random.nextInt(responses.length)]);
      }
    });
    
    return completer.future;
  }

  /// Demonstrates different ways to cancel futures
  static Future<String> cancellableNetworkRequest({
    Duration timeout = const Duration(seconds: 2),
  }) async {
    try {
      final result = await simulateNetworkRequest().timeout(
        timeout,
        onTimeout: () => throw TimeoutException(
          'Request timed out',
          timeout,
        ),
      );
      return result;
    } on TimeoutException {
      return 'Request timed out and was cancelled';
    } catch (e) {
      return 'Error: $e';
    }
  }

  /// Creates a cancellable timer
  static Timer createCancellableTimer(
    Duration duration,
    VoidCallback callback,
  ) {
    return Timer(duration, callback);
  }

  /// Creates a periodic timer that can be cancelled
  static Timer createPeriodicTimer(
    Duration period,
    void Function(Timer timer) callback,
  ) {
    return Timer.periodic(period, callback);
  }
}
