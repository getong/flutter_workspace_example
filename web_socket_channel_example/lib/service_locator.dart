import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'services/dio_platform_config.dart'
    if (dart.library.io) 'services/dio_platform_config_io.dart'
    as dio_platform;
import 'services/session_store.dart';
import 'services/supabase_session_store.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(() => _createDio());
  }
  if (!getIt.isRegistered<SessionStore>()) {
    getIt.registerLazySingleton<SessionStore>(SessionStore.new);
  }
  if (!getIt.isRegistered<SupabaseSessionStore>()) {
    getIt.registerLazySingleton<SupabaseSessionStore>(SupabaseSessionStore.new);
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
        'accept': 'application/json',
        'X-Content-Type-Options': 'nosniff',
      },
      validateStatus: (status) =>
          status != null && status >= 200 && status < 500,
    ),
  );

  dio_platform.configureDioForPlatform(dio);

  assert(() {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
    return true;
  }());

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) async {
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
