import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'FormFieldRoute')
class FormFieldPage extends StatefulWidget {
  const FormFieldPage({super.key});

  @override
  State<FormFieldPage> createState() => _FormFieldPageState();
}

class _FormFieldPageState extends State<FormFieldPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String _contactMethod = 'Email';
  double _urgency = 3;
  Set<String> _selectedTopics = <String>{'Layout'};
  bool _notificationsEnabled = true;

  String _savedSummary = 'Submit the form to see the saved FormField values.';

  void _submit() {
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return;
    }

    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!form.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the invalid FormField values.'),
        ),
      );
      return;
    }

    form.save();
    setState(() {
      _savedSummary =
          'Contact: $_contactMethod | Urgency: ${_urgency.toStringAsFixed(0)} | Topics: ${_selectedTopics.join(', ')} | Notifications: ${_notificationsEnabled ? 'On' : 'Off'}';
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('FormField values saved.')));
  }

  void _reset() {
    _formKey.currentState?.reset();
    setState(() {
      _autovalidateMode = AutovalidateMode.disabled;
      _contactMethod = 'Email';
      _urgency = 3;
      _selectedTopics = <String>{'Layout'};
      _notificationsEnabled = true;
      _savedSummary = 'Submit the form to see the saved FormField values.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('FormField Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'FormField is the base building block behind widgets like TextFormField and DropdownButtonFormField.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'This page focuses on direct FormField<T> usage: custom chip selectors, slider-backed fields, boolean fields, validation, save, reset, and autovalidation.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _InfoCard(
              title: 'Why use FormField directly?',
              description:
                  'Use FormField<T> when you have a custom UI control that should still participate in a Form lifecycle. The builder receives FormFieldState<T> so you can call didChange, read errors, and save values later.',
            ),
            const SizedBox(height: 16),
            const _InfoCard(
              title: 'Core FormField hooks',
              description:
                  'validator checks a value, onSaved persists it, initialValue defines reset behavior, and FormFieldState.didChange updates the current value and reruns validation when needed.',
            ),
            const SizedBox(height: 24),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Custom Settings Form',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Every input below is wired through FormField<T>, even though the UI is built from chips, sliders, and switches instead of standard text fields.',
                      ),
                      const SizedBox(height: 20),
                      FormField<String>(
                        initialValue: _contactMethod,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please choose a contact method.';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _contactMethod = value ?? 'Email';
                        },
                        builder: (FormFieldState<String> field) {
                          return _FieldContainer(
                            label: 'Preferred contact method',
                            errorText: field.errorText,
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: <Widget>[
                                for (final String option in <String>[
                                  'Email',
                                  'Phone',
                                  'Slack',
                                ])
                                  ChoiceChip(
                                    label: Text(option),
                                    selected: field.value == option,
                                    onSelected: (_) {
                                      field.didChange(option);
                                      setState(() {
                                        _contactMethod = option;
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
                        initialValue: _urgency,
                        validator: (double? value) {
                          if (value == null) {
                            return 'Please set an urgency.';
                          }
                          if (value < 2) {
                            return 'Urgency must be at least 2.';
                          }
                          return null;
                        },
                        onSaved: (double? value) {
                          _urgency = value ?? 3;
                        },
                        builder: (FormFieldState<double> field) {
                          final double currentValue = field.value ?? 3;
                          return _FieldContainer(
                            label: 'Delivery urgency',
                            errorText: field.errorText,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Slider(
                                  value: currentValue,
                                  min: 1,
                                  max: 5,
                                  divisions: 4,
                                  label: currentValue.toStringAsFixed(0),
                                  onChanged: (double nextValue) {
                                    field.didChange(nextValue);
                                    setState(() {
                                      _urgency = nextValue;
                                    });
                                  },
                                ),
                                Text(
                                  'Current urgency: ${currentValue.toStringAsFixed(0)} / 5',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      FormField<Set<String>>(
                        initialValue: Set<String>.from(_selectedTopics),
                        validator: (Set<String>? value) {
                          if (value == null || value.isEmpty) {
                            return 'Select at least one topic.';
                          }
                          if (value.length < 2) {
                            return 'Pick at least two topics to continue.';
                          }
                          return null;
                        },
                        onSaved: (Set<String>? value) {
                          _selectedTopics = value ?? <String>{'Layout'};
                        },
                        builder: (FormFieldState<Set<String>> field) {
                          final Set<String> topics =
                              field.value ?? <String>{'Layout'};

                          return _FieldContainer(
                            label: 'Topics to include',
                            errorText: field.errorText,
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: <Widget>[
                                for (final String topic in <String>[
                                  'Layout',
                                  'Animation',
                                  'Routing',
                                  'Accessibility',
                                  'State',
                                ])
                                  FilterChip(
                                    label: Text(topic),
                                    selected: topics.contains(topic),
                                    onSelected: (bool selected) {
                                      final Set<String> nextTopics =
                                          Set<String>.from(topics);
                                      if (selected) {
                                        nextTopics.add(topic);
                                      } else {
                                        nextTopics.remove(topic);
                                      }
                                      field.didChange(nextTopics);
                                      setState(() {
                                        _selectedTopics = nextTopics;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      FormField<bool>(
                        initialValue: _notificationsEnabled,
                        onSaved: (bool? value) {
                          _notificationsEnabled = value ?? true;
                        },
                        builder: (FormFieldState<bool> field) {
                          return _FieldContainer(
                            label: 'Notifications',
                            errorText: field.errorText,
                            child: SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Enable release reminders'),
                              subtitle: const Text(
                                'This is a boolean FormField driven by SwitchListTile.',
                              ),
                              value: field.value ?? true,
                              onChanged: (bool nextValue) {
                                field.didChange(nextValue);
                                setState(() {
                                  _notificationsEnabled = nextValue;
                                });
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          FilledButton(
                            onPressed: _submit,
                            child: const Text('Validate + Save'),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _autovalidateMode =
                                    AutovalidateMode.onUserInteraction;
                              });
                              _formKey.currentState?.validate();
                            },
                            child: const Text('Enable Autovalidate'),
                          ),
                          TextButton(
                            onPressed: _reset,
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withValues(alpha: 0.08),
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
            const _ExampleNote(
              title: 'Built-in widgets are FormField-based too',
              body:
                  'TextFormField, DropdownButtonFormField, and other form helpers are convenience wrappers around the same FormField lifecycle shown above.',
            ),
            const SizedBox(height: 16),
            const _ExampleNote(
              title: 'When to reach for FormField',
              body:
                  'If your design uses chips, star ratings, color swatches, calendar pickers, sliders, or any custom selector, wrapping it in FormField<T> keeps validation and saving consistent with the rest of the form.',
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

class _FieldContainer extends StatelessWidget {
  const _FieldContainer({
    required this.label,
    required this.child,
    this.errorText,
  });

  final String label;
  final Widget child;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        errorText: errorText,
      ),
      child: child,
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

class _ExampleNote extends StatelessWidget {
  const _ExampleNote({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}
