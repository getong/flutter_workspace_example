import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/domain/entities/libp2p_webrtc_demo_snapshot.dart';

class Libp2pWebRtcDemoState {
  const Libp2pWebRtcDemoState({required this.snapshot, this.isBusy = false});

  factory Libp2pWebRtcDemoState.initial({
    required Libp2pWebRtcDemoSnapshot snapshot,
  }) {
    return Libp2pWebRtcDemoState(snapshot: snapshot);
  }

  final Libp2pWebRtcDemoSnapshot snapshot;
  final bool isBusy;

  Libp2pWebRtcDemoState copyWith({
    Libp2pWebRtcDemoSnapshot? snapshot,
    bool? isBusy,
  }) {
    return Libp2pWebRtcDemoState(
      snapshot: snapshot ?? this.snapshot,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
