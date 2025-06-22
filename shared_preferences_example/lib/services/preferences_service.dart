import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling SharedPreferences operations
class PreferencesService {
  static const String _counterKey = 'counter';
  static const String _isDarkModeKey = 'isDarkMode';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';

  /// Get counter value
  static Future<int> getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_counterKey) ?? 0;
  }

  /// Set counter value
  static Future<void> setCounter(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, value);
  }

  /// Remove counter value
  static Future<void> removeCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_counterKey);
  }

  /// Get dark mode preference
  static Future<bool> getDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false;
  }

  /// Set dark mode preference
  static Future<void> setDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, value);
  }

  /// Get username
  static Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? '';
  }

  /// Set username
  static Future<void> setUsername(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, value);
  }

  /// Remove username
  static Future<void> removeUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
  }

  /// Get email
  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? '';
  }

  /// Set email
  static Future<void> setEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, value);
  }

  /// Remove email
  static Future<void> removeEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
  }

  /// Clear all preferences
  static Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
