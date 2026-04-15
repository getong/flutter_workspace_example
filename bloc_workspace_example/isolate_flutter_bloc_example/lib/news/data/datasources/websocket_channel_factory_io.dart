import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel connectWebSocketChannel(Uri uri) {
  final client = HttpClient()
    ..idleTimeout = const Duration(seconds: 30)
    ..connectionTimeout = const Duration(seconds: 15)
    ..maxConnectionsPerHost = 5
    ..autoUncompress = true;

  return IOWebSocketChannel.connect(
    uri,
    connectTimeout: const Duration(seconds: 15),
    customClient: client,
  );
}
