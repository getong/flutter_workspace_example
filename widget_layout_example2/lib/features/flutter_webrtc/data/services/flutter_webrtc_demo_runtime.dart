import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/domain/entities/flutter_webrtc_demo_snapshot.dart';

class FlutterWebRtcRuntimeBundle {
  const FlutterWebRtcRuntimeBundle({
    required this.snapshot,
    required this.localRenderer,
    required this.remoteRenderer,
  });

  final FlutterWebRtcDemoSnapshot snapshot;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
}

class FlutterWebRtcDemoRuntime {
  FlutterWebRtcDemoRuntime({
    RTCVideoRenderer? localRenderer,
    RTCVideoRenderer? remoteRenderer,
  }) : _localRenderer = localRenderer ?? RTCVideoRenderer(),
       _remoteRenderer = remoteRenderer ?? RTCVideoRenderer(),
       _snapshot = FlutterWebRtcDemoSnapshot.initial(
         isSupported: _computeIsSupported(),
       );

  static bool _computeIsSupported() {
    if (kIsWeb) {
      return true;
    }
    return Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isWindows ||
        Platform.isLinux;
  }

  final RTCVideoRenderer _localRenderer;
  final RTCVideoRenderer _remoteRenderer;
  final StreamController<FlutterWebRtcRuntimeBundle> _controller =
      StreamController<FlutterWebRtcRuntimeBundle>.broadcast();

  FlutterWebRtcDemoSnapshot _snapshot;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  RTCPeerConnection? _callerPeer;
  RTCPeerConnection? _calleePeer;
  bool _initialized = false;

  bool get isSupported => _snapshot.isSupported;

  RTCVideoRenderer get localRenderer => _localRenderer;

  RTCVideoRenderer get remoteRenderer => _remoteRenderer;

  FlutterWebRtcDemoSnapshot get currentSnapshot => _snapshot;

  Stream<FlutterWebRtcRuntimeBundle> watchState() => _controller.stream;

  Future<FlutterWebRtcRuntimeBundle> initialize() async {
    if (_initialized) {
      return _emit(
        _snapshot.copyWith(
          statusMessage: _snapshot.isSupported
              ? 'Renderer already initialized. Ready to start or restart loopback.'
              : _snapshot.statusMessage,
        ),
      );
    }

    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    _initialized = true;

    return _emit(
      _snapshot.copyWith(
        statusMessage: _snapshot.isSupported
            ? 'Renderer initialized. Tap Start Loopback to capture local media.'
            : _snapshot.statusMessage,
      ),
    );
  }

  Future<FlutterWebRtcRuntimeBundle> restartLoopback() async {
    if (!isSupported) {
      return _emit(_snapshot);
    }

    await initialize();
    await _teardownPeerGraph(clearRenderers: true);

    final FlutterWebRtcDemoSnapshot busySnapshot = _snapshot.copyWith(
      isBusy: true,
      statusMessage: 'Requesting local camera and microphone...',
      connectionStateLabel: 'connecting',
      iceStateLabel: 'gathering',
      localVideoReady: false,
      remoteVideoReady: false,
    );
    _emit(busySnapshot);

    try {
      await _createLocalStream();
      await _createPeerConnections();
      await _attachLocalTracks();
      await _runOfferAnswerExchange();
      return _emit(
        _snapshot.copyWith(
          isBusy: false,
          localVideoReady: _localRenderer.srcObject != null,
          remoteVideoReady: _remoteRenderer.srcObject != null,
          statusMessage:
              'Loopback connected. The right panel is receiving media through WebRTC negotiation inside the app.',
        ),
      );
    } catch (error) {
      await _teardownPeerGraph(clearRenderers: true);
      return _emit(
        _snapshot.copyWith(
          isBusy: false,
          localVideoReady: false,
          remoteVideoReady: false,
          connectionStateLabel: 'failed',
          statusMessage: 'Failed to start loopback: $error',
        ),
      );
    }
  }

