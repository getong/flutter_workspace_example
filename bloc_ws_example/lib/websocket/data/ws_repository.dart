import 'package:web_socket_channel/web_socket_channel.dart';

class WsRepository {
  WebSocketChannel? _channel;

  Future<Stream<dynamic>> connect(String url) async {
    final uri = _normalizeWebSocketUri(url);
    final channel = WebSocketChannel.connect(uri);
    await channel.ready;
    _channel = channel;
    return channel.stream;
  }

  void send(String message) {
    _channel?.sink.add(message);
  }

  Future<void> disconnect() async {
    final channel = _channel;
    _channel = null;
    await channel?.sink.close();
  }

  Uri _normalizeWebSocketUri(String rawUrl) {
    final trimmedUrl = rawUrl.trim();
    if (trimmedUrl.isEmpty) {
      throw const FormatException('WebSocket URL is empty.');
    }

    final urlWithScheme = trimmedUrl.contains('://')
        ? trimmedUrl
        : 'ws://$trimmedUrl';

    final uri = Uri.parse(urlWithScheme);
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'ws' && scheme != 'wss') {
      throw const FormatException('Only ws:// and wss:// URLs are supported.');
    }
    if (uri.host.isEmpty) {
      throw const FormatException('WebSocket URL must include a host.');
    }
    return uri;
  }
}
