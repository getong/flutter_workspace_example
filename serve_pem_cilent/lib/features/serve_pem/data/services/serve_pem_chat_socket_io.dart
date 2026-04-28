import 'dart:io';

import 'package:web_socket_channel/io.dart';

import 'serve_pem_chat_socket.dart';

class _IoServePemChatSocket implements ServePemChatSocket {
  final IOWebSocketChannel _channel;

  _IoServePemChatSocket(this._channel);

  @override
  Stream<String> get messages => normalizeSocketMessages(_channel.stream);

  @override
  Future<void> sendText(String text) async {
    _channel.sink.add(text);
  }

  @override
  Future<void> close([int? code, String? reason]) async {
    await _channel.sink.close(code, reason);
  }
}

ServePemChatSocket connectPlatformServePemChatSocket(Uri uri) {
  final client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 5)
    ..idleTimeout = const Duration(seconds: 30)
    ..maxConnectionsPerHost = 6
    ..autoUncompress = true
    ..userAgent = 'serve_pem_client/1.0';

  client.badCertificateCallback = (certificate, host, port) {
    return const {'127.0.0.1', 'localhost', '::1', '10.0.2.2'}.contains(host);
  };
  client.findProxy = (_) => 'DIRECT';

  return _IoServePemChatSocket(
    IOWebSocketChannel.connect(uri, customClient: client),
  );
}
