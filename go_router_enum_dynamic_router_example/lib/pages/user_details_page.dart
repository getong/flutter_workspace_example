import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_routes.dart';

class UserDetailsPage extends StatelessWidget {
  final String userId;

  const UserDetailsPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User $userId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID: $userId'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoute.home.path),
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
