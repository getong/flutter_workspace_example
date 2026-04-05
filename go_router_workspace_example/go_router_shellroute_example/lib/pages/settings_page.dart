import 'package:flutter/material.dart';
import '../services/navigation_service.dart';

/// Settings page demonstrating global navigation features
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.settings, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Settings Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Global navigation examples
            const Text(
              'Global Navigation Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Global Logout'),
              subtitle: const Text(
                'Navigate to auth page using _rootNavigatorKey',
              ),
              onTap: () {
                _showLogoutDialog(navigationService);
              },
            ),

            ListTile(
              leading: const Icon(Icons.fullscreen, color: Colors.purple),
              title: const Text('Fullscreen Overlay'),
              subtitle: const Text('Show modal page outside Shell'),
              onTap: () => navigationService.showFullscreenOverlay(),
            ),

            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text('Global Info Dialog'),
              subtitle: const Text('Display dialog from anywhere'),
              onTap: () => _showGlobalInfoDialog(navigationService),
            ),

            ListTile(
              leading: const Icon(
                Icons.notification_important,
                color: Colors.orange,
              ),
              title: const Text('Global Notification'),
              subtitle: const Text('Show global SnackBar'),
              onTap: () => navigationService.showGlobalSnackBar(
                'Global notification example from Settings page!',
              ),
            ),

            const SizedBox(height: 30),

            // Navigation state info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Navigation State Info:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Can Pop: ${navigationService.canPop() ? "Yes" : "No"}'),
                  const SizedBox(height: 4),
                  const Text(
                    'Current page is inside Shell with persistent bottom navigation bar. '
                    'Global navigation state is accessible through _rootNavigatorKey.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(NavigationService navigationService) {
    navigationService.showGlobalDialog(
      dialog: AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text(
          'Are you sure you want to logout? This will navigate to the authentication page.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(navigationService.currentContext!).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(navigationService.currentContext!).pop();
              navigationService.showGlobalSnackBar('Logged out');
              navigationService.navigateToLogin();
            },
            child: const Text('Confirm Logout'),
          ),
        ],
      ),
    );
  }

  void _showGlobalInfoDialog(NavigationService navigationService) {
    navigationService.showGlobalDialog(
      dialog: AlertDialog(
        title: const Text('_rootNavigatorKey Advantages'),
        content: const Text(
          'In the settings page, we can:\n\n'
          '• Navigate without depending on current BuildContext\n'
          '• Show global dialogs and notifications\n'
          '• Check global navigation state\n'
          '• Handle authentication flows\n'
          '• Manage deep links\n\n'
          'These features are all implemented through NavigationService and _rootNavigatorKey.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(navigationService.currentContext!).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
