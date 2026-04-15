import 'package:equatable/equatable.dart';

import 'news_connection_status.dart';
import 'news_socket_message.dart';

enum NewsSocketUpdateType { status, message, error }

class NewsSocketUpdate extends Equatable {
  const NewsSocketUpdate._({
    required this.type,
    this.status,
    this.message,
    this.errorMessage,
  });

  final NewsSocketUpdateType type;
  final NewsConnectionStatus? status;
  final NewsSocketMessage? message;
  final String? errorMessage;

  factory NewsSocketUpdate.status(NewsConnectionStatus status) {
    return NewsSocketUpdate._(
      type: NewsSocketUpdateType.status,
      status: status,
    );
  }

  factory NewsSocketUpdate.message(NewsSocketMessage message) {
    return NewsSocketUpdate._(
      type: NewsSocketUpdateType.message,
      message: message,
    );
  }

  factory NewsSocketUpdate.error(String errorMessage) {
    return NewsSocketUpdate._(
      type: NewsSocketUpdateType.error,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [type, status, message, errorMessage];
}
