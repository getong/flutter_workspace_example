import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Master'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Master Navigation with Go Router',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.push(AppRoute.profile.path),
              child: const Text('Go to Profile (Fade Transition)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push(AppRoute.settings.path),
              child: const Text('Go to Settings (Slide Transition)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push(
                AppRoute.userDetail.location(pathParameters: {'id': '123'}),
              ),
              child: const Text('View User Detail (Scale Transition)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push(
                AppRoute.productDetail.location(
                  pathParameters: {'productId': 'prod-456'},
                ),
              ),
              child: const Text('View Product Detail (Rotation Transition)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push(
                AppRoute.category.location(
                  pathParameters: {'categoryName': 'electronics'},
                ),
              ),
              child: const Text('Browse Electronics (Slide Transition)'),
            ),
          ],
        ),
      ),
    );
  }
}
