import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/navigation_service.dart';

/// Home page demonstrating comprehensive _rootNavigatorKey usage
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => navigationService.navigateToLogin(),
            icon: const Icon(Icons.login),
            tooltip: 'Global Auth Navigation',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'GoRouter _rootNavigatorKey Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Basic navigation examples
            _buildSectionTitle('Basic Navigation Examples'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/home/details/123'),
              child: const Text('Go to Details (ID: 123)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.push('/home/details/456'),
              child: const Text('Push Details (ID: 456)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () =>
                  context.goNamed('details', pathParameters: {'id': '789'}),
              child: const Text('Named Route Details (ID: 789)'),
            ),

            const SizedBox(height: 30),

            // Global navigation examples using NavigationService
            _buildSectionTitle('Global Navigation (_rootNavigatorKey)'),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => navigationService.navigateToRoute('/auth'),
              icon: const Icon(Icons.login),
              label: const Text('Global Auth Navigation'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => navigationService.showFullscreenOverlay(),
              icon: const Icon(Icons.fullscreen),
              label: const Text('Fullscreen Overlay'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showGlobalDialog(navigationService),
              icon: const Icon(Icons.info),
              label: const Text('Global Dialog'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => navigationService.showGlobalSnackBar(
                'Global SnackBar from HomePage!',
              ),
              icon: const Icon(Icons.message),
              label: const Text('Global SnackBar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),

            const SizedBox(height: 30),

            // Deep link simulation
            _buildSectionTitle('Deep Link Simulation'),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () =>
                  navigationService.handleDeepLink('profile/user123'),
              icon: const Icon(Icons.link),
              label: const Text('Simulate Profile Deep Link'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () =>
                  navigationService.handleDeepLink('settings/theme'),
              icon: const Icon(Icons.link),
              label: const Text('Simulate Settings Deep Link'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            ),

            const SizedBox(height: 30),

            // Information section
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
                    'Powerful Features of _rootNavigatorKey:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    '🌐 Global Navigation Control - No BuildContext needed',
                  ),
                  _buildFeatureItem(
                    '🔐 Authentication Flow Management - Fullscreen login pages',
                  ),
                  _buildFeatureItem(
                    '📱 Modal Overlays - Display outside Shell',
                  ),
                  _buildFeatureItem(
                    '🔗 Deep Link Handling - External link redirection',
                  ),
                  _buildFeatureItem(
                    '⚠️ Global Error Handling - Unified error pages',
                  ),
                  _buildFeatureItem(
                    '🎯 Type-safe Routing - Compile-time checking',
                  ),
                  _buildFeatureItem(
                    '💬 Global Dialogs & Toasts - Display from anywhere',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Try switching between tabs using the bottom navigation bar. '
              'Notice how the navigation bar persists across all pages, '
              'but full-screen routes bypass the shell entirely.',
              style: TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  void _showGlobalDialog(NavigationService navigationService) {
    navigationService.showGlobalDialog(
      dialog: AlertDialog(
        title: const Text('Global Dialog Example'),
        content: const Text(
          'This dialog is displayed through _rootNavigatorKey, '
          'and can be called from anywhere in the app without requiring the current page\'s BuildContext.\n\n'
          'This demonstrates how NavigationService utilizes _rootNavigatorKey '
          'to achieve true global navigation control.',
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
              navigationService.navigateToRoute('/settings');
            },
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }
}