  Future<FlutterWebRtcRuntimeBundle> toggleCameraEnabled() async {
    final MediaStream? localStream = _localStream;
    if (localStream == null) {
      return _emit(
        _snapshot.copyWith(
          statusMessage:
              'Start the loopback first so a local video track exists.',
        ),
      );
    }

    final List<MediaStreamTrack> tracks = localStream.getVideoTracks();
    if (tracks.isEmpty) {
      return _emit(
        _snapshot.copyWith(
          statusMessage: 'No local video track is available on this device.',
        ),
      );
    }

    final bool nextEnabled = !tracks.first.enabled;
    for (final MediaStreamTrack track in tracks) {
      track.enabled = nextEnabled;
    }

    return _emit(
      _snapshot.copyWith(
        cameraEnabled: nextEnabled,
        statusMessage: nextEnabled
            ? 'Camera track enabled. Local and remote video should resume.'
            : 'Camera track disabled. The remote panel should freeze or go dark.',
      ),
    );
  }

  Future<FlutterWebRtcRuntimeBundle> toggleMicrophoneEnabled() async {
    final MediaStream? localStream = _localStream;
    if (localStream == null) {
      return _emit(
        _snapshot.copyWith(
          statusMessage:
              'Start the loopback first so a local audio track exists.',
        ),
      );
    }

    final List<MediaStreamTrack> tracks = localStream.getAudioTracks();
    if (tracks.isEmpty) {
      return _emit(
        _snapshot.copyWith(
          statusMessage: 'No local audio track is available on this device.',
        ),
      );
    }

    final bool nextEnabled = !tracks.first.enabled;
    for (final MediaStreamTrack track in tracks) {
      track.enabled = nextEnabled;
    }

    return _emit(
      _snapshot.copyWith(
        microphoneEnabled: nextEnabled,
        statusMessage: nextEnabled
            ? 'Microphone track enabled.'
            : 'Microphone track disabled. The remote peer still stays connected, but audio stops flowing.',
      ),
    );
  }

  Future<FlutterWebRtcRuntimeBundle> switchCamera() async {
    final MediaStream? localStream = _localStream;
    if (localStream == null) {
      return _emit(
        _snapshot.copyWith(
          statusMessage: 'Start the loopback before switching cameras.',
        ),
      );
    }

    final List<MediaStreamTrack> tracks = localStream.getVideoTracks();
    if (tracks.isEmpty) {
      return _emit(
        _snapshot.copyWith(
          statusMessage: 'This stream has no video track to switch.',
        ),
      );
    }

    await Helper.switchCamera(tracks.first);
    return _emit(
      _snapshot.copyWith(
        usingFrontCamera: !_snapshot.usingFrontCamera,
        statusMessage:
            'Camera switched. This demonstrates that flutter_webrtc controls the native capture device directly.',
      ),
    );
  }

  Future<void> dispose() async {
    await _teardownPeerGraph(clearRenderers: true);
    await _localRenderer.dispose();
    await _remoteRenderer.dispose();
    await _controller.close();
  }

  Future<void> _createLocalStream() async {
    final MediaStream stream = await navigator.mediaDevices.getUserMedia(
      <String, dynamic>{
        'audio': <String, dynamic>{
          'echoCancellation': true,
          'noiseSuppression': true,
        },
        'video': <String, dynamic>{
          'facingMode': _snapshot.usingFrontCamera ? 'user' : 'environment',
          'width': <String, dynamic>{'ideal': 1280},
          'height': <String, dynamic>{'ideal': 720},
          'frameRate': <String, dynamic>{'ideal': 24},
        },
      },
    );

    _localStream = stream;
    _localRenderer.srcObject = stream;
    _snapshot = _snapshot.copyWith(
      cameraEnabled: _isTrackCollectionEnabled(stream.getVideoTracks()),
      microphoneEnabled: _isTrackCollectionEnabled(stream.getAudioTracks()),
      localVideoReady: true,
      statusMessage:
          'Local stream captured. Negotiating loopback connection...',
    );
  }

