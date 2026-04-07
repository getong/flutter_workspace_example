import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../config/local_dev_hosts.dart';

void configureDioForPlatform(Dio dio) {
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient()
        ..idleTimeout = const Duration(seconds: 30)
        ..connectionTimeout = const Duration(seconds: 15)
        ..maxConnectionsPerHost = 5
        ..autoUncompress = true
        ..badCertificateCallback = (certificate, host, port) {
          return isLocalDevTlsHost(host);
        };
      return client;
    },
  );
}
