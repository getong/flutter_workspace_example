import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/services/serve_pem_chat_service.dart';
import '../../domain/entities/serve_pem_chat_event.dart';

enum ServePemChatStatus { disconnected, connecting, connected }

class ServePemChatState {
  final ServePemChatStatus status;
  final String room;
  final String user;
  final Uri? socketUri;
  final int? memberCount;
  final List<ServePemChatEvent> events;

  const ServePemChatState({
    required this.status,
    required this.room,
    required this.user,
    required this.socketUri,
    required this.memberCount,
    required this.events,
  });

  const ServePemChatState.initial()
    : status = ServePemChatStatus.disconnected,
      room = 'general',
      user = 'alice',
      socketUri = null,
      memberCount = null,
      events = const [];

  bool get isConnected => status == ServePemChatStatus.connected;
  bool get isBusy => status == ServePemChatStatus.connecting;
}

@injectable
class ChatCubit extends Cubit<ServePemChatState> {
  final ServePemChatService _chatService;
  late final StreamSubscription<ServePemChatEvent> _eventsSubscription;

  ChatCubit(this._chatService) : super(const ServePemChatState.initial()) {
    _eventsSubscription = _chatService.events.listen(_onChatEvent);
  }

  Future<void> connect({required String room, required String user}) async {
    emit(
      ServePemChatState(
        status: ServePemChatStatus.connecting,
        room: room.trim(),
        user: user.trim(),
        socketUri: null,
        memberCount: null,
        events: const [],
      ),
    );

    try {
      final session = await _chatService.connect(room: room, user: user);
      emit(
        ServePemChatState(
          status: ServePemChatStatus.connected,
          room: session.room,
          user: session.user,
          socketUri: session.uri,
          memberCount: state.memberCount,
          events: state.events,
        ),
      );
    } catch (error) {
      emit(
        ServePemChatState(
          status: ServePemChatStatus.disconnected,
          room: room.trim(),
          user: user.trim(),
          socketUri: null,
          memberCount: null,
          events: [
            ServePemChatEvent(
              type: ServePemChatEventType.error,
              label: 'Connection error',
              message: error.toString().replaceFirst('Exception: ', ''),
              timestamp: DateTime.now(),
            ),
          ],
        ),
      );
    }
  }

  Future<void> disconnect() => _chatService.disconnect();

  Future<void> sendMessage(String message) async {
    try {
      await _chatService.sendMessage(message);
    } catch (error) {
      _onChatEvent(
        ServePemChatEvent(
          type: ServePemChatEventType.error,
          label: 'Send error',
          message: error.toString().replaceFirst('Exception: ', ''),
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  void _onChatEvent(ServePemChatEvent event) {
    final nextEvents = List<ServePemChatEvent>.unmodifiable([
      ...state.events,
      event,
    ]);

    final nextStatus = switch (event.type) {
      ServePemChatEventType.disconnected => ServePemChatStatus.disconnected,
      ServePemChatEventType.welcome ||
      ServePemChatEventType.presence ||
      ServePemChatEventType.chatMessage => ServePemChatStatus.connected,
      _ => state.status,
    };

    emit(
      ServePemChatState(
        status: nextStatus,
        room: event.room ?? state.room,
        user: state.user,
        socketUri: nextStatus == ServePemChatStatus.disconnected
            ? null
            : state.socketUri,
        memberCount: event.memberCount ?? state.memberCount,
        events: nextEvents,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _eventsSubscription.cancel();
    await _chatService.dispose();
    return super.close();
  }
}
