import 'package:flutter/material.dart';
import '../router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                const ProfileRoute().go(context);
              },
              child: const Text('Go to Profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                const DetailsRoute(id: '123').go(context);
              },
              child: const Text('Go to Details (ID: 123)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                const DetailsRoute(id: 'abc').go(context);
              },
              child: const Text('Go to Details (ID: abc)'),
            ),
          ],
        ),
      ),
    );
  }
}