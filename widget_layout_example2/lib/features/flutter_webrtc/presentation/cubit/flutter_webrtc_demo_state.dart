import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/domain/entities/flutter_webrtc_demo_snapshot.dart';

class FlutterWebRtcDemoState {
  const FlutterWebRtcDemoState({
    required this.snapshot,
    required this.localRenderer,
    required this.remoteRenderer,
  });

  final FlutterWebRtcDemoSnapshot snapshot;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;

  FlutterWebRtcDemoState copyWith({
    FlutterWebRtcDemoSnapshot? snapshot,
    RTCVideoRenderer? localRenderer,
    RTCVideoRenderer? remoteRenderer,
  }) {
    return FlutterWebRtcDemoState(
      snapshot: snapshot ?? this.snapshot,
      localRenderer: localRenderer ?? this.localRenderer,
      remoteRenderer: remoteRenderer ?? this.remoteRenderer,
    );
  }
}
