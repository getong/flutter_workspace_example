import 'package:equatable/equatable.dart';

enum NewsSocketMessageType { sent, received, system, error }

class NewsSocketMessage extends Equatable {
  const NewsSocketMessage({
    required this.text,
    required this.type,
    required this.timestamp,
  });

  final String text;
  final NewsSocketMessageType type;
  final DateTime timestamp;

  factory NewsSocketMessage.fromMap(Map<String, dynamic> map) {
    return NewsSocketMessage(
      text: map['text'] as String? ?? '',
      type: _typeFromValue(map['messageType'] as String?),
      timestamp:
          DateTime.tryParse(map['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  static NewsSocketMessageType _typeFromValue(String? value) {
    return switch (value) {
      'sent' => NewsSocketMessageType.sent,
      'received' => NewsSocketMessageType.received,
      'error' => NewsSocketMessageType.error,
      _ => NewsSocketMessageType.system,
    };
  }

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  @override
  List<Object?> get props => [text, type, timestamp];
}
