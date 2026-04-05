import 'package:riverpod_generator_asyncnotifier_example/auth_controller.dart';
import 'package:riverpod_generator_asyncnotifier_example/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple account screen showing a login button.
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: AuthButton(
          text: 'Sign in',
          onPressed: () =>
              ref.read(authControllerProvider.notifier).signInAnonymously(),
        ),
      ),
    );
  }
}
