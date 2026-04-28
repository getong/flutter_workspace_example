import 'package:web_socket_channel/html.dart';

import 'serve_pem_chat_socket.dart';

class _WebServePemChatSocket implements ServePemChatSocket {
  final HtmlWebSocketChannel _channel;

  _WebServePemChatSocket(this._channel);

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
  return _WebServePemChatSocket(HtmlWebSocketChannel.connect(uri.toString()));
}
