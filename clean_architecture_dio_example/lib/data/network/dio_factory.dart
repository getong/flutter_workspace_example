import 'package:dio/dio.dart';

import 'dio_factory_stub.dart' if (dart.library.io) 'dio_factory_io.dart';

Dio createConfiguredDio() {
  return createPlatformDio(
    BaseOptions(
      baseUrl: 'https://v1.hitokoto.cn',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      persistentConnection: true,
      responseType: ResponseType.json,
      headers: const {
        'Accept': 'application/json',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip',
      },
    ),
  );
}
