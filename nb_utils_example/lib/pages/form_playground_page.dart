import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FormPlaygroundPage extends StatefulWidget {
  const FormPlaygroundPage({super.key});

  @override
  State<FormPlaygroundPage> createState() => _FormPlaygroundPageState();
}

class _FormPlaygroundPageState extends State<FormPlaygroundPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final FormState? formState = _formKey.currentState;
    if (formState == null) {
      return;
    }

    if (formState.validate()) {
      toasty(
        context,
        'Draft saved for ${_nameController.text.trim()}',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _fillSampleData() {
    setState(() {
      _nameController.text = 'Casey Johnson';
      _emailController.text = 'casey@teamflow.dev';
      _passwordController.text = 'strongpass123';
      _notesController.text =
          'Prepare a handoff page with routes for dashboard, forms, and release notes.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Form Playground')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text('AppTextField examples', style: boldTextStyle(size: 24)),
            8.height,
            Text(
              'This page uses `AppTextField` for validation-friendly inputs.',
              style: secondaryTextStyle(),
            ),
            18.height,
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    AppTextField(
                      controller: _nameController,
                      textFieldType: TextFieldType.NAME,
                      title: 'Owner name',
                      decoration: const InputDecoration(
                        hintText: 'Enter the owner name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    16.height,
                    AppTextField(
                      controller: _emailController,
                      textFieldType: TextFieldType.EMAIL,
                      title: 'Email address',
                      decoration: const InputDecoration(
                        hintText: 'team@example.com',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    16.height,
                    AppTextField(
                      controller: _passwordController,
                      textFieldType: TextFieldType.PASSWORD,
                      title: 'Workspace password',
                      decoration: const InputDecoration(
                        hintText: 'Minimum 8 characters',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    16.height,
                    AppTextField(
                      controller: _notesController,
                      textFieldType: TextFieldType.MULTILINE,
                      title: 'Notes',
                      minLines: 4,
                      maxLines: 6,
                      isValidationRequired: false,
                      decoration: const InputDecoration(
                        hintText: 'Describe the page flow or demo goal',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    20.height,
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: AppButton(
                            text: 'Save draft',
                            color: colorScheme.primary,
                            textColor: Colors.white,
                            onTap: _submitForm,
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: AppButton(
                            text: 'Load sample',
                            color: colorScheme.secondaryContainer,
                            textColor: colorScheme.onSecondaryContainer,
                            onTap: _fillSampleData,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
