import 'package:flutter/foundation.dart';

import '../config/server_defaults.dart';

class SessionStore extends ChangeNotifier {
  SessionStore()
    : _httpBaseUrl = defaultHttpBaseUrl(),
      _webSocketUrl = defaultWebSocketUrl();

  String _httpBaseUrl;
  String _webSocketUrl;

  String get httpBaseUrl => _httpBaseUrl;
  String get webSocketUrl => _webSocketUrl;

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
}
