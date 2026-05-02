import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.formz)
class FormzPage extends StatefulWidget {
  const FormzPage({super.key});

  @override
  State<FormzPage> createState() => _FormzPageState();
}

class _FormzPageState extends State<FormzPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late DemoSignupState _state;

  @override
  void initState() {
    super.initState();
    _state = const DemoSignupState();
    _displayNameController.addListener(_onDisplayNameChanged);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void dispose() {
    _displayNameController
      ..removeListener(_onDisplayNameChanged)
      ..dispose();
    _emailController
      ..removeListener(_onEmailChanged)
      ..dispose();
    _passwordController
      ..removeListener(_onPasswordChanged)
      ..dispose();
    _confirmPasswordController
      ..removeListener(_onConfirmPasswordChanged)
      ..dispose();
    super.dispose();
  }

  void _onDisplayNameChanged() {
    setState(() {
      _state = _state.copyWith(
        displayName: DisplayNameInput.dirty(_displayNameController.text),
      );
    });
  }

  void _onEmailChanged() {
    setState(() {
      _state = _state.copyWith(
        email: DemoEmailInput.dirty(_emailController.text),
      );
    });
  }

  void _onPasswordChanged() {
    final PasswordInput nextPassword = PasswordInput.dirty(
      _passwordController.text,
    );
    setState(() {
      _state = _state.copyWith(
        password: nextPassword,
        confirmPassword: ConfirmPasswordInput.dirty(
          value: _confirmPasswordController.text,
          password: nextPassword.value,
        ),
      );
    });
  }

  void _onConfirmPasswordChanged() {
    setState(() {
      _state = _state.copyWith(
        confirmPassword: ConfirmPasswordInput.dirty(
          value: _confirmPasswordController.text,
          password: _state.password.value,
        ),
      );
    });
  }

  void _onRoleChanged(String? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _state = _state.copyWith(role: RoleInput.dirty(value));
    });
  }

  void _onTermsChanged(bool? value) {
    setState(() {
      _state = _state.copyWith(
        acceptTerms: AcceptTermsInput.dirty(value ?? false),
      );
    });
  }

  void _onNewsletterChanged(bool value) {
    setState(() {
      _state = _state.copyWith(subscribeToNews: value);
    });
  }

  Future<void> _submit() async {
    final FormState? formState = _formKey.currentState;
    if (formState == null) {
      return;
    }

    if (!formState.validate()) {
      setState(() {
        _state = _state.copyWith(showValidation: true);
      });
      return;
    }

    setState(() {
      _state = _state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        showValidation: true,
      );
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));

    final bool shouldFail = _state.email.value.endsWith('@fail.dev');
    if (!mounted) {
      return;
    }

    setState(() {
      _state = _state.copyWith(
        status: shouldFail
            ? FormzSubmissionStatus.failure
            : FormzSubmissionStatus.success,
        submittedSummary: shouldFail
            ? 'Submission failed on purpose for emails ending with @fail.dev.'
            : 'Saved ${_state.displayName.value} as a ${_state.role.value} account. Newsletter: ${_state.subscribeToNews ? 'on' : 'off'}.',
      );
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            shouldFail
                ? 'Submission failed. Try an email that does not end with @fail.dev.'
                : 'Submitted successfully.',
          ),
        ),
      );
  }

  void _reset() {
    _formKey.currentState?.reset();
    _displayNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();

    setState(() {
      _state = const DemoSignupState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool showErrors = _state.showValidation || _state.status.isFailure;

    return Scaffold(
      appBar: AppBar(title: const Text('formz Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'formz keeps validation rules in small input models while Flutter widgets stay focused on rendering and interaction.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'This module starts from the package example, then expands it with more Flutter widgets: TextFormField, DropdownButtonFormField, CheckboxListTile, SwitchListTile, helper chips, and a live submission state panel.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _InfoCard(
              title: 'Why use formz?',
              description:
                  'Each field owns its own validator and pure/dirty state. The page-level state can then combine all inputs into one validity check with FormzMixin.',
            ),
            const SizedBox(height: 16),
            const _InfoCard(
              title: 'Try this demo',
              description:
                  'Use an email ending with @fail.dev to trigger the failure branch. Leave the terms checkbox off to see a non-text-field validator.',
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: 'Live Sign-up Form',
              subtitle:
                  'A richer Flutter form built on top of FormzInput models.',
            ),
            const SizedBox(height: 12),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: showErrors
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Account Setup',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'The validators below are driven by formz inputs, but the visible form is still composed of normal Flutter form widgets.',
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _displayNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Display name',
                          helperText: 'At least 3 characters',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (_) =>
                            _state.displayName.displayError?.text(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          helperText: 'Use @fail.dev to simulate a failure',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (_) => _state.email.displayError?.text(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          helperText:
                              'At least 8 chars, with one letter and one number',
                          helperMaxLines: 2,
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        validator: (_) => _state.password.displayError?.text(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm password',
                          prefixIcon: Icon(Icons.lock_reset_outlined),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        validator: (_) =>
                            _state.confirmPassword.displayError?.text(),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _state.role.value.isEmpty
                            ? null
                            : _state.role.value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Role',
                          prefixIcon: Icon(Icons.work_outline),
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
                          DropdownMenuItem(
                            value: 'QA Engineer',
                            child: Text('QA Engineer'),
                          ),
                        ],
                        onChanged: _onRoleChanged,
                        validator: (_) => _state.role.displayError?.text(),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile.adaptive(
                        value: _state.subscribeToNews,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Subscribe to release notes'),
                        subtitle: const Text(
                          'Plain Flutter state can still live beside formz inputs.',
                        ),
                        onChanged: _onNewsletterChanged,
                      ),
                      CheckboxListTile(
                        value: _state.acceptTerms.value,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Accept terms and privacy policy'),
                        subtitle: Text(
                          _state.acceptTerms.displayError?.text() ??
                              'Required before submit',
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: _onTermsChanged,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          _StateChip(
                            label: _state.isValid
                                ? 'Form valid'
                                : 'Form invalid',
                            color: _state.isValid
                                ? Colors.green
                                : Colors.orange,
                          ),
                          _StateChip(
                            label: _state.status.label,
                            color: _state.status.color,
                          ),
                          _StateChip(
                            label: _state.acceptTerms.value
                                ? 'Terms accepted'
                                : 'Terms pending',
                            color: _state.acceptTerms.value
                                ? Colors.teal
                                : Colors.redAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _state.status.isInProgress
                            ? Column(
                                key: const ValueKey<String>('progress'),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  LinearProgressIndicator(),
                                  SizedBox(height: 12),
                                  Text('Submitting demo data...'),
                                ],
                              )
                            : Row(
                                key: const ValueKey<String>('buttons'),
                                children: <Widget>[
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: _submit,
                                      icon: const Icon(Icons.send),
                                      label: const Text('Submit'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _reset,
                                      icon: const Icon(Icons.restart_alt),
                                      label: const Text('Reset'),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: 'Input State Breakdown',
              subtitle:
                  'Each row below maps one Flutter widget to its backing FormzInput.',
            ),
            const SizedBox(height: 12),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  _StateRow(
                    name: 'DisplayNameInput',
                    value: _state.displayName.value,
                    isPure: _state.displayName.isPure,
                    errorText: _state.displayName.displayError?.text(),
                  ),
                  _StateRow(
                    name: 'DemoEmailInput',
                    value: _state.email.value,
                    isPure: _state.email.isPure,
                    errorText: _state.email.displayError?.text(),
                  ),
                  _StateRow(
                    name: 'PasswordInput',
                    value: _state.password.value.isEmpty
                        ? ''
                        : '*' * _state.password.value.length,
                    isPure: _state.password.isPure,
                    errorText: _state.password.displayError?.text(),
                  ),
                  _StateRow(
                    name: 'ConfirmPasswordInput',
                    value: _state.confirmPassword.value.isEmpty
                        ? ''
                        : '*' * _state.confirmPassword.value.length,
                    isPure: _state.confirmPassword.isPure,
                    errorText: _state.confirmPassword.displayError?.text(),
                  ),
                  _StateRow(
                    name: 'RoleInput',
                    value: _state.role.value,
                    isPure: _state.role.isPure,
                    errorText: _state.role.displayError?.text(),
                  ),
                  _StateRow(
                    name: 'AcceptTermsInput',
                    value: _state.acceptTerms.value.toString(),
                    isPure: _state.acceptTerms.isPure,
                    errorText: _state.acceptTerms.displayError?.text(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: 'Submission Summary',
              subtitle:
                  'The result card uses normal Flutter text widgets and reads from the combined formz state.',
            ),
            const SizedBox(height: 12),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Latest outcome',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_state.submittedSummary),
                    const SizedBox(height: 16),
                    Text(
                      'Computed flags',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('isValid: ${_state.isValid}'),
                    Text('isPure: ${_state.isPure}'),
                    Text('status: ${_state.status.name}'),
                  ],
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

class DemoSignupState with FormzMixin {
  const DemoSignupState({
    this.displayName = const DisplayNameInput.pure(),
    this.email = const DemoEmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const ConfirmPasswordInput.pure(),
    this.role = const RoleInput.pure(),
    this.acceptTerms = const AcceptTermsInput.pure(),
    this.subscribeToNews = true,
    this.showValidation = false,
    this.status = FormzSubmissionStatus.initial,
    this.submittedSummary = 'Submit the form to see a combined result here.',
  });

  final DisplayNameInput displayName;
  final DemoEmailInput email;
  final PasswordInput password;
  final ConfirmPasswordInput confirmPassword;
  final RoleInput role;
  final AcceptTermsInput acceptTerms;
  final bool subscribeToNews;
  final bool showValidation;
  final FormzSubmissionStatus status;
  final String submittedSummary;

  DemoSignupState copyWith({
    DisplayNameInput? displayName,
    DemoEmailInput? email,
    PasswordInput? password,
    ConfirmPasswordInput? confirmPassword,
    RoleInput? role,
    AcceptTermsInput? acceptTerms,
    bool? subscribeToNews,
    bool? showValidation,
    FormzSubmissionStatus? status,
    String? submittedSummary,
  }) {
    return DemoSignupState(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      role: role ?? this.role,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      subscribeToNews: subscribeToNews ?? this.subscribeToNews,
      showValidation: showValidation ?? this.showValidation,
      status: status ?? this.status,
      submittedSummary: submittedSummary ?? this.submittedSummary,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs =>
      <FormzInput<dynamic, dynamic>>[
        displayName,
        email,
        password,
        confirmPassword,
        role,
        acceptTerms,
      ];
}

enum DisplayNameValidationError { empty, tooShort }

class DisplayNameInput extends FormzInput<String, DisplayNameValidationError> {
  const DisplayNameInput.pure([super.value = '']) : super.pure();

  const DisplayNameInput.dirty([super.value = '']) : super.dirty();

  @override
  DisplayNameValidationError? validator(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return DisplayNameValidationError.empty;
    }
    if (trimmed.length < 3) {
      return DisplayNameValidationError.tooShort;
    }
    return null;
  }
}

enum DemoEmailValidationError { empty, invalid }

class DemoEmailInput extends FormzInput<String, DemoEmailValidationError> {
  const DemoEmailInput.pure([super.value = '']) : super.pure();

  const DemoEmailInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  @override
  DemoEmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return DemoEmailValidationError.empty;
    }
    if (!_emailPattern.hasMatch(value)) {
      return DemoEmailValidationError.invalid;
    }
    return null;
  }
}

enum PasswordValidationError { empty, tooShort, missingLetter, missingNumber }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure([super.value = '']) : super.pure();

  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (value.length < 8) {
      return PasswordValidationError.tooShort;
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return PasswordValidationError.missingLetter;
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return PasswordValidationError.missingNumber;
    }
    return null;
  }
}

enum ConfirmPasswordValidationError { empty, mismatch }

class ConfirmPasswordInput
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPasswordInput.pure({this.password = '', String value = ''})
    : super.pure(value);

  const ConfirmPasswordInput.dirty({required this.password, String value = ''})
    : super.dirty(value);

  final String password;

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmPasswordValidationError.empty;
    }
    if (value != password) {
      return ConfirmPasswordValidationError.mismatch;
    }
    return null;
  }
}

enum RoleValidationError { empty }

class RoleInput extends FormzInput<String, RoleValidationError> {
  const RoleInput.pure([super.value = '']) : super.pure();

  const RoleInput.dirty([super.value = '']) : super.dirty();

  @override
  RoleValidationError? validator(String value) {
    if (value.isEmpty) {
      return RoleValidationError.empty;
    }
    return null;
  }
}

enum AcceptTermsValidationError { notAccepted }

class AcceptTermsInput extends FormzInput<bool, AcceptTermsValidationError> {
  const AcceptTermsInput.pure([super.value = false]) : super.pure();

  const AcceptTermsInput.dirty([super.value = false]) : super.dirty();

  @override
  AcceptTermsValidationError? validator(bool value) {
    if (!value) {
      return AcceptTermsValidationError.notAccepted;
    }
    return null;
  }
}

extension on DisplayNameValidationError {
  String text() {
    switch (this) {
      case DisplayNameValidationError.empty:
        return 'Please enter a display name.';
      case DisplayNameValidationError.tooShort:
        return 'Use at least 3 characters.';
    }
  }
}

extension on DemoEmailValidationError {
  String text() {
    switch (this) {
      case DemoEmailValidationError.empty:
        return 'Please enter an email address.';
      case DemoEmailValidationError.invalid:
        return 'Enter a valid email address.';
    }
  }
}

extension on PasswordValidationError {
  String text() {
    switch (this) {
      case PasswordValidationError.empty:
        return 'Please enter a password.';
      case PasswordValidationError.tooShort:
        return 'Use at least 8 characters.';
      case PasswordValidationError.missingLetter:
        return 'Include at least one letter.';
      case PasswordValidationError.missingNumber:
        return 'Include at least one number.';
    }
  }
}

extension on ConfirmPasswordValidationError {
  String text() {
    switch (this) {
      case ConfirmPasswordValidationError.empty:
        return 'Please confirm the password.';
      case ConfirmPasswordValidationError.mismatch:
        return 'The passwords do not match.';
    }
  }
}

extension on RoleValidationError {
  String text() {
    switch (this) {
      case RoleValidationError.empty:
        return 'Please select a role.';
    }
  }
}

extension on AcceptTermsValidationError {
  String text() {
    switch (this) {
      case AcceptTermsValidationError.notAccepted:
        return 'You must accept the terms before submitting.';
    }
  }
}

extension on FormzSubmissionStatus {
  String get label {
    if (isInitial) {
      return 'Status: initial';
    }
    if (isInProgress) {
      return 'Status: submitting';
    }
    if (isSuccess) {
      return 'Status: success';
    }
    if (isFailure) {
      return 'Status: failure';
    }
    if (isCanceled) {
      return 'Status: canceled';
    }
    return 'Status: ${name.toLowerCase()}';
  }

  Color get color {
    if (isSuccess) {
      return Colors.green;
    }
    if (isFailure) {
      return Colors.redAccent;
    }
    if (isInProgress) {
      return Colors.blue;
    }
    return Colors.blueGrey;
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
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}

class _StateChip extends StatelessWidget {
  const _StateChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.14),
      side: BorderSide(color: color.withValues(alpha: 0.35)),
    );
  }
}

class _StateRow extends StatelessWidget {
  const _StateRow({
    required this.name,
    required this.value,
    required this.isPure,
    required this.errorText,
  });

  final String name;
  final String value;
  final bool isPure;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(
        'value: ${value.isEmpty ? '(empty)' : value}\nstate: ${isPure ? 'pure' : 'dirty'}${errorText == null ? '' : '\nerror: $errorText'}',
      ),
      trailing: Icon(
        errorText == null ? Icons.check_circle_outline : Icons.error_outline,
        color: errorText == null ? Colors.green : Colors.orange,
      ),
    );
  }
}
