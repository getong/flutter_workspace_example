import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

Dio createPlatformDio(BaseOptions options) {
  final dio = Dio(options);

  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 5)
        ..idleTimeout = const Duration(seconds: 30)
        ..maxConnectionsPerHost = 6
        ..autoUncompress = true
        ..userAgent = 'serve_pem_client/1.0';

      // The Rust demo serves HTTPS with a self-signed certificate for local
      // loopback hosts, so desktop, simulator, and emulator builds need to
      // accept that certificate explicitly during development.
      client.badCertificateCallback = (certificate, host, port) {
        return const {
          '127.0.0.1',
          'localhost',
          '::1',
          '10.0.2.2',
        }.contains(host);
      };
      client.findProxy = (_) => 'DIRECT';

      return client;
    },
  );

  return dio;
}
