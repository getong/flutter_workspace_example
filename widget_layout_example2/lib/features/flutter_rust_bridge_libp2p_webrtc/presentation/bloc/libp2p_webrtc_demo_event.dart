import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/domain/entities/libp2p_webrtc_demo_snapshot.dart';

sealed class Libp2pWebRtcDemoEvent {
  const Libp2pWebRtcDemoEvent();
}

final class Libp2pWebRtcDemoInitializeRequested extends Libp2pWebRtcDemoEvent {
  const Libp2pWebRtcDemoInitializeRequested();
}

final class Libp2pWebRtcDemoDialRequested extends Libp2pWebRtcDemoEvent {
  const Libp2pWebRtcDemoDialRequested({
    required this.serverMultiaddr,
    required this.timeoutSeconds,
    required this.message,
  });

  final String serverMultiaddr;
  final int timeoutSeconds;
  final String message;
}

final class Libp2pWebRtcDemoSnapshotChanged extends Libp2pWebRtcDemoEvent {
  const Libp2pWebRtcDemoSnapshotChanged({required this.snapshot});

  final Libp2pWebRtcDemoSnapshot snapshot;
}
