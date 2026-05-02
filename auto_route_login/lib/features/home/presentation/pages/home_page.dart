import 'package:auto_route/auto_route.dart';
import 'package:auto_route_login/app/router/app_router.dart';
import 'package:auto_route_login/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Shows only the first 8 characters of the token followed by asterisks,
  /// so the raw value is never fully exposed in the UI.
  String _maskToken(String token) {
    if (token.length <= 8) return '****';
    return '${token.substring(0, 8)}••••••••';
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Home Page'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
              context.router.replace(const LoginRoute());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Hello, ${user?.name ?? ''}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'This page is reached only after the BLoC completes a Dio-backed auth request and the global AutoRoute router redirects here.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('User ID: ${user?.id ?? ''}'),
                        const SizedBox(height: 8),
                        Text('Email: ${user?.email ?? ''}'),
                        const SizedBox(height: 8),
                        Text('Token: ${_maskToken(user?.token ?? '')}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
