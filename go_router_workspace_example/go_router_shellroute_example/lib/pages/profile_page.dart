import 'package:flutter/material.dart';
import '../services/navigation_service.dart';

/// Profile page demonstrating global navigation features
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => navigationService.showFullscreenOverlay(),
            icon: const Icon(Icons.fullscreen),
            tooltip: 'Show Fullscreen Overlay',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.person, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Profile Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'This page is part of the ShellRoute.\n'
              'The bottom navigation bar remains visible.',
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
              leading: const Icon(Icons.person_outline, color: Colors.blue),
              title: const Text('User Settings'),
              subtitle: const Text('Navigate using global navigation service'),
              onTap: () => navigationService.navigateToRoute('/settings'),
            ),

            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.green),
              title: const Text('Show Global Info'),
              subtitle: const Text('Display info dialog globally'),
              onTap: () => _showGlobalInfoDialog(navigationService),
            ),

            ListTile(
              leading: const Icon(Icons.notification_add, color: Colors.orange),
              title: const Text('Global Notification'),
              subtitle: const Text('Show global notification message'),
              onTap: () => navigationService.showGlobalSnackBar(
                'Profile notification sent globally!',
              ),
            ),

            ListTile(
              leading: const Icon(Icons.login, color: Colors.purple),
              title: const Text('Authentication Demo'),
              subtitle: const Text('Navigate to auth page globally'),
              onTap: () => navigationService.navigateToLogin(),
            ),

            const SizedBox(height: 30),

            // Profile info section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Navigation Features Available:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('• Global navigation without BuildContext'),
                  const Text('• Persistent shell navigation'),
                  const Text('• Modal overlay presentation'),
                  const Text('• Deep link handling'),
                  const Text('• Authentication flow management'),
                  const SizedBox(height: 8),
                  Text(
                    'Can Navigate Back: ${navigationService.canPop() ? "Yes" : "No"}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGlobalInfoDialog(NavigationService navigationService) {
    navigationService.showGlobalDialog(
      dialog: AlertDialog(
        title: const Text('Profile Information'),
        content: const Text(
          'This profile page demonstrates:\n\n'
          '• Shell route navigation with persistent bottom bar\n'
          '• Global navigation service integration\n'
          '• _rootNavigatorKey usage for global dialogs\n'
          '• Cross-page navigation without context dependency\n\n'
          'All navigation operations use the NavigationService '
          'which leverages _rootNavigatorKey for global access.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(navigationService.currentContext!).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(navigationService.currentContext!).pop();
              navigationService.navigateToRoute('/home');
            },
            child: const Text('Go to Home'),
          ),
        ],
      ),
    );
  }
}
