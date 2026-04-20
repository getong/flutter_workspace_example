import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController(
    text: 'I build Flutter UI demos.',
  );

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String _role = 'Designer';
  bool _subscribe = true;
  bool _acceptTerms = false;
  String _savedSummary = 'Submit the form to see saved values here.';

  final GlobalKey<FormState> _preferencesFormKey = GlobalKey<FormState>();
  bool _compactLayout = false;
  double _priority = 2;
  String _savedPreferences = 'No preferences submitted yet.';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter a name.';
    }
    if (trimmed.length < 3) {
      return 'Use at least 3 characters.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter an email.';
    }
    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  void _submitProfileForm() {
    final FormState? form = _profileFormKey.currentState;
    if (form == null) {
      return;
    }

    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!form.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the validation errors.')),
      );
      return;
    }

    form.save();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile form submitted successfully.')),
    );
  }

  void _resetProfileForm() {
    _profileFormKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _bioController.text = 'I build Flutter UI demos.';

    setState(() {
      _role = 'Designer';
      _subscribe = true;
      _acceptTerms = false;
      _autovalidateMode = AutovalidateMode.disabled;
      _savedSummary = 'Submit the form to see saved values here.';
    });
  }

  void _submitPreferencesForm() {
    final FormState? form = _preferencesFormKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    form.save();
    setState(() {
      _savedPreferences =
          'Layout: ${_compactLayout ? 'Compact' : 'Comfortable'} | Priority: ${_priority.toStringAsFixed(0)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Form groups multiple form fields together so you can validate, save, and reset them from one place with a FormState key.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates common Form usage: TextFormField validation, autovalidation, DropdownButtonFormField, custom FormField widgets, and reset/save flows.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _InfoCard(
              title: 'What Form is good for',
              description:
                  'Use a Form when several inputs belong to one submit action. A GlobalKey<FormState> lets you call validate(), save(), and reset() across all descendants.',
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Why use TextFormField instead of TextField?',
              description:
                  'TextFormField plugs directly into Form validation and saving, so each field can provide validator and onSaved callbacks.',
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: '1. Profile Form',
              subtitle:
                  'A practical example with validation, save, autovalidate, reset, and multiple field types working together.',
            ),
            const SizedBox(height: 12),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _profileFormKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Account Details',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Call validate() to run every validator in the form. Call save() after validation to collect values from onSaved.',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          hintText: 'Enter your display name',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: _validateName,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'name@example.com',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _role,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Role',
                        ),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: 'Designer',
                            child: Text('Designer'),
                          ),
                          DropdownMenuItem(
                            value: 'Developer',
                            child: Text('Developer'),
                          ),
                          DropdownMenuItem(
                            value: 'Product Manager',
                            child: Text('Product Manager'),
                          ),
                        ],
                        onChanged: (String? value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _role = value;
                          });
                        },
                        onSaved: (String? value) {
                          _role = value ?? _role;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _bioController,
                        minLines: 3,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Bio',
                          hintText: 'Tell us about your work',
                        ),
                        validator: (String? value) {
                          final String trimmed = value?.trim() ?? '';
                          if (trimmed.isEmpty) {
                            return 'Please add a short bio.';
                          }
                          if (trimmed.length < 12) {
                            return 'Write at least 12 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Subscribe to product updates'),
                        subtitle: const Text(
                          'This boolean value can still live inside the same overall Form submit flow.',
                        ),
                        value: _subscribe,
                        onChanged: (bool value) {
                          setState(() {
                            _subscribe = value;
                          });
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _acceptTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                        title: const Text('Accept terms'),
                        subtitle:
                            !_acceptTerms &&
                                _autovalidateMode != AutovalidateMode.disabled
                            ? const Text(
                                'You must accept the terms before submitting.',
                                style: TextStyle(color: Colors.red),
                              )
                            : const Text(
                                'This field is validated when you submit.',
                              ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          FilledButton(
                            onPressed: _submitProfileForm,
                            child: const Text('Validate + Save'),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _autovalidateMode =
                                    AutovalidateMode.onUserInteraction;
                              });
                              _profileFormKey.currentState?.validate();
                            },
                            child: const Text('Enable Autovalidate'),
                          ),
                          TextButton(
                            onPressed: _resetProfileForm,
                            child: const Text('Reset Form'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(_savedSummary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: '2. Custom FormField Example',
              subtitle:
                  'Form is not limited to text inputs. You can wrap custom controls in FormField<T> and validate them like any other field.',
            ),
            const SizedBox(height: 12),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _preferencesFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Dashboard Preferences',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This custom FormField uses chips for one setting and saves the chosen value through FormState.',
                      ),
                      const SizedBox(height: 16),
                      FormField<bool>(
                        initialValue: _compactLayout,
                        validator: (bool? value) {
                          if (value == null) {
                            return 'Choose a layout mode.';
                          }
                          return null;
                        },
                        onSaved: (bool? value) {
                          _compactLayout = value ?? false;
                        },
                        builder: (FormFieldState<bool> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Layout density',
                              errorText: field.errorText,
                            ),
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: <Widget>[
                                ChoiceChip(
                                  label: const Text('Comfortable'),
                                  selected: field.value == false,
                                  onSelected: (_) {
                                    field.didChange(false);
                                    setState(() {
                                      _compactLayout = false;
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text('Compact'),
                                  selected: field.value == true,
                                  onSelected: (_) {
                                    field.didChange(true);
                                    setState(() {
                                      _compactLayout = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      FormField<double>(
                        initialValue: _priority,
                        validator: (double? value) {
                          if (value == null || value < 2) {
                            return 'Pick a priority of at least 2.';
                          }
                          return null;
                        },
                        onSaved: (double? value) {
                          _priority = value ?? 2;
                        },
                        builder: (FormFieldState<double> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Sync priority',
                              errorText: field.errorText,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Slider(
                                  value: field.value ?? 2,
                                  min: 1,
                                  max: 5,
                                  divisions: 4,
                                  label: '${(field.value ?? 2).toInt()}',
                                  onChanged: (double value) {
                                    field.didChange(value);
                                    setState(() {
                                      _priority = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Current priority: ${(field.value ?? 2).toStringAsFixed(0)}',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          FilledButton(
                            onPressed: _submitPreferencesForm,
                            child: const Text('Submit Preferences'),
                          ),
                          TextButton(
                            onPressed: () {
                              _preferencesFormKey.currentState?.reset();
                              setState(() {
                                _compactLayout = false;
                                _priority = 2;
                                _savedPreferences =
                                    'No preferences submitted yet.';
                              });
                            },
                            child: const Text('Reset Preferences'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _savedPreferences,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(subtitle),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}
