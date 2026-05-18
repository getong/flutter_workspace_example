import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/data/services/flutter_webrtc_demo_runtime.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/domain/entities/flutter_webrtc_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/domain/repositories/flutter_webrtc_repository.dart';

class FlutterWebRtcDemoRepository implements FlutterWebRtcRepository {
  FlutterWebRtcDemoRepository({FlutterWebRtcDemoRuntime? runtime})
    : _runtime = runtime ?? FlutterWebRtcDemoRuntime();

  final FlutterWebRtcDemoRuntime _runtime;
  final StreamController<FlutterWebRtcDemoSnapshot> _controller =
      StreamController<FlutterWebRtcDemoSnapshot>.broadcast();

  StreamSubscription<FlutterWebRtcRuntimeBundle>? _subscription;
  late FlutterWebRtcDemoSnapshot _snapshot = _runtime.currentSnapshot;

  @override
  RTCVideoRenderer get localRenderer => _runtime.localRenderer;

  @override
  RTCVideoRenderer get remoteRenderer => _runtime.remoteRenderer;

  @override
  FlutterWebRtcDemoSnapshot get currentSnapshot => _snapshot;

  @override
  Stream<FlutterWebRtcDemoSnapshot> watchSnapshot() => _controller.stream;

  @override
  Future<FlutterWebRtcDemoSnapshot> initialize() async {
    _subscription ??= _runtime.watchState().listen(_handleBundle);
    _handleBundle(await _runtime.initialize());
    return _snapshot;
  }

  @override
  Future<FlutterWebRtcDemoSnapshot> restartLoopback() async {
    _handleBundle(await _runtime.restartLoopback());
    return _snapshot;
  }

  @override
  Future<FlutterWebRtcDemoSnapshot> toggleCameraEnabled() async {
    _handleBundle(await _runtime.toggleCameraEnabled());
    return _snapshot;
  }

  @override
  Future<FlutterWebRtcDemoSnapshot> toggleMicrophoneEnabled() async {
    _handleBundle(await _runtime.toggleMicrophoneEnabled());
    return _snapshot;
  }

  @override
  Future<FlutterWebRtcDemoSnapshot> switchCamera() async {
    _handleBundle(await _runtime.switchCamera());
    return _snapshot;
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _runtime.dispose();
    await _controller.close();
  }

  void _handleBundle(FlutterWebRtcRuntimeBundle bundle) {
    _snapshot = bundle.snapshot;
    if (!_controller.isClosed) {
      _controller.add(_snapshot);
    }
  }
}
