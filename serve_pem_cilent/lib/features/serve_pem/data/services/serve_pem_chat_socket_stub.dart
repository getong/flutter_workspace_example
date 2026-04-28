import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel connectPlatformServePemWebSocketChannel(Uri uri) {
  throw UnsupportedError(
    'WebSocket chat is not supported on this platform for $uri.',
  );
}
