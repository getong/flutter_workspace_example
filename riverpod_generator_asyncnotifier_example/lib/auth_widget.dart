import 'package:riverpod_generator_asyncnotifier_example/fake_auth_repository.dart';
import 'package:riverpod_generator_asyncnotifier_example/sign_in_screen.dart';
import 'package:riverpod_generator_asyncnotifier_example/sign_out_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateChangesProvider);
    return authStateAsync.when(
      data: (signedIn) {
        if (signedIn) {
          return const SignOutScreen();
        } else {
          return const SignInScreen();
        }
      },
      error: (e, st) => Scaffold(body: Center(child: Text(e.toString()))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
