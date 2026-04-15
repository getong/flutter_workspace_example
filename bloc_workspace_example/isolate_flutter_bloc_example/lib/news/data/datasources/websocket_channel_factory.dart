import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel connectWebSocketChannel(Uri uri) {
  return WebSocketChannel.connect(uri);
}
