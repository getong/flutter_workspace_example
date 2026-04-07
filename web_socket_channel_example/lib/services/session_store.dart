import 'package:flutter/foundation.dart';

import '../config/server_defaults.dart';

class SessionStore extends ChangeNotifier {
  SessionStore()
    : _httpBaseUrl = defaultHttpBaseUrl(),
      _webSocketUrl = defaultWebSocketUrl();

  String _httpBaseUrl;
  String _webSocketUrl;
  String? _supabaseAccessToken;
  String? _supabaseEmail;

  String get httpBaseUrl => _httpBaseUrl;
  String get webSocketUrl => _webSocketUrl;
  String? get supabaseAccessToken => _supabaseAccessToken;
  String? get supabaseEmail => _supabaseEmail;
  bool get hasSupabaseAccessToken =>
      (_supabaseAccessToken?.trim().isNotEmpty ?? false);

  void updateHttpBaseUrl(String value) {
    final normalized = normalizeBaseUrl(value);
    final derivedWebSocketUrl = webSocketUrlFromHttpBaseUrl(normalized);

    if (_httpBaseUrl == normalized && _webSocketUrl == derivedWebSocketUrl) {
      return;
    }

    _httpBaseUrl = normalized;
    _webSocketUrl = derivedWebSocketUrl;
    notifyListeners();
  }

  void updateWebSocketUrl(String value) {
    final normalized = normalizeWebSocketUrl(value);
    if (_webSocketUrl == normalized) {
      return;
    }

    _webSocketUrl = normalized;
    notifyListeners();
  }

  void storeSupabaseSession({
    required String accessToken,
    String? email,
    String? httpBaseUrl,
  }) {
    if (httpBaseUrl != null) {
      updateHttpBaseUrl(httpBaseUrl);
    }

    final normalizedToken = accessToken.trim();
    final normalizedEmail = email?.trim();

    if (_supabaseAccessToken == normalizedToken &&
        _supabaseEmail == normalizedEmail) {
      return;
    }

    _supabaseAccessToken = normalizedToken;
    _supabaseEmail = normalizedEmail;
    notifyListeners();
  }

  void updateSupabaseAccessToken(String value) {
    final normalized = value.trim();
    final nextValue = normalized.isEmpty ? null : normalized;
    if (_supabaseAccessToken == nextValue) {
      return;
    }

    _supabaseAccessToken = nextValue;
    notifyListeners();
  }

  void clearSupabaseSession() {
    if (_supabaseAccessToken == null && _supabaseEmail == null) {
      return;
    }

    _supabaseAccessToken = null;
    _supabaseEmail = null;
    notifyListeners();
  }
}
