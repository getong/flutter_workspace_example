import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../cubit/login_cubit.dart';
import '../widgets/auth_flow_details.dart';

@RoutePage()
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  const _LoginScreen();

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientPublicKeyController = TextEditingController(
    text: 'client-mobile-01',
  );
  final _passwordController = TextEditingController(text: 'secret-123');

  @override
  void dispose() {
    _clientPublicKeyController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('/login')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'This uses the same hybrid transport as `/register`: fetch `/public-key` over HTTPS, wrap a random AES-256 key with RSA-OAEP-SHA256, encrypt the JSON payload with AES-256-GCM, and submit the three base64 fields to `/login`.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _clientPublicKeyController,
                    decoration: const InputDecoration(
                      labelText: 'Registered client public key or client id',
                      border: OutlineInputBorder(),
                      helperText:
                          'Use the same client_public_key value that was registered with the Rust service.',
                    ),
                    minLines: 1,
                    maxLines: 3,
                    validator: _validateRequiredField,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      helperText:
                          'If the password or client_public_key is wrong, the server returns 401 invalid_credentials.',
                    ),
                    obscureText: true,
                    validator: _validateRequiredField,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final isSubmitting = state is LoginSubmitting;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton.icon(
                      onPressed: isSubmitting ? null : _submit,
                      icon: isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login),
                      label: Text(
                        isSubmitting
                            ? 'Encrypting and sending'
                            : 'Submit login',
                      ),
                    ),
                    const SizedBox(height: 20),
                    switch (state) {
                      LoginSuccess(:final result) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ServerResultCard(title: 'Login', flow: result),
                          const SizedBox(height: 16),
                          EncryptedRequestCard(
                            title: 'Encrypted request sent to /login',
                            flow: result,
                          ),
                        ],
                      ),
                      LoginError(:final message) => _LoginErrorCard(
                        message: message,
                      ),
                      LoginSubmitting() => const _PendingCard(),
                      _ => const _IdleCard(),
                    },
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String? _validateRequiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }

    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<LoginCubit>().submit(
      clientPublicKey: _clientPublicKeyController.text.trim(),
      password: _passwordController.text,
    );
  }
}

class _IdleCard extends StatelessWidget {
  const _IdleCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Register a user first, then submit matching credentials to test the HTTPS `/login` flow.',
        ),
      ),
    );
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Fetching the current server key over HTTPS and encrypting the login payload.',
        ),
      ),
    );
  }
}

class _LoginErrorCard extends StatelessWidget {
  final String message;

  const _LoginErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(padding: const EdgeInsets.all(20), child: Text(message)),
    );
  }
}
