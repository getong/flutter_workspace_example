import 'dart:async';

import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:widget_layout_example2/features/flutter_chat_ui/data/datasources/flutter_chat_ui_database.dart';

class DriftFlutterChatUiController implements ChatController {
  DriftFlutterChatUiController({required FlutterChatUiDatabase database})
    : _database = database;

  final FlutterChatUiDatabase _database;
  final StreamController<ChatOperation> _operationsController =
      StreamController<ChatOperation>.broadcast();

  List<Message> _messages = <Message>[];
  String _activeSessionId = FlutterChatUiDatabase.defaultSessionId;

  String get activeSessionId => _activeSessionId;

  Future<void> loadInitialMessages({String? sessionId}) async {
    _activeSessionId = sessionId ?? _activeSessionId;
    _messages = await _database.getMessages(_activeSessionId);
    _operationsController.add(ChatOperation.set(_messages, animated: false));
  }

  Future<void> switchSession(String sessionId) async {
    if (_activeSessionId == sessionId) {
      _messages = await _database.getMessages(_activeSessionId);
      _operationsController.add(ChatOperation.set(_messages, animated: false));
      return;
    }

    _activeSessionId = sessionId;
    _messages = await _database.getMessages(_activeSessionId);
    _operationsController.add(ChatOperation.set(_messages, animated: false));
  }

  Future<void> createAndSwitchSession({String? firstMessagePreview}) async {
    final String sessionId = await _database.createNextSession(
      firstMessagePreview: firstMessagePreview,
    );
    await switchSession(sessionId);
  }

  @override
  Future<void> insertMessage(Message message, {int? index}) async {
    await _database.upsertMessage(
      sessionId: _activeSessionId,
      message: message,
    );

    final int insertIndex = index ?? _messages.length;
    if (index == null || index >= _messages.length) {
      _messages.add(message);
    } else {
      _messages.insert(index, message);
    }

    _operationsController.add(ChatOperation.insert(message, insertIndex));
  }

  @override
  Future<void> insertAllMessages(List<Message> messages, {int? index}) async {
    if (messages.isEmpty) {
      return;
    }

    if (index == null || index >= _messages.length) {
      final int startIndex = _messages.length;
      for (final Message message in messages) {
        await _database.upsertMessage(
          sessionId: _activeSessionId,
          message: message,
        );
      }
      _messages.addAll(messages);
      _operationsController.add(ChatOperation.insertAll(messages, startIndex));
      return;
    }

    final List<Message> nextMessages = List<Message>.from(_messages)
      ..insertAll(index, messages);
    await _database.replaceAllMessages(
      sessionId: _activeSessionId,
      messages: nextMessages,
    );
    _messages = nextMessages;
    _operationsController.add(ChatOperation.insertAll(messages, index));
  }

  @override
  Future<void> updateMessage(Message oldMessage, Message newMessage) async {
    final int index = _messages.indexWhere(
      (Message item) => item.id == oldMessage.id,
    );
    if (index == -1) {
      return;
    }

    final Message currentOldMessage = _messages[index];
    if (currentOldMessage == newMessage) {
      return;
    }

    await _database.upsertMessage(
      sessionId: _activeSessionId,
      message: newMessage,
    );
    _messages[index] = newMessage;
    _operationsController.add(
      ChatOperation.update(currentOldMessage, newMessage, index),
    );
  }

  @override
  Future<void> removeMessage(Message message) async {
    final int index = _messages.indexWhere(
      (Message item) => item.id == message.id,
    );
    if (index == -1) {
      return;
    }

    final Message currentMessage = _messages[index];
    await _database.deleteMessage(currentMessage.id);
    _messages.removeAt(index);
    _operationsController.add(ChatOperation.remove(currentMessage, index));
  }

  @override
  Future<void> setMessages(List<Message> messages) async {
    await _database.replaceAllMessages(
      sessionId: _activeSessionId,
      messages: messages,
    );
    _messages = List<Message>.from(messages);
    _operationsController.add(ChatOperation.set(_messages));
  }

  @override
  List<Message> get messages => _messages;

  @override
  Stream<ChatOperation> get operationsStream => _operationsController.stream;

  @override
  void dispose() {
    _operationsController.close();
  }
}
