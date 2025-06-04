class LoggerService {
  final DateTime _createdAt = DateTime.now();
  static int _instanceCount = 0;
  final int _instanceId;

  LoggerService() : _instanceId = ++_instanceCount {
    print('LoggerService instance #$_instanceId created at $_createdAt');
  }

  void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] Logger #$_instanceId: $message');
  }

  void logError(String message, [Object? error]) {
    final timestamp = DateTime.now().toIso8601String();
    print(
      '[$timestamp] ERROR Logger #$_instanceId: $message${error != null ? ' - $error' : ''}',
    );
  }

  void logInfo(String message) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] INFO Logger #$_instanceId: $message');
  }
}
