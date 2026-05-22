class GrpcDemoSnapshot {
  const GrpcDemoSnapshot({
    required this.endpoint,
    required this.userId,
    required this.displayName,
    required this.role,
    required this.serverTime,
    required this.capabilities,
    required this.events,
    required this.unaryBytes,
    required this.streamBytes,
    required this.elapsed,
  });

  final String endpoint;
  final String userId;
  final String displayName;
  final String role;
  final DateTime serverTime;
  final List<String> capabilities;
  final List<GrpcBuildEvent> events;
  final int unaryBytes;
  final int streamBytes;
  final Duration elapsed;
}

class GrpcBuildEvent {
  const GrpcBuildEvent({
    required this.step,
    required this.phase,
    required this.detail,
    required this.done,
  });

  final int step;
  final String phase;
  final String detail;
  final bool done;
}
