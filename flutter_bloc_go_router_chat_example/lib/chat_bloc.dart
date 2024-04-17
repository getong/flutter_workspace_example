// chat_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState()) {
    on<SendMessage>((event, emit) {
        final newState = state.copyWith(messages: List.from(state.messages)..add(event.message));
        emit(newState);
    });
  }
}