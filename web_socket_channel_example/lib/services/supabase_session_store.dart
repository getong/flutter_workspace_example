import 'package:flutter/foundation.dart';

class SupabaseSessionStore extends ChangeNotifier {
  String? _accessToken;
  String? _email;

  String? get accessToken => _accessToken;
  String? get email => _email;
  bool get hasAccessToken => (_accessToken?.trim().isNotEmpty ?? false);

  void storeSession({required String accessToken, String? email}) {
    final normalizedToken = accessToken.trim();
    final normalizedEmail = email?.trim();

    if (_accessToken == normalizedToken && _email == normalizedEmail) {
      return;
    }

    _accessToken = normalizedToken;
    _email = normalizedEmail;
    notifyListeners();
  }

  void updateAccessToken(String value) {
    final normalized = value.trim();
    final nextValue = normalized.isEmpty ? null : normalized;

    if (_accessToken == nextValue) {
      return;
    }

    _accessToken = nextValue;
    notifyListeners();
  }

  void clear() {
    if (_accessToken == null && _email == null) {
      return;
    }

    _accessToken = null;
    _email = null;
    notifyListeners();
  }
}
