import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'socket_event.dart';
import 'socket_state.dart';
import 'dart:convert';
import 'messages/counter_number.pb.dart';
import 'messages/mandelbrot.pb.dart';
import 'dart:typed_data';
import 'package:binarize/binarize.dart';
import 'dart:math';

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
    var readRequest;
    var rng = Random();
    switch (rng.nextInt(5)) {
      case 0:
        readRequest = ReadRequest(
          letter: event.message,
          beforeNumber: 1,
          dummyOne: 1,
          dummyTwo: SampleSchema(
            sampleFieldOne: true,
            sampleFieldTwo: false,
          ),
          dummyThree: [3, 4, 5],
        );
        break;
      case 1:
        readRequest = StateSignal(
          id: 1,
          currentScale: 2.0,
        );
        break;
      case 2:
        readRequest = ReadResponse(
          afterNumber: 1,
          dummyOne: 2,
          dummyTwo: SampleSchema(
            sampleFieldOne: true,
            sampleFieldTwo: true,
          ),
          dummyThree: [4],
        );
        break;
      default:
        readRequest = SampleSchema(
          sampleFieldOne: true,
          sampleFieldTwo: true,
        );
    }

    List<int> sendData = readRequest.writeToBuffer();
    final messageId = readRequest.info_.qualifiedMessageName.codeUnits;
    final headerLen = encode_header_len(messageId.length, sendData.length);
    final writer = Payload.write()
      ..set(uint32, headerLen)
      ..set(Bytes(messageId.length), messageId)
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
        appendMsg = ReadRequest().info_.qualifiedMessageName +
            ' ' +
            ReadRequest.fromBuffer(aList).toString();
        break;
      case 'counter_number.ReadResponse':
        appendMsg = ReadResponse().info_.qualifiedMessageName +
            ' ' +
            ReadResponse.fromBuffer(aList).toString();
        break;
      case 'counter_number.SampleSchema':
        appendMsg = SampleSchema().info_.qualifiedMessageName +
            ' ' +
            SampleSchema.fromBuffer(aList).toString();
        break;
      case 'mandelbrot.StateSignal':
        appendMsg = StateSignal().info_.qualifiedMessageName +
            ' ' +
            StateSignal.fromBuffer(aList).toString();
        break;
      default:
        print("messageId:${messageId}");
        appendMsg = "unknown message";
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
