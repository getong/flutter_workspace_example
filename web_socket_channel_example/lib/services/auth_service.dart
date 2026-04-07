import 'dart:convert';

import 'package:dio/dio.dart';

import '../service_locator.dart';

enum AuthBackend { custom, supabase }

class AuthResult {
  const AuthResult({required this.statusCode, required this.body});

  final int statusCode;
  final Map<String, dynamic> body;
}

class AuthService {
  AuthService() : _dio = getIt<Dio>();

  final Dio _dio;

  Future<AuthResult> signUp({
    required String baseUrl,
    required String email,
    required String password,
    required AuthBackend backend,
  }) {
    return _post(
      baseUrl: baseUrl,
      path: backend == AuthBackend.custom
          ? '/auth/signup'
          : '/auth/supabase/signup',
      email: email,
      password: password,
    );
  }

  Future<AuthResult> signIn({
    required String baseUrl,
    required String email,
    required String password,
    required AuthBackend backend,
  }) {
    return _post(
      baseUrl: baseUrl,
      path: backend == AuthBackend.custom
          ? '/auth/signin'
          : '/auth/supabase/signin',
      email: email,
      password: password,
    );
  }

  Future<AuthResult> _post({
    required String baseUrl,
    required String path,
    required String email,
    required String password,
  }) async {
    final baseUri = Uri.parse(baseUrl.trim());
    final requestUri = baseUri.resolve(path);

    try {
      final response = await _dio.post<String>(
        requestUri.toString(),
        data: {'email': email.trim(), 'password': password},
      );

      return AuthResult(
        statusCode: response.statusCode ?? 0,
        body: _decodeBody(response.data),
      );
    } on DioException catch (error) {
      final response = error.response;
      if (response != null) {
        return AuthResult(
          statusCode: response.statusCode ?? 0,
          body: _decodeBody(response.data as String?),
        );
      }
      rethrow;
    }
  }

  Map<String, dynamic> _decodeBody(String? responseBody) {
    final body = responseBody ?? '';
    if (body.isEmpty) {
      return <String, dynamic>{};
    }

    return jsonDecode(body) as Map<String, dynamic>;
  }
}
