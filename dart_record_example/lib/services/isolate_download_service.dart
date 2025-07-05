import 'dart:isolate';

class IsolateDownloadService {
  // Static method to run in isolate
  static void downloadFile((SendPort, String) data) async {
    final (sendPort, url) = data;

    print('download from $url');

    // Simulate download processing
    for (var progress = 0.0; progress < 1.0; progress += 0.1) {
      await Future.delayed(
        const Duration(milliseconds: 100),
        () => sendPort.send((progress, false)), // RECORDS in action!
      );
    }

    sendPort.send((1.0, true)); // Final record
  }

  // Helper method to create isolate data
  static (SendPort, String) createIsolateData(SendPort sendPort, String url) {
    return (sendPort, url);
  }
}
