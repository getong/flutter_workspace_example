import 'dart:async';

import 'package:widget_layout_example2/core/rust/api/libp2p_webrtc.dart'
    as rust_api;
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/domain/entities/libp2p_webrtc_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/domain/repositories/libp2p_webrtc_bridge_repository.dart';

class FrbLibp2pWebRtcBridgeRepository implements Libp2pWebRtcBridgeRepository {
  final StreamController<Libp2pWebRtcDemoSnapshot> _controller =
      StreamController<Libp2pWebRtcDemoSnapshot>.broadcast();

  Libp2pWebRtcDemoSnapshot _snapshot = Libp2pWebRtcDemoSnapshot.initial();

  @override
  Libp2pWebRtcDemoSnapshot get currentSnapshot => _snapshot;

  @override
  Stream<Libp2pWebRtcDemoSnapshot> watchSnapshot() => _controller.stream;

  @override
  Future<Libp2pWebRtcDemoSnapshot> initialize() async {
    return _emit(_snapshot);
  }

  @override
  Future<Libp2pWebRtcDemoSnapshot> dialServer({
    required String serverMultiaddr,
    required int timeoutSeconds,
    required String message,
  }) async {
    final rust_api.Libp2pWebRtcDialResult result = await rust_api
        .dialLibp2PWebrtcServer(
          request: rust_api.Libp2pWebRtcDialRequest(
            serverMultiaddr: serverMultiaddr,
            timeoutSeconds: timeoutSeconds,
            message: message,
          ),
        );

    return _emit(
      _snapshot.copyWith(
        serverMultiaddr: result.dialedMultiaddr,
        timeoutSeconds: timeoutSeconds,
        hasSuccessfulDial: true,
        localPeerId: result.localPeerId,
        remotePeerId: result.remotePeerId,
        lastSentMessage: result.sentMessage,
        lastEchoedMessage: result.echoedMessage,
        lastServerTimestamp: result.serverTimestamp,
        statusMessage: result.statusMessage,
        explanation: result.explanation,
      ),
    );
  }

  Libp2pWebRtcDemoSnapshot _emit(Libp2pWebRtcDemoSnapshot nextSnapshot) {
    _snapshot = nextSnapshot;
    if (!_controller.isClosed) {
      _controller.add(_snapshot);
    }
    return _snapshot;
  }
}
