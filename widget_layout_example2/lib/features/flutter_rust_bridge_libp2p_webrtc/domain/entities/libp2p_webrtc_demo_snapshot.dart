class Libp2pWebRtcDemoSnapshot {
  const Libp2pWebRtcDemoSnapshot({
    required this.serverMultiaddr,
    required this.timeoutSeconds,
    required this.isSupported,
    required this.hasSuccessfulDial,
    required this.localPeerId,
    required this.remotePeerId,
    required this.lastSentMessage,
    required this.lastEchoedMessage,
    required this.lastServerTimestamp,
    required this.statusMessage,
    required this.explanation,
    required this.steps,
  });

  factory Libp2pWebRtcDemoSnapshot.initial() {
    return const Libp2pWebRtcDemoSnapshot(
      serverMultiaddr: '',
      timeoutSeconds: 12,
      isSupported: true,
      hasSuccessfulDial: false,
      localPeerId: '',
      remotePeerId: '',
      lastSentMessage: '',
      lastEchoedMessage: '',
      lastServerTimestamp: '',
      statusMessage:
          'Paste a /webrtc-direct/certhash/.../p2p/... server multiaddr, then connect and send a chat message through Rust.',
      explanation:
          'This module keeps Flutter focused on UI and state while Rust owns the native libp2p-webrtc transport, Noise handshake, and a simple request-response chat exchange.',
      steps: <String>[
        'Start the dedicated Rust libp2p WebRTC server example.',
        'Copy one printed /webrtc-direct/certhash/.../p2p/... multiaddr.',
        'Paste it into this page, type a chat message, and submit the request.',
        'Flutter calls Rust through flutter_rust_bridge.',
        'Rust dials the server, completes libp2p handshake, sends the chat message, and returns the echoed response with a timestamp.',
      ],
    );
  }

  final String serverMultiaddr;
  final int timeoutSeconds;
  final bool isSupported;
  final bool hasSuccessfulDial;
  final String localPeerId;
  final String remotePeerId;
  final String lastSentMessage;
  final String lastEchoedMessage;
  final String lastServerTimestamp;
  final String statusMessage;
  final String explanation;
  final List<String> steps;

  Libp2pWebRtcDemoSnapshot copyWith({
    String? serverMultiaddr,
    int? timeoutSeconds,
    bool? isSupported,
    bool? hasSuccessfulDial,
    String? localPeerId,
    String? remotePeerId,
    String? lastSentMessage,
    String? lastEchoedMessage,
    String? lastServerTimestamp,
    String? statusMessage,
    String? explanation,
    List<String>? steps,
  }) {
    return Libp2pWebRtcDemoSnapshot(
      serverMultiaddr: serverMultiaddr ?? this.serverMultiaddr,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
      isSupported: isSupported ?? this.isSupported,
      hasSuccessfulDial: hasSuccessfulDial ?? this.hasSuccessfulDial,
      localPeerId: localPeerId ?? this.localPeerId,
      remotePeerId: remotePeerId ?? this.remotePeerId,
      lastSentMessage: lastSentMessage ?? this.lastSentMessage,
      lastEchoedMessage: lastEchoedMessage ?? this.lastEchoedMessage,
      lastServerTimestamp: lastServerTimestamp ?? this.lastServerTimestamp,
      statusMessage: statusMessage ?? this.statusMessage,
      explanation: explanation ?? this.explanation,
      steps: steps ?? this.steps,
    );
  }
}
