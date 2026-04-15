part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

final class NewsConnectRequested extends NewsEvent {
  const NewsConnectRequested({required this.url});

  final String url;

  @override
  List<Object?> get props => [url];
}

final class NewsDisconnectRequested extends NewsEvent {
  const NewsDisconnectRequested();
}

final class NewsMessageSubmitted extends NewsEvent {
  const NewsMessageSubmitted({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class _NewsSocketStatusReceived extends NewsEvent {
  const _NewsSocketStatusReceived(this.status);

  final NewsConnectionStatus status;

  @override
  List<Object?> get props => [status];
}

final class _NewsSocketMessageReceived extends NewsEvent {
  const _NewsSocketMessageReceived(this.message);

  final NewsSocketMessage message;

  @override
  List<Object?> get props => [message];
}

final class _NewsSocketErrorReceived extends NewsEvent {
  const _NewsSocketErrorReceived(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
