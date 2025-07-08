/// Represents different types of WebSocket messages
enum MessageType { sent, received, connection, error, info }

/// Model class for WebSocket messages
class WebSocketMessage {
  final String content;
  final MessageType type;
  final DateTime timestamp;

  WebSocketMessage({
    required this.content,
    required this.type,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Creates a sent message
  factory WebSocketMessage.sent(String content) {
    return WebSocketMessage(
      content: '📤 Sent: $content',
      type: MessageType.sent,
    );
  }

  /// Creates a received message
  factory WebSocketMessage.received(String content) {
    return WebSocketMessage(
      content: '📥 Received: $content',
      type: MessageType.received,
    );
  }

  /// Creates a connection message
  factory WebSocketMessage.connection(String content) {
    return WebSocketMessage(
      content: '✅ $content',
      type: MessageType.connection,
    );
  }

  /// Creates an error message
  factory WebSocketMessage.error(String content) {
    return WebSocketMessage(
      content: '❌ Error: $content',
      type: MessageType.error,
    );
  }

  /// Creates an info message
  factory WebSocketMessage.info(String content) {
    return WebSocketMessage(content: '🔌 $content', type: MessageType.info);
  }

  /// Formatted timestamp string
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }
}
