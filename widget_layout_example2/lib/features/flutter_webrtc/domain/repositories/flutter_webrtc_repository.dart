import 'package:widget_layout_example2/features/flutter_webrtc/domain/entities/flutter_webrtc_demo_snapshot.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract interface class FlutterWebRtcRepository {
  FlutterWebRtcDemoSnapshot get currentSnapshot;

  RTCVideoRenderer get localRenderer;

  RTCVideoRenderer get remoteRenderer;

  Stream<FlutterWebRtcDemoSnapshot> watchSnapshot();

  Future<FlutterWebRtcDemoSnapshot> initialize();

  Future<FlutterWebRtcDemoSnapshot> restartLoopback();

  Future<FlutterWebRtcDemoSnapshot> toggleCameraEnabled();

  Future<FlutterWebRtcDemoSnapshot> toggleMicrophoneEnabled();

  Future<FlutterWebRtcDemoSnapshot> switchCamera();

  Future<void> dispose();
}
