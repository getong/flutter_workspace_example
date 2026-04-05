import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Details page demonstrating nested routing
class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details - ID: $id'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Details Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Item ID: $id', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text(
              'This is a nested route under /home.\n'
              'The bottom navigation is still visible.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