  Future<void> _createPeerConnections() async {
    final Map<String, dynamic> configuration = <String, dynamic>{
      'sdpSemantics': 'unified-plan',
      'iceServers': <Map<String, dynamic>>[
        <String, dynamic>{'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    _callerPeer = await createPeerConnection(configuration);
    _calleePeer = await createPeerConnection(configuration);

    _callerPeer!.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate?.isNotEmpty ?? false) {
        unawaited(_calleePeer?.addCandidate(candidate));
      }
    };
    _calleePeer!.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate?.isNotEmpty ?? false) {
        unawaited(_callerPeer?.addCandidate(candidate));
      }
    };

    _callerPeer!.onConnectionState = (RTCPeerConnectionState state) {
      _emit(
        _snapshot.copyWith(
          connectionStateLabel: state.name,
          statusMessage: 'Caller state changed to ${state.name}.',
        ),
      );
    };
    _calleePeer!.onIceConnectionState = (RTCIceConnectionState state) {
      _emit(_snapshot.copyWith(iceStateLabel: state.name));
    };
    _calleePeer!.onTrack = (RTCTrackEvent event) {
      if (event.track.kind != 'video' && event.track.kind != 'audio') {
        return;
      }

      final MediaStream stream = event.streams.isNotEmpty
          ? event.streams.first
          : _remoteStream ?? _localStream!;

      _remoteStream = stream;
      _remoteRenderer.srcObject = stream;
      _emit(
        _snapshot.copyWith(
          remoteVideoReady: stream.getVideoTracks().isNotEmpty,
          statusMessage:
              'Remote track received. The right panel is now showing WebRTC-decoded media.',
        ),
      );
    };
  }

  Future<void> _attachLocalTracks() async {
    final MediaStream localStream = _localStream!;
    for (final MediaStreamTrack track in localStream.getTracks()) {
      await _callerPeer!.addTrack(track, localStream);
    }
  }

  Future<void> _runOfferAnswerExchange() async {
    final RTCSessionDescription offer = await _callerPeer!.createOffer();
    await _callerPeer!.setLocalDescription(offer);
    await _calleePeer!.setRemoteDescription(offer);

    final RTCSessionDescription answer = await _calleePeer!.createAnswer();
    await _calleePeer!.setLocalDescription(answer);
    await _callerPeer!.setRemoteDescription(answer);
  }

  Future<void> _teardownPeerGraph({required bool clearRenderers}) async {
    final RTCPeerConnection? callerPeer = _callerPeer;
    final RTCPeerConnection? calleePeer = _calleePeer;
    _callerPeer = null;
    _calleePeer = null;

    if (callerPeer != null) {
      await callerPeer.close();
      await callerPeer.dispose();
    }
    if (calleePeer != null) {
      await calleePeer.close();
      await calleePeer.dispose();
    }

    final MediaStream? localStream = _localStream;
    _localStream = null;
    if (localStream != null) {
      for (final MediaStreamTrack track in localStream.getTracks()) {
        await track.stop();
      }
      await localStream.dispose();
    }

    final MediaStream? remoteStream = _remoteStream;
    _remoteStream = null;
    if (remoteStream != null && !identical(remoteStream, localStream)) {
      await remoteStream.dispose();
    }

    if (clearRenderers) {
      _localRenderer.srcObject = null;
      _remoteRenderer.srcObject = null;
    }
  }

  bool _isTrackCollectionEnabled(List<MediaStreamTrack> tracks) {
    if (tracks.isEmpty) {
      return false;
    }
    return tracks.every((MediaStreamTrack track) => track.enabled);
  }

  FlutterWebRtcRuntimeBundle _emit(FlutterWebRtcDemoSnapshot snapshot) {
    _snapshot = snapshot;
    final FlutterWebRtcRuntimeBundle bundle = FlutterWebRtcRuntimeBundle(
      snapshot: _snapshot,
      localRenderer: _localRenderer,
      remoteRenderer: _remoteRenderer,
    );
    if (!_controller.isClosed) {
      _controller.add(bundle);
    }
    return bundle;
  }
}
