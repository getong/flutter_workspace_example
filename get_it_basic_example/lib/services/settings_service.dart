import 'package:flutter/material.dart';

class SettingsService extends ChangeNotifier {
  bool _isDarkMode = false;
  String _userName = 'Flutter User';
  double _fontSize = 14.0;
  bool _isInitialized = false;

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get userName => _userName;
  double get fontSize => _fontSize;
  bool get isInitialized => _isInitialized;

  // Initialize with default or saved settings
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Simulate loading settings from storage
    await Future.delayed(const Duration(milliseconds: 300));
    _isInitialized = true;
    notifyListeners();
  }

  // Theme data getter
  ThemeData get themeData => _isDarkMode
      ? ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.apply(
            fontSizeFactor: _fontSize / 14.0,
          ),
        )
      : ThemeData.light().copyWith(
          textTheme: ThemeData.light().textTheme.apply(
            fontSizeFactor: _fontSize / 14.0,
          ),
        );

  // Setters
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveSettings();
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    _saveSettings();
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    _saveSettings();
    notifyListeners();
  }

  void resetToDefaults() {
    _isDarkMode = false;
    _userName = 'Flutter User';
    _fontSize = 14.0;
    _saveSettings();
    notifyListeners();
  }

  // Simulate saving settings to persistent storage
  Future<void> _saveSettings() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // In a real app, you would save to SharedPreferences, database, etc.
  }
}
