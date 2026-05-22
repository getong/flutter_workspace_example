import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:widget_layout_example2/features/grpc_demo/data/services/grpc_demo_service.dart';
import 'package:widget_layout_example2/features/grpc_demo/domain/entities/grpc_demo_snapshot.dart';
import 'package:widget_layout_example2/features/grpc_demo/domain/repositories/grpc_demo_repository.dart';
import 'package:widget_layout_example2/features/grpc_demo/proto/grpc_demo.pbgrpc.dart';

class LocalGrpcDemoRepository implements GrpcDemoRepository {
  Server? _server;
  ClientChannel? _channel;
  GrpcDemoServiceClient? _client;
  String? _endpoint;

  @override
  Future<GrpcDemoSnapshot> runDemo({
    required String userId,
    required String preferredRole,
    required String target,
    required int steps,
  }) async {
    await _ensureStarted();

    final GrpcDemoServiceClient client = _client!;
    final Stopwatch stopwatch = Stopwatch()..start();

    final ProfileRequest profileRequest = ProfileRequest(
      userId: userId,
      preferredRole: preferredRole,
    );
    final ProfileReply profileReply = await client.unaryProfile(
      profileRequest,
      options: CallOptions(
        timeout: const Duration(seconds: 5),
        metadata: <String, String>{
          'x-demo-client': 'widget-layout-example2',
          'x-demo-call': 'unary-profile',
        },
      ),
    );

    final BuildRequest buildRequest = BuildRequest(
      target: target,
      steps: steps.clamp(1, 6),
    );
    final List<GrpcBuildEvent> events = <GrpcBuildEvent>[];
    int streamBytes = buildRequest.writeToBuffer().length;

    await for (final BuildEvent event in client.watchBuild(
      buildRequest,
      options: CallOptions(
        timeout: const Duration(seconds: 5),
        metadata: <String, String>{'x-demo-call': 'watch-build'},
      ),
    )) {
      streamBytes += event.writeToBuffer().length;
      events.add(
        GrpcBuildEvent(
          step: event.step,
          phase: event.phase,
          detail: event.detail,
          done: event.done,
        ),
      );
    }

    stopwatch.stop();

    return GrpcDemoSnapshot(
      endpoint: _endpoint!,
      userId: profileReply.userId,
      displayName: profileReply.displayName,
      role: profileReply.role,
      serverTime: DateTime.parse(profileReply.serverTimeIso),
      capabilities: List<String>.unmodifiable(profileReply.capabilities),
      events: List<GrpcBuildEvent>.unmodifiable(events),
      unaryBytes:
          profileRequest.writeToBuffer().length +
          profileReply.writeToBuffer().length,
      streamBytes: streamBytes,
      elapsed: stopwatch.elapsed,
    );
  }

  Future<void> _ensureStarted() async {
    if (_client != null) {
      return;
    }

    final Server server = Server.create(services: <Service>[DemoGrpcService()]);
    await server.serve(
      address: InternetAddress.loopbackIPv4,
      port: 0,
      security: ServerLocalCredentials(),
    );

    final int port = server.port!;
    final ClientChannel channel = ClientChannel(
      InternetAddress.loopbackIPv4,
      port: port,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    _server = server;
    _channel = channel;
    _client = GrpcDemoServiceClient(channel);
    _endpoint = '127.0.0.1:$port';
  }

  @override
  Future<void> dispose() async {
    final ClientChannel? channel = _channel;
    final Server? server = _server;

    _client = null;
    _channel = null;
    _server = null;
    _endpoint = null;

    await channel?.shutdown();
    await server?.shutdown();
  }
}
