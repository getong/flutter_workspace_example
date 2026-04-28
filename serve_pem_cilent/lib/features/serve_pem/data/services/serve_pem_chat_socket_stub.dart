import 'serve_pem_chat_socket.dart';

ServePemChatSocket connectPlatformServePemChatSocket(Uri uri) {
  throw UnsupportedError(
    'WebSocket chat is not supported on this platform for $uri.',
  );
}
