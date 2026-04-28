import 'dart:convert';

enum ServePemChatEventType {
  localInfo,
  welcome,
  presence,
  chatMessage,
  error,
  disconnected,
}

class ServePemChatEvent {
  final ServePemChatEventType type;
  final String label;
  final String? room;
  final String? user;
  final String? message;
  final String? action;
  final String? connection;
  final int? memberCount;
  final String? rawMessage;
  final DateTime timestamp;

  const ServePemChatEvent({
    required this.type,
    required this.label,
    required this.timestamp,
    this.room,
    this.user,
    this.message,
    this.action,
    this.connection,
    this.memberCount,
    this.rawMessage,
  });

  factory ServePemChatEvent.localInfo(String message) {
    return ServePemChatEvent(
      type: ServePemChatEventType.localInfo,
      label: 'Local',
      message: message,
      timestamp: DateTime.now(),
    );
  }

  factory ServePemChatEvent.disconnected(String message) {
    return ServePemChatEvent(
      type: ServePemChatEventType.disconnected,
      label: 'Disconnected',
      message: message,
      timestamp: DateTime.now(),
    );
  }

  factory ServePemChatEvent.fromRawMessage(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('websocket payload must be a JSON object');
    }

    final eventName = decoded['event'];
    final payload = decoded['payload'];
    if (eventName is! String || payload is! Map<String, dynamic>) {
      throw const FormatException(
        'websocket payload must contain string event and object payload fields',
      );
    }

    final now = DateTime.now();
    return switch (eventName) {
      'welcome' => ServePemChatEvent(
        type: ServePemChatEventType.welcome,
        label: 'Welcome',
        room: _readRequiredString(payload, 'room'),
        connection: _readOptionalString(payload, 'connection'),
        memberCount: _readOptionalInt(payload, 'member_count'),
        timestamp: now,
        rawMessage: raw,
      ),
      'presence' => ServePemChatEvent(
        type: ServePemChatEventType.presence,
        label: 'Presence',
        room: _readRequiredString(payload, 'room'),
        action: _readOptionalString(payload, 'action'),
        connection: _readOptionalString(payload, 'connection'),
        memberCount: _readOptionalInt(payload, 'member_count'),
        timestamp: now,
        rawMessage: raw,
      ),
      'chat_message' => ServePemChatEvent(
        type: ServePemChatEventType.chatMessage,
        label: 'Message',
        room: _readRequiredString(payload, 'room'),
        user: _readOptionalString(payload, 'user'),
        message: _readRequiredString(payload, 'msg'),
        connection: _readOptionalString(payload, 'from'),
        timestamp: now,
        rawMessage: raw,
      ),
      'error' => ServePemChatEvent(
        type: ServePemChatEventType.error,
        label: 'Server error',
        message: _readRequiredString(payload, 'message'),
        timestamp: now,
        rawMessage: raw,
      ),
      _ => ServePemChatEvent(
        type: ServePemChatEventType.error,
        label: 'Unhandled event',
        message: 'Server sent unsupported websocket event "$eventName".',
        timestamp: now,
        rawMessage: raw,
      ),
    };
  }

  static String _readRequiredString(Map<String, dynamic> payload, String key) {
    final value = payload[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('websocket payload field "$key" is missing');
    }

    return value;
  }

  static String? _readOptionalString(Map<String, dynamic> payload, String key) {
    final value = payload[key];
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }

    return null;
  }

  static int? _readOptionalInt(Map<String, dynamic> payload, String key) {
    final value = payload[key];
    return value is int ? value : null;
  }
}
