import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../core/di/di.dart';
import '../cubit/register_cubit.dart';

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
                  'The client first loads `/public-key`, then encrypts this JSON with RSA-OAEP-SHA256 before posting `{ "ciphertext_base64": "..." }` to the Rust server.',
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
                          'Keep this compact. A PEM string usually exceeds the RSA plaintext limit for this demo.',
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
                      RegisterSuccess(:final result) => _RegisterResultCard(
                        status: result.status,
                        clientPublicKeySha256: result.clientPublicKeySha256,
                        passwordSha256: result.passwordSha256,
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
          'Enter a short client key value and password, then submit to run the full `/public-key` -> encrypt -> `/register` flow.',
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
          'Fetching the current server key and encrypting the payload.',
        ),
      ),
    );
  }
}

class _RegisterResultCard extends StatelessWidget {
  final String status;
  final String clientPublicKeySha256;
  final String passwordSha256;

  const _RegisterResultCard({
    required this.status,
    required this.clientPublicKeySha256,
    required this.passwordSha256,
  });

  @override
  Widget build(BuildContext context) {
    final resultPayload = jsonEncode(<String, String>{
      'status': status,
      'client_public_key_sha256': clientPublicKeySha256,
      'password_sha256': passwordSha256,
    });

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Status: $status')),
                  TextButton.icon(
                    onPressed: () => _copyToClipboard(
                      context,
                      label: 'Full register result JSON',
                      value: resultPayload,
                    ),
                    icon: const Icon(Icons.copy_all_outlined),
                    label: const Text('Copy JSON'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _CopyableResultField(
                label: 'client_public_key_sha256',
                value: clientPublicKeySha256,
              ),
              const SizedBox(height: 12),
              _CopyableResultField(
                label: 'password_sha256',
                value: passwordSha256,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _copyToClipboard(
    BuildContext context, {
    required String label,
    required String value,
  }) async {
    await Clipboard.setData(ClipboardData(text: value));

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label copied to clipboard.')));
  }
}

class _CopyableResultField extends StatelessWidget {
  final String label;
  final String value;

  const _CopyableResultField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label)),
            IconButton(
              tooltip: 'Copy $label',
              onPressed: () => _RegisterResultCard._copyToClipboard(
                context,
                label: label,
                value: value,
              ),
              icon: const Icon(Icons.copy_outlined),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SelectableText(value),
      ],
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
