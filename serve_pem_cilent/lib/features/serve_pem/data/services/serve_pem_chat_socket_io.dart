import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel connectPlatformServePemWebSocketChannel(Uri uri) {
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

  return IOWebSocketChannel.connect(uri, customClient: client);
}
