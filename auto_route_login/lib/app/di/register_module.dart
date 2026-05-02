import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://mock.api.local',
        connectTimeout: const Duration(seconds: 2),
        receiveTimeout: const Duration(seconds: 2),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await Future<void>.delayed(const Duration(milliseconds: 500));

          if (options.path == '/login' || options.path == '/signup') {
            final payload = Map<String, dynamic>.from(
              options.data as Map? ?? <String, dynamic>{},
            );
            final email = (payload['email'] as String? ?? '').trim();
            final password = (payload['password'] as String? ?? '').trim();

            if (email.isEmpty || password.isEmpty) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response<Map<String, dynamic>>(
                    requestOptions: options,
                    statusCode: 400,
                    data: const <String, dynamic>{
                      'message': 'Email and password are required.',
                    },
                  ),
                  type: DioExceptionType.badResponse,
                ),
              );
              return;
            }

            if (password.length < 6) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response<Map<String, dynamic>>(
                    requestOptions: options,
                    statusCode: 400,
                    data: const <String, dynamic>{
                      'message': 'Password must be at least 6 characters.',
                    },
                  ),
                  type: DioExceptionType.badResponse,
                ),
              );
              return;
            }

            if (options.path == '/login' && email != 'demo@demo.com') {
              handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response<Map<String, dynamic>>(
                    requestOptions: options,
                    statusCode: 401,
                    data: const <String, dynamic>{
                      'message': 'Unknown account. Use demo@demo.com.',
                    },
                  ),
                  type: DioExceptionType.badResponse,
                ),
              );
              return;
            }

            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: <String, dynamic>{
                  'id': email.hashCode.toString(),
                  'name': email.split('@').first,
                  'email': email,
                  'token': 'token-${email.hashCode}',
                },
              ),
            );
            return;
          }

          handler.next(options);
        },
      ),
    );

    return dio;
  }
}
