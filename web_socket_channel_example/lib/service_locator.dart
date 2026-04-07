import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(() => _createDio());
  }
}

Dio _createDio() {
  final dio = Dio(
    BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.plain,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        // Prevent MIME sniffing
        'X-Content-Type-Options': 'nosniff',
      },
      // Only allow 2xx and 3xx status codes as success
      validateStatus: (status) =>
          status != null && status >= 200 && status < 400,
    ),
  );

  // Configure HTTP client with keep-alive and security settings
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      // Enable keep-alive for connection reuse
      client.idleTimeout = const Duration(seconds: 30);
      client.connectionTimeout = const Duration(seconds: 15);
      // Limit max connections per host to avoid resource exhaustion
      client.maxConnectionsPerHost = 5;
      // Auto-decompress response
      client.autoUncompress = true;
      return client;
    },
  );

  // Log interceptor for debug builds only
  assert(() {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
    return true;
  }());

  // Retry & error-handling interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) async {
        // Retry once on connection timeout
        if (error.type == DioExceptionType.connectionTimeout &&
            (error.requestOptions.extra['retried'] != true)) {
          error.requestOptions.extra['retried'] = true;
          try {
            final response = await dio.fetch(error.requestOptions);
            return handler.resolve(response);
          } catch (_) {
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
}
