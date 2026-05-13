const Object _backgroundServiceSnapshotUnset = Object();

class BackgroundServiceSnapshot {
  const BackgroundServiceSnapshot({
    required this.isSupported,
    required this.platformLabel,
    required this.statusMessage,
    this.permissionSummary =
        'Notification permission has not been checked yet.',
    this.isConfigured = false,
    this.isRunning = false,
    this.isForegroundMode = false,
    this.tickCount = 0,
    this.lastTickAt,
    this.logEntries = const <String>[],
  });

  factory BackgroundServiceSnapshot.initial({
    required bool isSupported,
    required String platformLabel,
  }) {
    return BackgroundServiceSnapshot(
      isSupported: isSupported,
      platformLabel: platformLabel,
      statusMessage: isSupported
          ? 'Service has not been configured yet.'
          : 'flutter_background_service is only supported on Android and iOS.',
    );
  }

  final bool isSupported;
  final bool isConfigured;
  final bool isRunning;
  final bool isForegroundMode;
  final int tickCount;
  final DateTime? lastTickAt;
  final String platformLabel;
  final String permissionSummary;
  final String statusMessage;
  final List<String> logEntries;

  String get lastTickLabel =>
      lastTickAt?.toLocal().toString() ?? 'No heartbeat yet.';

  BackgroundServiceSnapshot copyWith({
    bool? isSupported,
    bool? isConfigured,
    bool? isRunning,
    bool? isForegroundMode,
    int? tickCount,
    Object? lastTickAt = _backgroundServiceSnapshotUnset,
    String? platformLabel,
    String? permissionSummary,
    String? statusMessage,
    List<String>? logEntries,
  }) {
    return BackgroundServiceSnapshot(
      isSupported: isSupported ?? this.isSupported,
      isConfigured: isConfigured ?? this.isConfigured,
      isRunning: isRunning ?? this.isRunning,
      isForegroundMode: isForegroundMode ?? this.isForegroundMode,
      tickCount: tickCount ?? this.tickCount,
      lastTickAt: identical(lastTickAt, _backgroundServiceSnapshotUnset)
          ? this.lastTickAt
          : lastTickAt as DateTime?,
      platformLabel: platformLabel ?? this.platformLabel,
      permissionSummary: permissionSummary ?? this.permissionSummary,
      statusMessage: statusMessage ?? this.statusMessage,
      logEntries: logEntries ?? this.logEntries,
    );
  }
}
