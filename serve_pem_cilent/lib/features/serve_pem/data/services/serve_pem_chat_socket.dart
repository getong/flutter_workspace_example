import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'serve_pem_chat_socket_stub.dart'
    if (dart.library.io) 'serve_pem_chat_socket_io.dart'
    if (dart.library.html) 'serve_pem_chat_socket_web.dart';

class ServePemWebSocketChannelFactory {
  const ServePemWebSocketChannelFactory();

  WebSocketChannel create(Uri uri) {
    return connectPlatformServePemWebSocketChannel(uri);
  }
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
