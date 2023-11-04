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
    // print(
    // "protobuf message type name length: ${readRequest.info_.qualifiedMessageName.length}");
    final headerLen = encode_header_len(
        readRequest.info_.qualifiedMessageName.length, sendData.length);
    final writer = Payload.write()
      ..set(uint32, headerLen)
      ..set(Bytes(readRequest.info_.qualifiedMessageName.length),
          readRequest.info_.qualifiedMessageName.codeUnits)
      ..set(Bytes(sendData.length), sendData);
    final bytes = binarize(writer);
    _socket.add(bytes.toList());
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<SocketState> emit) {
    final reader = Payload.read(event.message);
    final aUint32 = reader.get(uint32);
    final bodyLen = body_len(aUint32);
    final messageIdLen = message_id_len(aUint32);
    final messageId = utf8.decode(reader.get(Bytes(messageIdLen)));
    final aList = reader.get(Bytes(bodyLen));
    String appendMsg;
    switch (messageId) {
      case 'counter_number.ReadRequest':
        appendMsg = ReadRequest.fromBuffer(aList).toString();
        break;
      default:
        print("messageId:${messageId}");
        appendMsg = "unknown message";
        break;
    }

    emit(MessageReceived(state.messages, appendMsg));
  }

  void _onSocketDisconnect(
      SocketDisconnect event, Emitter<SocketState> emit) async {
    await _socketSubscription.cancel();
    await _socket.close();
    // Emit the correct state to indicate the socket has been disconnected
    emit(SocketDisconnected());
  }

  int encode_header_len(int message_id_len, int body_len) {
    return (0 << 31) | (message_id_len << 20) | body_len;
  }

  int body_len(int size) {
    return size & 0xFFFFF;
  }

  int message_id_len(int size) {
    return (size >> 20) & 0x3f;
  }

  @override
  Future<void> close() {
    _socketSubscription.cancel();
    _socket.destroy();
    return super.close();
  }
}
