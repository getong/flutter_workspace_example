import 'dart:convert';

import 'package:dio/dio.dart';

enum AuthBackend { custom, supabase }

class AuthResult {
  const AuthResult({required this.statusCode, required this.body});

  final int statusCode;
  final Map<String, dynamic> body;
}

class AuthService {
  AuthService({Dio? dio}) : _dio = dio ?? Dio();

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
    final url = Uri.parse('${baseUrl.trim()}$path');
    final response = await _dio.post<String>(
      url.toString(),
      data: {'email': email.trim(), 'password': password},
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );

    final responseBody = response.data ?? '';
    final decoded = responseBody.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(responseBody) as Map<String, dynamic>;

    return AuthResult(statusCode: response.statusCode ?? 0, body: decoded);
  }
}
