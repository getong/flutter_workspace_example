part of 'news_bloc.dart';

class NewsState extends Equatable {
  const NewsState({
    required this.connectionStatus,
    required this.currentUrl,
    required this.messages,
    this.errorMessage,
  });

  final NewsConnectionStatus connectionStatus;
  final String currentUrl;
  final List<NewsSocketMessage> messages;
  final String? errorMessage;

  factory NewsState.initial({required String initialUrl}) {
    return NewsState(
      connectionStatus: NewsConnectionStatus.disconnected,
      currentUrl: initialUrl,
      messages: const [],
    );
  }

  bool get isConnected => connectionStatus == NewsConnectionStatus.connected;
  bool get isConnecting => connectionStatus == NewsConnectionStatus.connecting;

  NewsState copyWith({
    NewsConnectionStatus? connectionStatus,
    String? currentUrl,
    List<NewsSocketMessage>? messages,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NewsState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      currentUrl: currentUrl ?? this.currentUrl,
      messages: messages ?? this.messages,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    connectionStatus,
    currentUrl,
    messages,
    errorMessage,
  ];
}
