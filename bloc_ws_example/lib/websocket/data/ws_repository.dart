import 'package:web_socket_channel/web_socket_channel.dart';

class WsRepository {
  WebSocketChannel? _channel;

  Future<Stream<dynamic>> connect(String url) async {
    final channel = WebSocketChannel.connect(Uri.parse(url));
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
}
