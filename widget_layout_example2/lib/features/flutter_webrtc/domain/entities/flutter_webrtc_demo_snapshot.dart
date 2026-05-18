class FlutterWebRtcDemoSnapshot {
  const FlutterWebRtcDemoSnapshot({
    required this.isSupported,
    required this.isBusy,
    required this.cameraEnabled,
    required this.microphoneEnabled,
    required this.usingFrontCamera,
    required this.localVideoReady,
    required this.remoteVideoReady,
    required this.connectionStateLabel,
    required this.iceStateLabel,
    required this.statusMessage,
    required this.explanation,
    required this.effectSummary,
    required this.steps,
  });

  factory FlutterWebRtcDemoSnapshot.initial({required bool isSupported}) {
    return FlutterWebRtcDemoSnapshot(
      isSupported: isSupported,
      isBusy: false,
      cameraEnabled: true,
      microphoneEnabled: true,
      usingFrontCamera: true,
      localVideoReady: false,
      remoteVideoReady: false,
      connectionStateLabel: 'not-started',
      iceStateLabel: 'new',
      statusMessage: isSupported
          ? 'Ready to request camera and microphone.'
          : 'flutter_webrtc needs Android, iOS, macOS, Windows, Linux, or Web with media support.',
      explanation:
          'WebRTC captures local media, negotiates codecs and ICE, and streams audio/video with low latency.',
      effectSummary:
          'This demo loops your local camera stream through two in-app PeerConnections so you can see capture, negotiation, and remote rendering on one page.',
      steps: const <String>[
        'Request camera and microphone from flutter_webrtc.',
        'Bind local MediaStream to the local renderer.',
        'Create two RTCPeerConnection instances in the same app.',
        'Exchange offer/answer and ICE candidates locally.',
        'Render the remote track in a second video panel.',
      ],
    );
  }

  final bool isSupported;
  final bool isBusy;
  final bool cameraEnabled;
  final bool microphoneEnabled;
  final bool usingFrontCamera;
  final bool localVideoReady;
  final bool remoteVideoReady;
  final String connectionStateLabel;
  final String iceStateLabel;
  final String statusMessage;
  final String explanation;
  final String effectSummary;
  final List<String> steps;

  FlutterWebRtcDemoSnapshot copyWith({
    bool? isSupported,
    bool? isBusy,
    bool? cameraEnabled,
    bool? microphoneEnabled,
    bool? usingFrontCamera,
    bool? localVideoReady,
    bool? remoteVideoReady,
    String? connectionStateLabel,
    String? iceStateLabel,
    String? statusMessage,
    String? explanation,
    String? effectSummary,
    List<String>? steps,
  }) {
    return FlutterWebRtcDemoSnapshot(
      isSupported: isSupported ?? this.isSupported,
      isBusy: isBusy ?? this.isBusy,
      cameraEnabled: cameraEnabled ?? this.cameraEnabled,
      microphoneEnabled: microphoneEnabled ?? this.microphoneEnabled,
      usingFrontCamera: usingFrontCamera ?? this.usingFrontCamera,
      localVideoReady: localVideoReady ?? this.localVideoReady,
      remoteVideoReady: remoteVideoReady ?? this.remoteVideoReady,
      connectionStateLabel: connectionStateLabel ?? this.connectionStateLabel,
      iceStateLabel: iceStateLabel ?? this.iceStateLabel,
      statusMessage: statusMessage ?? this.statusMessage,
      explanation: explanation ?? this.explanation,
      effectSummary: effectSummary ?? this.effectSummary,
      steps: steps ?? this.steps,
    );
  }
}
