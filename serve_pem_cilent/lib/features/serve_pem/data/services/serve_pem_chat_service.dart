import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../domain/entities/serve_pem_chat_event.dart';
import 'serve_pem_chat_socket.dart';
import 'serve_pem_chat_uri.dart';

class ServePemChatSession {
  final String room;
  final String user;
  final Uri uri;

  const ServePemChatSession({
    required this.room,
    required this.user,
    required this.uri,
  });
}

@injectable
class ServePemChatService {
  final _eventsController = StreamController<ServePemChatEvent>.broadcast();

  ServePemChatSocket? _socket;
  StreamSubscription<String>? _socketSubscription;
  String? _activeUser;

  Stream<ServePemChatEvent> get events => _eventsController.stream;

  Future<ServePemChatSession> connect({
    required String room,
    required String user,
  }) async {
    final normalizedRoom = normalizeServePemChatRoom(room);
    final normalizedUser = _normalizeUser(user);
    await disconnect(emitEvent: false);

    final uri = buildServePemChatUri(room: normalizedRoom);
    final socket = connectServePemChatSocket(uri);

    _socket = socket;
    _activeUser = normalizedUser;
    _socketSubscription = socket.messages.listen(
      _handleRawMessage,
      onError: (Object error, StackTrace stackTrace) {
        _eventsController.add(
          ServePemChatEvent(
            type: ServePemChatEventType.error,
            label: 'Connection error',
            message: error.toString().replaceFirst('Exception: ', ''),
            timestamp: DateTime.now(),
          ),
        );
      },
      onDone: () {
        _eventsController.add(
          ServePemChatEvent.disconnected('The websocket connection closed.'),
        );
      },
      cancelOnError: false,
    );

    _eventsController.add(
      ServePemChatEvent.localInfo('Connecting to $uri as "$normalizedUser".'),
    );

    return ServePemChatSession(
      room: normalizedRoom,
      user: normalizedUser,
      uri: uri,
    );
  }

  Future<void> sendMessage(String message) async {
    final socket = _socket;
    if (socket == null) {
      throw const FormatException('Connect to a room before sending messages.');
    }

    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty || trimmedMessage.length > 2048) {
      throw const FormatException(
        'Message is required and must be 2048 characters or fewer.',
      );
    }

    final user = _activeUser ?? 'Anonymous';
    final payload = jsonEncode({
      'event': 'chat_message',
      'payload': {'user': user, 'msg': trimmedMessage},
    });

    await socket.sendText(payload);
  }

  Future<void> disconnect({bool emitEvent = true}) async {
    final subscription = _socketSubscription;
    _socketSubscription = null;
    await subscription?.cancel();

    final socket = _socket;
    _socket = null;
    _activeUser = null;
    if (socket != null) {
      await socket.close();
    }

    if (emitEvent) {
      _eventsController.add(
        ServePemChatEvent.disconnected('Disconnected from the chat room.'),
      );
    }
  }

  Future<void> dispose() async {
    await disconnect(emitEvent: false);
    await _eventsController.close();
  }

  void _handleRawMessage(String raw) {
    try {
      _eventsController.add(ServePemChatEvent.fromRawMessage(raw));
    } on FormatException catch (error) {
      _eventsController.add(
        ServePemChatEvent(
          type: ServePemChatEventType.error,
          label: 'Malformed event',
          message: error.message,
          rawMessage: raw,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  String _normalizeUser(String user) {
    final trimmed = user.trim();
    if (trimmed.isEmpty || trimmed.length > 64) {
      throw const FormatException(
        'User is required and must be 64 characters or fewer.',
      );
    }

    return trimmed;
  }
}
