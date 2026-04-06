import 'dart:convert';

import 'package:http/http.dart' as http;

enum AuthBackend { custom, supabase }

class AuthResult {
  const AuthResult({required this.statusCode, required this.body});

  final int statusCode;
  final Map<String, dynamic> body;
}

class AuthService {
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
    final response = await http.post(
      url,
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'email': email.trim(), 'password': password}),
    );

    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    return AuthResult(statusCode: response.statusCode, body: decoded);
  }
}
