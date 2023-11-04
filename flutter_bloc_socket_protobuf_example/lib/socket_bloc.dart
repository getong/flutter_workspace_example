import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'socket_event.dart';
import 'socket_state.dart';
import 'dart:convert';
import 'messages/counter_number.pb.dart';
import 'dart:typed_data';
import 'package:binarize/binarize.dart';

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
          // final message = utf8.decode(data);
          // Dispatch a ReceiveMessage event instead of adding a state directly
          add(ReceiveMessage(data));
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
    // _socket.write(event.message);
    final readRequest = ReadRequest(
      letter: event.message,
      beforeNumber: 1,
      dummyOne: 1,
      dummyTwo: SampleSchema(
        sampleFieldOne: true,
        sampleFieldTwo: false,
      ),
      dummyThree: [3, 4, 5],
    );
    List<int> sendData = readRequest.writeToBuffer();
    final writer = Payload.write()
      ..set(uint32, sendData.length)
      ..set(Bytes(sendData.length), sendData);
    final bytes = binarize(writer);
    _socket.add(bytes.toList());
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<SocketState> emit) {
    // Update the list of messages and emit a new state
    // final updatedMessages = List<String>.from(state.messages)
    //   ..add(event.message);
    // emit(MessageReceived(updatedMessages));
    final reader = Payload.read(event.message);
    final aUint32 = reader.get(uint32);
    final aList = reader.get(Bytes(aUint32));
    emit(MessageReceived(ReadRequest.fromBuffer(aList).toString()));
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
