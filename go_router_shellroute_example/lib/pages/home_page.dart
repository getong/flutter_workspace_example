import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home page demonstrating navigation within a ShellRoute
///
/// This page shows how to:
/// - Navigate to other pages while maintaining the shell
/// - Pass parameters to nested routes
/// - Use different navigation methods (go, push)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to GoRouter ShellRoute Example!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'This example demonstrates:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text('• Persistent bottom navigation using ShellRoute'),
            const Text('• Navigation between different tabs'),
            const Text('• Nested routes within the shell'),
            const Text('• Parameter passing between routes'),
            const SizedBox(height: 30),
            const Text(
              'Navigation Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigate to details page with parameter
                context.go('/home/details/123');
              },
              child: const Text('Go to Details (ID: 123)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Push details page (adds to navigation stack)
                context.push('/home/details/456');
              },
              child: const Text('Push Details (ID: 456)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate using named route
                context.goNamed('details', pathParameters: {'id': '789'});
              },
              child: const Text('Go to Details using Named Route (ID: 789)'),
            ),
            const SizedBox(height: 30),
            const Text(
              'Try switching between tabs using the bottom navigation bar. '
              'Notice how the navigation bar persists across all pages.',
              style: TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
