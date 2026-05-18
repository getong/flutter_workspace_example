import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/domain/entities/libp2p_webrtc_demo_snapshot.dart';

abstract interface class Libp2pWebRtcBridgeRepository {
  Libp2pWebRtcDemoSnapshot get currentSnapshot;

  Stream<Libp2pWebRtcDemoSnapshot> watchSnapshot();

  Future<Libp2pWebRtcDemoSnapshot> initialize();

  Future<Libp2pWebRtcDemoSnapshot> dialServer({
    required String serverMultiaddr,
    required int timeoutSeconds,
    required String message,
  });
}
