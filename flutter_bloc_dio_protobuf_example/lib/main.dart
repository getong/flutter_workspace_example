import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'message.pb.dart'; // The generated file from your .proto
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

// Event
abstract class MessageEvent {}

class SendMessageEvent extends MessageEvent {
  final MyMessage message;
  SendMessageEvent(this.message);
}

// State
abstract class MessageState {}

class MessageInitialState extends MessageState {}

class MessageSendingState extends MessageState {}

class MessageSentState extends MessageState {}

class MessageErrorState extends MessageState {}

class MessageResponseState extends MessageState {
  final String responseContent;
  MessageResponseState(this.responseContent);
}

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final Dio dio;
  Socket? socket; // Class-level variable for the socket
  StreamSubscription<Uint8List>?
      subscription; // Add this line for the subscription

  MessageBloc({required this.dio}) : super(MessageInitialState()) {
    on<SendMessageEvent>(_onSendMessageEvent);
  }

  Future<void> _onSendMessageEvent(
      SendMessageEvent event, Emitter<MessageState> emit) async {
    emit(MessageSendingState());

    try {
      if (socket == null) {
        socket = await Socket.connect('localhost', 8080);
      }

      final messageBytes = event.message.writeToBuffer();
      socket!.add(messageBytes); // Send message bytes

      List<int> responseBytes = [];

      // Cancel any existing subscription
      await subscription?.cancel();
      subscription = socket!.listen(
        (data) {
          responseBytes.addAll(data);
        },
        onDone: () {
          final responseString = String.fromCharCodes(responseBytes);
          emit(MessageResponseState(responseString));
          // Consider closing the socket here if no more communication is expected
        },
        onError: (error) {
          print("Socket error: $error");
          emit(MessageErrorState());
        },
      );
      final responseString = String.fromCharCodes(responseBytes);
      emit(MessageResponseState(responseString));
    } catch (error, stacktrace) {
      print("error: ${error}, stack: ${stacktrace}");
      emit(MessageErrorState());
    }
    // Do not close the socket immediately here; it should be managed based on your app's logic
  }
}

void main() {
  final dio = Dio(); // Create a Dio instance
  runApp(MyApp(dio: dio));
}

class MyApp extends StatelessWidget {
  final Dio dio;

  MyApp({required this.dio});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLoC Dio Protobuf Example',
      home: BlocProvider(
        create: (_) => MessageBloc(dio: dio),
        child: MessageWidget(),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Protobuf Message')),
      body: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {
          print("state is ${state}");
          if (state is MessageErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to send message')),
            );
          }
        },
        builder: (context, state) {
          if (state is MessageResponseState) {
            return Center(child: Text('Response: ${state.responseContent}'));
          } else if (state is MessageSendingState) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  final message = MyMessage()..content = 'Hello, Protobuf!';
                  context.read<MessageBloc>().add(SendMessageEvent(message));
                },
                child: Text('Send Message'),
              ),
            );
          }
        },
      ),
    );
  }
}
