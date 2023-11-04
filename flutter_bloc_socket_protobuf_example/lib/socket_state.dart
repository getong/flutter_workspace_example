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
  MessageReceived(List<String> previousMessages, String newMessage)
      : super(List.from(previousMessages)..add(newMessage));
}
// class MessageReceived extends SocketState {
//   MessageReceived(String messages) : super([messages]);
// }

class SocketDisconnected extends SocketState {
  SocketDisconnected() : super([]);
}
