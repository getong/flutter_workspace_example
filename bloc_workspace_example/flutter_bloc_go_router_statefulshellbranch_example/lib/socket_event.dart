// Socket Events
abstract class SocketEvent {}

class SocketConnect extends SocketEvent {
  final String address;
  final int port;

  SocketConnect(this.address, this.port);
}

class SendMessage extends SocketEvent {
  final String message;

  SendMessage(this.message);
}

class ReceiveMessage extends SocketEvent {
  final List<int> message;

  ReceiveMessage(this.message);
}

class SocketDisconnect extends SocketEvent {}
