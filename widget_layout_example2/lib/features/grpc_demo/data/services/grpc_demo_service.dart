import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:widget_layout_example2/features/grpc_demo/proto/grpc_demo.pbgrpc.dart';

class DemoGrpcService extends GrpcDemoServiceBase {
  @override
  Future<ProfileReply> unaryProfile(
    ServiceCall call,
    ProfileRequest request,
  ) async {
    final String userId = request.userId.trim().isEmpty
        ? 'guest-001'
        : request.userId.trim();
    final String requestedRole = request.preferredRole.trim().isEmpty
        ? 'viewer'
        : request.preferredRole.trim();

    await Future<void>.delayed(const Duration(milliseconds: 160));

    return ProfileReply(
      userId: userId,
      displayName: _displayNameFor(userId),
      role: requestedRole,
      serverTimeIso: DateTime.now().toIso8601String(),
      capabilities: <String>[
        'typed protobuf payload',
        'metadata-ready request',
        'unary response',
        'server streaming',
      ],
    );
  }

  @override
  Stream<BuildEvent> watchBuild(ServiceCall call, BuildRequest request) async* {
    final String target = request.target.trim().isEmpty
        ? 'flutter-client'
        : request.target.trim();
    final int steps = request.steps.clamp(1, 6);
    const List<String> phases = <String>[
      'Resolve proto schema',
      'Serialize request',
      'Dispatch over HTTP/2',
      'Stream typed events',
      'Map response to domain',
      'Render UI state',
    ];

    for (int step = 1; step <= steps; step += 1) {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      yield BuildEvent(
        step: step,
        phase: phases[step - 1],
        detail: '$target step $step/$steps completed by gRPC service',
        done: step == steps,
      );
    }
  }

  String _displayNameFor(String userId) {
    final String normalized = userId
        .split(RegExp(r'[-_.\s]+'))
        .where((String part) => part.isNotEmpty)
        .map((String part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
    return normalized.isEmpty ? 'Guest User' : normalized;
  }
}
