import 'dart:convert';

import 'serve_pem_chat_socket_stub.dart'
    if (dart.library.io) 'serve_pem_chat_socket_io.dart'
    if (dart.library.html) 'serve_pem_chat_socket_web.dart';

abstract interface class ServePemChatSocket {
  Stream<String> get messages;

  Future<void> sendText(String text);

  Future<void> close([int? code, String? reason]);
}

ServePemChatSocket connectServePemChatSocket(Uri uri) {
  return connectPlatformServePemChatSocket(uri);
}

Stream<String> normalizeSocketMessages(Stream<Object?> source) {
  return source.map((message) {
    if (message is String) {
      return message;
    }
    if (message is List<int>) {
      return utf8.decode(message);
    }
    throw FormatException(
      'Unsupported websocket frame type "${message.runtimeType}".',
    );
  });
}
