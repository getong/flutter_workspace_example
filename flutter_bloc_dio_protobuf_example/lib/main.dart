import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'message.pb.dart'; // The generated file from your .proto

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

// BLoC
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final Dio dio;

  MessageBloc({required this.dio}) : super(MessageInitialState()) {
    on<SendMessageEvent>(_onSendMessageEvent);
  }

  Future<void> _onSendMessageEvent(
      SendMessageEvent event, Emitter<MessageState> emit) async {
    emit(MessageSendingState());
    try {
      final response = await dio.post(
        'http://localhost:8080',
        data: event.message.writeToBuffer(),
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Content-Type': 'application/x-protobuf',
          },
        ),
      );

      // Assume the server response is also a Protobuf binary that can be decoded into MyMessage
      final responseMessage = MyMessage.fromBuffer(response.data);

      emit(MessageResponseState(responseMessage.content));
    } catch (error, stacktrace) {
      // print("error: ${error}, stack: ${stacktrace}");
      emit(MessageErrorState());
    }
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
