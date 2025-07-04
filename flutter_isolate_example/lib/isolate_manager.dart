import 'dart:isolate';
import 'fibonacci_calculator.dart';

class IsolateManager {
  Isolate? _isolate;
  SendPort? _sendPort;
  late void Function(int) _onResult;

  Future<void> initialize(void Function(int) onResult) async {
    _onResult = onResult;
    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(isolateEntryPoint, receivePort.sendPort);

    receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
      } else if (message is int) {
        _onResult(message);
      }
    });
  }

  void calculateFibonacci(int n) {
    if (_sendPort != null) {
      _sendPort!.send(n);
    }
  }

  void dispose() {
    _isolate?.kill();
    _isolate = null;
    _sendPort = null;
  }
}

@pragma('vm:entry-point')
void isolateEntryPoint(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((message) {
    if (message is int) {
      final result = FibonacciCalculator.calculate(message);
      sendPort.send(result);
    }
  });
}
