/// Enum representing different WebSocket connection states
enum WebSocketConnectionState { disconnected, connecting, connected, error }

/// Extension to provide display names for connection states
extension WebSocketConnectionStateExtension on WebSocketConnectionState {
  String get displayName {
    switch (this) {
      case WebSocketConnectionState.disconnected:
        return 'Disconnected';
      case WebSocketConnectionState.connecting:
        return 'Connecting...';
      case WebSocketConnectionState.connected:
        return 'Connected';
      case WebSocketConnectionState.error:
        return 'Error';
    }
  }
}
