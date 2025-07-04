import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

class IsolateManager {
  static final IsolateManager _instance = IsolateManager._internal();
  factory IsolateManager() => _instance;
  IsolateManager._internal();

  final ReceivePort _mainReceivePort = ReceivePort();
  Isolate? _backgroundIsolate;
  bool _isRunning = false;

  static const String _isolatePortName = 'isolate_port';

  ReceivePort get mainReceivePort => _mainReceivePort;
  bool get isRunning => _isRunning;

  void initialize() {
    // Register the port for isolate communication
    IsolateNameServer.registerPortWithName(_mainReceivePort.sendPort, _isolatePortName);
  }

  Future<void> startBackgroundIsolate() async {
    if (_isRunning) return;

    try {
      // Create a receive port for the background isolate
      final ReceivePort receivePort = ReceivePort();

      _backgroundIsolate = await Isolate.spawn(
        _backgroundIsolateEntryPoint,
        receivePort.sendPort,
        debugName: 'NotificationBackgroundIsolate',
      );

      _isRunning = true;

      // Listen to messages from the background isolate
      receivePort.listen((dynamic data) {
        // Forward the message to the main receive port
        _mainReceivePort.sendPort.send(data);
      });
    } catch (e) {
      _isRunning = false;
      rethrow;
    }
  }

  void stopBackgroundIsolate() {
    if (!_isRunning) return;

    _backgroundIsolate?.kill(priority: Isolate.immediate);
    _backgroundIsolate = null;
    _isRunning = false;
  }

  void dispose() {
    stopBackgroundIsolate();
    _mainReceivePort.close();
    IsolateNameServer.removePortNameMapping(_isolatePortName);
  }

  // Background isolate entry point
  @pragma('vm:entry-point')
  static void _backgroundIsolateEntryPoint(SendPort sendPort) {
    // Set up a periodic timer to send notifications from the background isolate
    Timer.periodic(Duration(seconds: 30), (timer) {
      sendPort.send({
        'type': 'background_work',
        'message': 'Background isolate is working!',
        'timestamp': DateTime.now().toIso8601String(),
      });
    });
  }

  // Background notification handler
  @pragma('vm:entry-point')
  static void notificationTapBackground(dynamic notificationResponse) {
    // Handle the notification tap in the background
    final SendPort? sendPort = IsolateNameServer.lookupPortByName(_isolatePortName);
    sendPort?.send({
      'type': 'notification_tap',
      'payload': notificationResponse.payload,
      'actionId': notificationResponse.actionId,
    });
  }
}
