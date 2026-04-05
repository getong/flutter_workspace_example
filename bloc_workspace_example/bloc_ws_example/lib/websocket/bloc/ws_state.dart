import 'package:equatable/equatable.dart';

enum WsStatus { disconnected, connecting, connected, error }

class WsState extends Equatable {
  const WsState({
    this.status = WsStatus.disconnected,
    this.messages = const [],
    this.errorMessage,
    this.connectedUrl,
  });

  final WsStatus status;
  final List<String> messages;
  final String? errorMessage;
  final String? connectedUrl;

  WsState copyWith({
    WsStatus? status,
    List<String>? messages,
    String? errorMessage,
    String? connectedUrl,
    bool clearErrorMessage = false,
    bool clearConnectedUrl = false,
  }) {
    return WsState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      connectedUrl: clearConnectedUrl
          ? null
          : (connectedUrl ?? this.connectedUrl),
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage, connectedUrl];
}
