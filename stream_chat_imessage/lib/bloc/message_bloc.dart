import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

// Events
abstract class MessageEvent {}

class LoadMessages extends MessageEvent {
  final Channel channel;
  LoadMessages(this.channel);
}

class SendMessage extends MessageEvent {
  final String text;
  final List<Attachment>? attachments;

  SendMessage(this.text, {this.attachments});
}

class LoadMoreMessages extends MessageEvent {}

// States
abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<Message> messages;
  final bool hasMore;

  MessageLoaded({required this.messages, this.hasMore = false});
}

class MessageError extends MessageState {
  final String message;
  MessageError(this.message);
}

class MessageSending extends MessageState {
  final List<Message> messages;
  MessageSending(this.messages);
}

// BLoC
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  Channel? _channel;
  StreamSubscription<List<Message>>? _messagesSubscription;

  MessageBloc() : super(MessageInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<LoadMoreMessages>(_onLoadMoreMessages);
  }

  void _onLoadMessages(LoadMessages event, Emitter<MessageState> emit) async {
    emit(MessageLoading());

    try {
      _channel = event.channel;

      // Listen to message updates
      _messagesSubscription?.cancel();
      _messagesSubscription = _channel!.state!.messagesStream.listen((
        messages,
      ) {
        emit(MessageLoaded(messages: messages));
      });

      // Emit initial messages
      emit(MessageLoaded(messages: _channel!.state!.messages));
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  void _onSendMessage(SendMessage event, Emitter<MessageState> emit) async {
    if (_channel == null) return;

    try {
      final currentMessages = _channel!.state!.messages;
      emit(MessageSending(currentMessages));

      final message = Message(
        text: event.text.trim(),
        attachments: event.attachments ?? [],
      );

      await _channel!.sendMessage(message);
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  void _onLoadMoreMessages(
    LoadMoreMessages event,
    Emitter<MessageState> emit,
  ) async {
    if (_channel != null) {
      try {
        await _channel!.query(
          messagesPagination: PaginationParams(
            limit: 20,
            lessThan: _channel!.state!.messages.isNotEmpty
                ? _channel!.state!.messages.last.id
                : null,
          ),
        );
      } catch (e) {
        emit(MessageError(e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
