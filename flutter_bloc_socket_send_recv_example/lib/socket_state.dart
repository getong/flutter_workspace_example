// Socket States
abstract class SocketState {
  final List<String> messages;

  SocketState(this.messages);
}

class SocketInitial extends SocketState {
  SocketInitial() : super([]);
}

class SocketConnected extends SocketState {
  SocketConnected(List<String> messages) : super(messages);
}

class MessageReceived extends SocketState {
  MessageReceived(List<String> messages) : super(messages);
}

class SocketDisconnected extends SocketState {
  SocketDisconnected() : super([]);
}
