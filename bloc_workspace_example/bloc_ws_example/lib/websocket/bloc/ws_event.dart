import 'package:equatable/equatable.dart';

abstract class WsEvent extends Equatable {
  const WsEvent();

  @override
  List<Object?> get props => [];
}

class WsConnectRequested extends WsEvent {
  const WsConnectRequested(this.url);

  final String url;

  @override
  List<Object?> get props => [url];
}

class WsDisconnectRequested extends WsEvent {
  const WsDisconnectRequested({this.fromServer = false});

  final bool fromServer;

  @override
  List<Object?> get props => [fromServer];
}

class WsSendPressed extends WsEvent {
  const WsSendPressed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class WsMessageArrived extends WsEvent {
  const WsMessageArrived(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class WsSocketError extends WsEvent {
  const WsSocketError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class WsSocketDone extends WsEvent {
  const WsSocketDone();
}
