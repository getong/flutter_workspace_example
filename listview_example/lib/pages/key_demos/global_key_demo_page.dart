import 'package:flutter/material.dart';

import 'key_demo_shell.dart';

class GlobalKeyDemoPage extends StatefulWidget {
  const GlobalKeyDemoPage({super.key});

  @override
  State<GlobalKeyDemoPage> createState() => _GlobalKeyDemoPageState();
}

class _GlobalKeyDemoPageState extends State<GlobalKeyDemoPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final bool isValid = formKey.currentState?.validate() ?? false;
    final String message = isValid
        ? 'Form is valid. Processing data...'
        : 'Form is invalid. Please fix the field.';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return KeyDemoShell(
      title: 'GlobalKey Form',
      description:
          'A GlobalKey lets code outside the Form widget access its current '
          'state and trigger validation when needed.',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: formKey,
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Project name',
                    hintText: 'Enter a project name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Project name is required.';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _validateForm,
                child: const Text('Validate form'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
