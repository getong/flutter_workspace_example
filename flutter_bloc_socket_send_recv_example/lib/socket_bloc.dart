import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class ReceiveMessage extends SocketEvent {
  final String message;

  ReceiveMessage(this.message);
}

class SocketDisconnect extends SocketEvent {}

class SocketDisconnected extends SocketState {
  SocketDisconnected() : super([]);
}

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  late Socket _socket;
  late StreamSubscription _socketSubscription;

  SocketBloc() : super(SocketInitial()) {
    on<SocketConnect>(_onSocketConnect);
    on<SendMessage>(_onSendMessage);
    // Handle the ReceiveMessage event
    on<ReceiveMessage>(_onReceiveMessage);
    on<SocketDisconnect>(_onSocketDisconnect);
  }

  void _onSocketConnect(SocketConnect event, Emitter<SocketState> emit) async {
    try {
      _socket = await Socket.connect(event.address, event.port);
      _socketSubscription = _socket.listen(
        (List<int> data) {
          final message = String.fromCharCodes(data).trim();
          // Dispatch a ReceiveMessage event instead of adding a state directly
          add(ReceiveMessage(message));
        },
        onError: (error) {
          _socket.destroy();
          emit(SocketInitial());
        },
        onDone: () {
          _socket.destroy();
          emit(SocketInitial());
        },
      );
      emit(SocketConnected([]));
    } catch (e) {
      _socket.destroy();
      emit(SocketInitial());
    }
  }

  void _onSendMessage(SendMessage event, Emitter<SocketState> emit) {
    _socket.write(event.message);
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<SocketState> emit) {
    // Update the list of messages and emit a new state
    final updatedMessages = List<String>.from(state.messages)
      ..add(event.message);
    emit(MessageReceived(updatedMessages));
  }

  void _onSocketDisconnect(
      SocketDisconnect event, Emitter<SocketState> emit) async {
    await _socketSubscription.cancel();
    await _socket.close();
    // Emit the correct state to indicate the socket has been disconnected
    emit(SocketDisconnected());
  }

  @override
  Future<void> close() {
    _socketSubscription.cancel();
    _socket.destroy();
    return super.close();
  }
}
