import 'dart:typed_data';

abstract class WsEvent {
  const WsEvent();
}

class WsConnectRequested extends WsEvent {
  const WsConnectRequested(this.url);

  final String url;
}

class WsDisconnectRequested extends WsEvent {
  const WsDisconnectRequested({this.fromServer = false, this.reason});

  final bool fromServer;
  final String? reason;
}

class WsSendTextPressed extends WsEvent {
  const WsSendTextPressed(this.message);

  final String message;
}

class WsSendBinaryPressed extends WsEvent {
  const WsSendBinaryPressed(this.bytes);

  final Uint8List bytes;
}

class WsConnected extends WsEvent {
  const WsConnected(this.url);

  final String url;
}

class WsBinaryDataArrived extends WsEvent {
  const WsBinaryDataArrived({
    required this.bytes,
    required this.receivedAt,
    required this.sourceType,
  });

  final Uint8List bytes;
  final DateTime receivedAt;
  final String sourceType;
}

class WsSocketError extends WsEvent {
  const WsSocketError(this.errorMessage);

  final String errorMessage;
}
