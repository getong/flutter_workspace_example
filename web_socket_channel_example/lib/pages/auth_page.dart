import 'dart:convert';

import 'package:flutter/material.dart';

import '../service_locator.dart';
import '../services/auth_service.dart';
import '../services/session_store.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  late final SessionStore _sessionStore;
  late final TextEditingController _baseUrlController;
  final TextEditingController _emailController = TextEditingController(
    text: 'demo@example.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'super-secret-password',
  );

  AuthBackend _backend = AuthBackend.supabase;
  bool _isLoading = false;
  String _lastResponse = 'No auth requests sent yet.';

  @override
  void initState() {
    super.initState();
    _sessionStore = getIt<SessionStore>();
    _baseUrlController = TextEditingController(text: _sessionStore.httpBaseUrl);
    _baseUrlController.addListener(_handleBaseUrlChanged);
  }

  @override
  void dispose() {
    _baseUrlController.removeListener(_handleBaseUrlChanged);
    _baseUrlController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleBaseUrlChanged() {
    _sessionStore.updateHttpBaseUrl(_baseUrlController.text);
  }

  Future<void> _submit(bool isSignup) async {
    final baseUrl = _baseUrlController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (baseUrl.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Base URL, email, and password are required.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = isSignup
          ? await _authService.signUp(
              baseUrl: baseUrl,
              email: email,
              password: password,
              backend: _backend,
            )
          : await _authService.signIn(
              baseUrl: baseUrl,
              email: email,
              password: password,
              backend: _backend,
            );

      final prettyBody = const JsonEncoder.withIndent(
        '  ',
      ).convert(result.body);

      if (result.statusCode >= 200 && result.statusCode < 300) {
        _sessionStore.updateHttpBaseUrl(baseUrl);
        if (_backend == AuthBackend.supabase) {
          final accessToken = result.body['access_token'];
          if (accessToken is String && accessToken.trim().isNotEmpty) {
            _sessionStore.storeSupabaseSession(
              accessToken: accessToken,
              email: result.body['email'] as String?,
              httpBaseUrl: baseUrl,
            );
          }
        }
      }

      setState(() {
        _lastResponse = 'HTTP ${result.statusCode}\n$prettyBody';
      });

      if (result.statusCode >= 400) {
        _showSnackBar('Auth request returned HTTP ${result.statusCode}.');
      } else if (_backend == AuthBackend.supabase &&
          result.body['access_token'] is String) {
        _showSnackBar('Supabase access token saved for the WebSocket page.');
      }
    } catch (error) {
      setState(() {
        _lastResponse = 'Request failed\n$error';
      });
      _showSnackBar('Auth request failed: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabel = _backend == AuthBackend.custom
        ? 'Custom Axum auth'
        : 'Supabase Auth';
    final signupPath = _backend == AuthBackend.custom
        ? '/auth/signup'
        : '/auth/supabase/signup';
    final signinPath = _backend == AuthBackend.custom
        ? '/auth/signin'
        : '/auth/supabase/signin';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Axum Auth',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use this page to call the Rust signup/signin handlers directly. The WebSocket page expects a Supabase Auth access token, so sign in with the Supabase backend before opening WSS.',
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<AuthBackend>(
                    segments: const [
                      ButtonSegment(
                        value: AuthBackend.custom,
                        label: Text('Custom'),
                        icon: Icon(Icons.person),
                      ),
                      ButtonSegment(
                        value: AuthBackend.supabase,
                        label: Text('Supabase'),
                        icon: Icon(Icons.verified_user),
                      ),
                    ],
                    selected: {_backend},
                    onSelectionChanged: (selection) {
                      setState(() {
                        _backend = selection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Active backend: $selectedLabel\nSignup: $signupPath\nSignin: $signinPath',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _baseUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Base URL',
                      hintText: 'https://127.0.0.1:3000',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_sessionStore.hasSupabaseAccessToken)
                    Text(
                      'Saved Supabase session for ${_sessionStore.supabaseEmail ?? 'current user'}. The WebSocket page will reuse that access token.',
                      style: const TextStyle(color: Colors.green),
                    ),
                  if (_sessionStore.hasSupabaseAccessToken)
                    const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : () => _submit(true),
                          icon: const Icon(Icons.person_add),
                          label: const Text('Sign Up'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _isLoading ? null : () => _submit(false),
                          icon: const Icon(Icons.login),
                          label: const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Response',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      _lastResponse,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
