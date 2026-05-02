import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.pinput)
class PinputPage extends StatefulWidget {
  const PinputPage({super.key});

  @override
  State<PinputPage> createState() => _PinputPageState();
}

class _PinputPageState extends State<PinputPage> {
  static const int _pinLength = 4;
  static const String _validPin = '2468';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _obscuredController = TextEditingController(
    text: '12',
  );
  final FocusNode _pinFocusNode = FocusNode();

  PinputAutovalidateMode _autovalidateMode = PinputAutovalidateMode.disabled;
  bool _forceErrorState = false;
  bool _showCursor = true;
  String _status =
      'Enter a 4-digit code to inspect validation, theming, and controller helpers.';
  String _lastCompletedPin = 'Nothing completed yet.';
  String _liveValue = '';
  List<String> _eventLog = <String>[];

  @override
  void initState() {
    super.initState();
    _pinController.addListener(_handlePinChanged);
  }

  @override
  void dispose() {
    _pinController.removeListener(_handlePinChanged);
    _pinController.dispose();
    _obscuredController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  PinTheme _buildDefaultPinTheme(ThemeData theme) {
    return PinTheme(
      width: 62,
      height: 64,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
    );
  }

  void _handlePinChanged() {
    setState(() {
      _liveValue = _pinController.text;
    });
  }

  void _appendEvent(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    setState(() {
      _eventLog = <String>['$stamp  $message', ..._eventLog].take(12).toList();
    });
  }

  void _validatePin() {
    setState(() {
      _autovalidateMode = PinputAutovalidateMode.onSubmit;
      _status = 'Manual validation triggered through FormState.validate().';
    });

    final bool isValid = _formKey.currentState?.validate() ?? false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isValid ? 'PIN is valid.' : 'PIN is invalid. Try $_validPin.',
        ),
      ),
    );

    _appendEvent('validate -> $isValid');
  }

  void _submitPin() {
    setState(() {
      _autovalidateMode = PinputAutovalidateMode.onSubmit;
    });

    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() {
        _status = 'Submission blocked because the current PIN is invalid.';
      });
      return;
    }

    setState(() {
      _lastCompletedPin = _pinController.text;
      _status = 'The validated PIN was accepted and stored locally.';
    });
    _appendEvent('submit -> ${_pinController.text}');
  }

  void _setSamplePin() {
    _pinController.setText(_validPin);
    setState(() {
      _status = 'Controller updated the Pinput with setText($_validPin).';
    });
    _appendEvent('controller.setText($_validPin)');
  }

  void _appendDigit(String digit) {
    _pinController.append(digit, _pinLength);
    setState(() {
      _status = 'Controller appended `$digit` using append().';
    });
    _appendEvent('controller.append($digit, $_pinLength)');
  }

  void _deleteDigit() {
    _pinController.delete();
    setState(() {
      _status = 'Controller removed the last digit using delete().';
    });
    _appendEvent('controller.delete()');
  }

  void _clearPin() {
    _pinController.clear();
    setState(() {
      _status = 'The PIN field was cleared with the standard controller API.';
      _forceErrorState = false;
    });
    _appendEvent('controller.clear()');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PinTheme defaultPinTheme = _buildDefaultPinTheme(theme);
    final PinTheme focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: theme.colorScheme.primary, width: 2),
      borderRadius: BorderRadius.circular(18),
    );
    final PinTheme submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: theme.colorScheme.primaryContainer,
      ),
    );
    final PinTheme errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: theme.colorScheme.error, width: 2),
      borderRadius: BorderRadius.circular(18),
    );
    final PinTheme followingPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: theme.colorScheme.surfaceContainerLow,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('pinput Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Use `pinput` to build OTP, passcode, and verification-code fields with state-aware theming, validation, and programmatic controller control.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This module demonstrates `Pinput`, `PinTheme`, `PinputAutovalidateMode`, controller helpers such as `setText`, `append`, `delete`, focus-node control, obscured input, and force-error state.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(_status),
                  const SizedBox(height: 12),
                  Text(
                    'Live value: ${_liveValue.isEmpty ? '(empty)' : _liveValue}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Last completed PIN: $_lastCompletedPin'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Validated Verification Flow',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This example wires Pinput into a Form so validation can run on submit or manually through FormState.validate(). The valid sample PIN is 2468.',
                    ),
                    const SizedBox(height: 20),
                    Pinput(
                      length: _pinLength,
                      controller: _pinController,
                      focusNode: _pinFocusNode,
                      showCursor: _showCursor,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      followingPinTheme: followingPinTheme,
                      errorPinTheme: errorPinTheme,
                      pinputAutovalidateMode: _autovalidateMode,
                      validator: (String? pin) {
                        if (pin == null || pin.length != _pinLength) {
                          return 'Enter a $_pinLength-digit PIN.';
                        }
                        if (pin != _validPin) {
                          return 'Try $_validPin to pass validation.';
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        _appendEvent('onChanged -> $value');
                      },
                      onCompleted: (String pin) {
                        setState(() {
                          _lastCompletedPin = pin;
                          _status = 'onCompleted fired with `$pin`.';
                        });
                        _appendEvent('onCompleted -> $pin');
                      },
                      onSubmitted: (String pin) {
                        setState(() {
                          _status = 'onSubmitted fired with `$pin`.';
                        });
                        _appendEvent('onSubmitted -> $pin');
                      },
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _validatePin,
                          icon: const Icon(Icons.verified_outlined),
                          label: const Text('Validate PIN'),
                        ),
                        FilledButton.icon(
                          onPressed: _submitPin,
                          icon: const Icon(Icons.login_outlined),
                          label: const Text('Submit PIN'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _pinFocusNode.requestFocus,
                          icon: const Icon(Icons.center_focus_strong),
                          label: const Text('Focus'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _pinFocusNode.unfocus,
                          icon: const Icon(Icons.blur_circular),
                          label: const Text('Unfocus'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _showCursor,
                      title: const Text('showCursor'),
                      subtitle: const Text(
                        'Toggle the standard cursor visibility for the main Pinput.',
                      ),
                      onChanged: (bool value) {
                        setState(() {
                          _showCursor = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Controller Playground',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pinput extends TextEditingController with helpers for OTP-like interactions. These are useful when a backend, clipboard flow, or custom keyboard needs to push digits into the field.',
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilledButton(
                        onPressed: _setSamplePin,
                        child: const Text('setText(2468)'),
                      ),
                      OutlinedButton(
                        onPressed: () => _appendDigit('1'),
                        child: const Text('append 1'),
                      ),
                      OutlinedButton(
                        onPressed: () => _appendDigit('8'),
                        child: const Text('append 8'),
                      ),
                      OutlinedButton(
                        onPressed: _deleteDigit,
                        child: const Text('delete()'),
                      ),
                      TextButton(
                        onPressed: _clearPin,
                        child: const Text('clear()'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Controller text: ${_pinController.text.isEmpty ? '(empty)' : _pinController.text}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Obscured And Forced Error States',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This second Pinput shows obscured characters and the manual error-state API. Force-error mode is useful when a server rejects a code after local validation already passed.',
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    controller: _obscuredController,
                    length: _pinLength,
                    obscureText: true,
                    obscuringCharacter: '•',
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    errorPinTheme: errorPinTheme,
                    forceErrorState: _forceErrorState,
                    errorText: _forceErrorState
                        ? 'Server says this code expired.'
                        : null,
                    onCompleted: (String pin) {
                      _appendEvent('obscured onCompleted -> $pin');
                    },
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilterChip(
                        label: const Text('Force error state'),
                        selected: _forceErrorState,
                        onSelected: (bool value) {
                          setState(() {
                            _forceErrorState = value;
                            _status = value
                                ? 'forceErrorState enabled.'
                                : 'forceErrorState disabled.';
                          });
                        },
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _obscuredController.setText('9876');
                          _appendEvent('obscured controller.setText(9876)');
                        },
                        icon: const Icon(Icons.visibility_off_outlined),
                        label: const Text('Fill Obscured'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Core pinput Pattern',
              code: r'''
final formKey = GlobalKey<FormState>();
final pinController = TextEditingController();
final pinFocusNode = FocusNode();

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(12),
  ),
);

Form(
  key: formKey,
  child: Pinput(
    controller: pinController,
    focusNode: pinFocusNode,
    defaultPinTheme: defaultPinTheme,
    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
    validator: (pin) => pin == '2468' ? null : 'Pin is incorrect',
    onCompleted: (pin) => debugPrint(pin),
  ),
);

pinController.setText('2468');
pinController.append('1', 4);
pinController.delete();
pinFocusNode.requestFocus();
''',
            ),
            const SizedBox(height: 16),
            _EventLogCard(entries: _eventLog),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(18), child: child),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            SelectableText(
              code,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventLogCard extends StatelessWidget {
  const _EventLogCard({required this.entries});

  final List<String> entries;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Event Log',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              Text(
                'No callbacks have fired yet.',
                style: theme.textTheme.bodyMedium,
              )
            else
              ...entries.map(
                (String entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SelectableText(
                    entry,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
