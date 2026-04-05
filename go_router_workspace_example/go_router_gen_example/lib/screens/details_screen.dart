import 'package:flutter/material.dart';
import '../router.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details - $id'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              'Details for ID: $id',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Item ID: $id'),
                    const SizedBox(height: 8),
                    Text('Type: ${id.contains(RegExp(r'[0-9]')) ? 'Numeric' : 'Text'}'),
                    const SizedBox(height: 8),
                    Text('Length: ${id.length} characters'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    const HomeRoute().go(context);
                  },
                  child: const Text('Home'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    const ProfileRoute().go(context);
                  },
                  child: const Text('Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}