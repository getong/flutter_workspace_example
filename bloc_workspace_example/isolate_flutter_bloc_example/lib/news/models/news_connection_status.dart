enum NewsConnectionStatus { disconnected, connecting, connected, error }

extension NewsConnectionStatusX on NewsConnectionStatus {
  String get label {
    switch (this) {
      case NewsConnectionStatus.disconnected:
        return 'Disconnected';
      case NewsConnectionStatus.connecting:
        return 'Connecting';
      case NewsConnectionStatus.connected:
        return 'Connected';
      case NewsConnectionStatus.error:
        return 'Error';
    }
  }
}
