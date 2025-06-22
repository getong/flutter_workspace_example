import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/preferences_service.dart';

/// Settings page demonstrating theme preference storage
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  /// Load theme preference from SharedPreferences
  _loadThemePreference() async {
    bool isDarkMode = await PreferencesService.getDarkMode();
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  /// Save theme preference to SharedPreferences
  _saveThemePreference(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    await PreferencesService.setDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Enable dark theme'),
              value: _isDarkMode,
              onChanged: _saveThemePreference,
            ),
            const SizedBox(height: 20),
            const Text(
              'This setting is saved using SharedPreferences',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
