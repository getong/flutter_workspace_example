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

class MessageErrorState extends MessageState {
  final String? message;
  MessageErrorState({this.message});
}

class MessageResponseState extends MessageState {
  final String responseContent;
  MessageResponseState(this.responseContent);
}

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final Dio dio;
  static const String serverUrl = 'http://localhost:8080/message';
  static const bool useMockMode = false; // Set to true to test without a server

  MessageBloc({required this.dio}) : super(MessageInitialState()) {
    on<SendMessageEvent>(_onSendMessageEvent);
  }

  Future<void> _onSendMessageEvent(
      SendMessageEvent event, Emitter<MessageState> emit) async {
    emit(MessageSendingState());

    try {
      final messageBytes = event.message.writeToBuffer();
      
      if (useMockMode) {
        // Mock mode for testing without a server
        await Future.delayed(Duration(milliseconds: 500));
        emit(MessageResponseState('Mock response: Message received (${messageBytes.length} bytes)'));
        return;
      }

      // Send protobuf encoded message via HTTP POST
      final response = await dio.post(
        serverUrl,
        data: messageBytes,
        options: Options(
          contentType: 'application/octet-stream',
          responseType: ResponseType.bytes,
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      final responseString = String.fromCharCodes(response.data as List<int>);
      emit(MessageResponseState(responseString));
    } on DioException catch (error) {
      final errorMsg = _getErrorMessage(error);
      print("DIO error: $errorMsg");
      emit(MessageErrorState(message: errorMsg));
    } catch (error, stacktrace) {
      print("error: $error, stack: $stacktrace");
      emit(MessageErrorState(message: error.toString()));
    }
  }

  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Is the server running on $serverUrl?';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Server responded too slowly.';
      case DioExceptionType.connectionError:
        return 'Connection error. Make sure the server is running on $serverUrl';
      case DioExceptionType.badResponse:
        return 'Bad response from server: ${error.response?.statusCode}';
      case DioExceptionType.unknown:
        return 'Unknown error: ${error.message}';
      default:
        return 'Error: ${error.message}';
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
            final errorMsg = state.message ?? 'Failed to send message';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMsg),
                duration: Duration(seconds: 3),
              ),
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
