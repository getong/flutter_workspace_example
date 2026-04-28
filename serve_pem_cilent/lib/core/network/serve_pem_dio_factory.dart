import 'package:dio/dio.dart';

import 'dio_factory_stub.dart' if (dart.library.io) 'dio_factory_io.dart';
import 'server_base_url.dart';

Dio createServePemDio() {
  return createPlatformDio(
    BaseOptions(
      baseUrl: resolveServePemBaseUrl(),
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      responseType: ResponseType.json,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
}
