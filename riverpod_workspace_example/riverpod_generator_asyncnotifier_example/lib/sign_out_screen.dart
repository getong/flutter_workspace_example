import 'package:riverpod_generator_asyncnotifier_example/auth_controller.dart';
import 'package:riverpod_generator_asyncnotifier_example/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple account screen showing a logout button.
class SignOutScreen extends ConsumerWidget {
  const SignOutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: AuthButton(
          text: 'Sign out',
          onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
        ),
      ),
    );
  }
}
