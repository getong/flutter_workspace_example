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
        ..userAgent = 'clean_architecture_dio_example/1.0';

      // Avoid inheriting broken local proxy environment variables.
      client.findProxy = (_) => 'DIRECT';

      return client;
    },
  );

  return dio;
}
