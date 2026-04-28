import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../cubit/register_cubit.dart';
import '../widgets/auth_flow_details.dart';

@RoutePage()
class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: const _RegisterScreen(),
    );
  }
}

class _RegisterScreen extends StatefulWidget {
  const _RegisterScreen();

  @override
  State<_RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<_RegisterScreen> {
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
      appBar: AppBar(title: const Text('/register')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'The client first loads `/public-key` over HTTPS, then wraps a random AES-256 key with RSA-OAEP-SHA256 and encrypts the registration JSON with AES-256-GCM. The POST body sent to the Rust server contains `wrapped_key_base64`, `nonce_base64`, and `ciphertext_base64`.',
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
                      labelText: 'Client public key or short client id',
                      border: OutlineInputBorder(),
                      helperText:
                          'This no longer has to fit inside the RSA limit, but the Rust server still caps this field at 8 KiB after decryption.',
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
                          'The Rust server caps this field at 1024 bytes after decryption.',
                    ),
                    obscureText: true,
                    validator: _validateRequiredField,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final isSubmitting = state is RegisterSubmitting;

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
                          : const Icon(Icons.lock),
                      label: Text(
                        isSubmitting
                            ? 'Encrypting and sending'
                            : 'Submit registration',
                      ),
                    ),
                    const SizedBox(height: 20),
                    switch (state) {
                      RegisterSuccess(:final result) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ServerResultCard(title: 'Register', flow: result),
                          const SizedBox(height: 16),
                          EncryptedRequestCard(
                            title: 'Encrypted request sent to /register',
                            flow: result,
                          ),
                        ],
                      ),
                      RegisterError(:final message) => _RegisterErrorCard(
                        message: message,
                      ),
                      RegisterSubmitting() => const _PendingCard(),
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

    context.read<RegisterCubit>().submit(
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
          'Enter a client key value and password, then submit to run the full HTTPS `/public-key` -> hybrid encrypt -> `/register` flow.',
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
          'Fetching the current server key over HTTPS, generating a random AES key and nonce, and encrypting the payload.',
        ),
      ),
    );
  }
}

class _RegisterErrorCard extends StatelessWidget {
  final String message;

  const _RegisterErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(padding: const EdgeInsets.all(20), child: Text(message)),
    );
  }
}
