import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/navigation_service.dart';

/// Authentication page demonstrating _rootNavigatorKey usage
///
/// This page shows how _rootNavigatorKey enables:
/// - Full-screen navigation outside of shell
/// - Global navigation control
/// - Authentication flow management
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _navigationService = NavigationService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.purple.shade600],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 100, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  'Authentication Required',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'This page uses _rootNavigatorKey for full-screen display',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Demonstrate global navigation using NavigationService
                    _navigationService.navigateToRoute('/home');
                  },
                  child: const Text(
                    'Skip Authentication (Demo)',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Examples of _rootNavigatorKey usage:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showGlobalDialog(),
                      child: const Text('Global Dialog'),
                    ),
                    ElevatedButton(
                      onPressed: () => _showGlobalSnackBar(),
                      child: const Text('Global SnackBar'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          _navigationService.showFullscreenOverlay(),
                      child: const Text('Fullscreen Overlay'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    // Simulate authentication
    await Future.delayed(const Duration(seconds: 2));

    // Show success message using global navigation service
    _navigationService.showGlobalSnackBar('Login successful!');

    // Navigate to home using global navigation
    _navigationService.navigateToRoute('/home');

    setState(() => _isLoading = false);
  }

  void _showGlobalDialog() {
    _navigationService.showGlobalDialog(
      dialog: AlertDialog(
        title: const Text('Global Dialog'),
        content: const Text(
          'This dialog was shown using _rootNavigatorKey '
          'through NavigationService without requiring BuildContext!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showGlobalSnackBar() {
    _navigationService.showGlobalSnackBar(
      'Global SnackBar shown using _rootNavigatorKey!',
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
