import 'dart:typed_data';

enum WsStatus { disconnected, connecting, connected, error }

class WsBinaryRecord {
  const WsBinaryRecord({
    required this.bytes,
    required this.receivedAt,
    required this.sourceType,
  });

  final Uint8List bytes;
  final DateTime receivedAt;
  final String sourceType;
}

class WsState {
  const WsState({
    this.status = WsStatus.disconnected,
    this.connectedUrl,
    this.errorMessage,
    this.latestRecord,
    this.history = const [],
    this.logs = const [],
  });

  final WsStatus status;
  final String? connectedUrl;
  final String? errorMessage;
  final WsBinaryRecord? latestRecord;
  final List<WsBinaryRecord> history;
  final List<String> logs;

  WsState copyWith({
    WsStatus? status,
    String? connectedUrl,
    String? errorMessage,
    WsBinaryRecord? latestRecord,
    List<WsBinaryRecord>? history,
    List<String>? logs,
    bool clearConnectedUrl = false,
    bool clearErrorMessage = false,
    bool clearLatestRecord = false,
  }) {
    return WsState(
      status: status ?? this.status,
      connectedUrl: clearConnectedUrl
          ? null
          : (connectedUrl ?? this.connectedUrl),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      latestRecord: clearLatestRecord
          ? null
          : (latestRecord ?? this.latestRecord),
      history: history ?? this.history,
      logs: logs ?? this.logs,
    );
  }
}
