import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 600;

        Widget settingsList = ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSettingsTile('Account', Icons.person, isWideScreen),
            _buildSettingsTile(
              'Notifications',
              Icons.notifications,
              isWideScreen,
            ),
            _buildSettingsTile('Privacy', Icons.lock, isWideScreen),
            _buildSettingsTile('Display', Icons.brightness_6, isWideScreen),
            _buildSettingsTile('Language', Icons.language, isWideScreen),
            _buildSettingsTile('Help', Icons.help, isWideScreen),
          ],
        );

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.indigo.shade700,
              child: Column(
                children: [
                  Text(
                    '⚙️ ${isWideScreen ? 'WIDE SCREEN SETTINGS' : 'COMPACT SETTINGS'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Layout: ${isWideScreen ? 'Side-by-side' : 'Stacked'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isWideScreen
                  ? Row(
                      children: [
                        Expanded(flex: 1, child: settingsList),
                        const VerticalDivider(),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.settings,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Settings Details',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Select a setting from the left panel to view details here.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : settingsList,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, bool isWideScreen) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title),
        subtitle: isWideScreen ? Text('$title configuration options') : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
