import 'dart:isolate';
import 'package:flutter/material.dart';
import '../services/isolate_download_service.dart';
import '../services/record_comparison.dart';

class DownloadManager {
  static Future<void> startDownload({
    required String url,
    required Function(double) onProgressUpdate,
    required Function(int) onGapStartUpdate,
    required Function(int) onGapCountUpdate,
    required Function(int) onGapCloseUpdate,
    required Function(int) onGapDoneUpdate,
    required VoidCallback onDownloadComplete,
  }) async {
    // Demonstrate the comparison first
    RecordComparison.demonstrateRecordVsAlternatives();

    final receivePort = ReceivePort();
    final data = IsolateDownloadService.createIsolateData(
      receivePort.sendPort,
      url,
    );

    final stopwatch = Stopwatch()..start();
    final isolate = await Isolate.spawn(
      IsolateDownloadService.downloadFile,
      data,
    );
    onGapStartUpdate(stopwatch.elapsedMilliseconds);

    receivePort.listen(
      (receivedData) {
        // USING DART RECORDS (Modern way)
        final castedData = receivedData as (double, bool);
        final progress = castedData.$1;
        final isDone = castedData.$2;

        onProgressUpdate(progress);
        onGapCountUpdate(stopwatch.elapsedMilliseconds);

        if (isDone) {
          receivePort.close();
          isolate.kill(priority: Isolate.immediate);
          onGapCloseUpdate(stopwatch.elapsedMilliseconds);
        }
      },
      onDone: () {
        onDownloadComplete();
        onGapDoneUpdate(stopwatch.elapsedMilliseconds);
        stopwatch.stop();
      },
    );
  }
}
