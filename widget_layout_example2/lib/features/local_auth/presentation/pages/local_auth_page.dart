import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.localAuth)
class LocalAuthPage extends StatefulWidget {
  const LocalAuthPage({super.key});

  @override
  State<LocalAuthPage> createState() => _LocalAuthPageState();
}

class _LocalAuthPageState extends State<LocalAuthPage> {
  final LocalAuthentication _auth = LocalAuthentication();
  final TextEditingController _reasonController = TextEditingController(
    text: 'Authenticate to unlock the local_auth demo module.',
  );

  bool? _canCheckBiometrics;
  bool? _isDeviceSupported;
  List<BiometricType> _availableBiometrics = <BiometricType>[];
  bool _biometricOnly = false;
  bool _persistAcrossBackgrounding = true;
  bool _sensitiveTransaction = true;
  bool _isAuthenticating = false;
  String _status =
      'Refresh capability data to inspect hardware support and enrolled biometrics.';
  String _result = 'No authentication has been attempted yet.';
  String? _lastError;
  List<String> _eventLog = <String>[];

  @override
  void initState() {
    super.initState();
    _refreshCapabilities();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _appendEvent(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    _eventLog = <String>['$stamp  $message', ..._eventLog].take(12).toList();
  }

  String _boolLabel(bool? value) {
    if (value == null) {
      return 'unknown';
    }

    return value ? 'true' : 'false';
  }

  String _biometricLabel(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'face';
      case BiometricType.fingerprint:
        return 'fingerprint';
      case BiometricType.iris:
        return 'iris';
      case BiometricType.strong:
        return 'strong';
      case BiometricType.weak:
        return 'weak';
    }
  }

  String _exceptionSummary(LocalAuthException error) {
    final String description = error.description?.trim() ?? '';
    if (description.isEmpty) {
      return error.code.name;
    }

    return '${error.code.name}: $description';
  }

  Future<void> _refreshCapabilities() async {
    setState(() {
      _status =
          'Checking `canCheckBiometrics`, `isDeviceSupported()`, and enrolled biometrics.';
      _lastError = null;
    });

    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      final List<BiometricType> availableBiometrics = await _auth
          .getAvailableBiometrics();

      if (!mounted) {
        return;
      }

      setState(() {
        _canCheckBiometrics = canCheckBiometrics;
        _isDeviceSupported = isDeviceSupported;
        _availableBiometrics = availableBiometrics;
        _status = 'Capability refresh completed successfully.';
        _appendEvent(
          'refresh -> canCheckBiometrics=$canCheckBiometrics, '
          'isDeviceSupported=$isDeviceSupported, '
          'enrolled=${availableBiometrics.map(_biometricLabel).join(', ')}',
        );
      });
    } on LocalAuthException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _lastError = _exceptionSummary(error);
        _status = 'Capability refresh failed with LocalAuthException.';
        _appendEvent('refresh error -> ${error.code.name}');
      });
    } on MissingPluginException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _lastError = error.message ?? error.toString();
        _status =
            'This platform does not provide a `local_auth` implementation in the current build.';
        _appendEvent('refresh missing plugin');
      });
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _lastError = error.message ?? error.toString();
        _status = 'Capability refresh failed with PlatformException.';
        _appendEvent('refresh platform error -> ${error.code}');
      });
    }
  }

  Future<void> _authenticate() async {
    final String reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      setState(() {
        _status =
            'Provide a non-empty `localizedReason` before authenticating.';
      });
      return;
    }

    try {
      setState(() {
        _isAuthenticating = true;
        _lastError = null;
        _result = 'Authentication prompt requested.';
        _status =
            'Calling `authenticate()` with biometricOnly=$_biometricOnly, '
            'persistAcrossBackgrounding=$_persistAcrossBackgrounding, '
            'sensitiveTransaction=$_sensitiveTransaction.';
        _appendEvent(
          'authenticate -> biometricOnly=$_biometricOnly, '
          'persistAcrossBackgrounding=$_persistAcrossBackgrounding, '
          'sensitiveTransaction=$_sensitiveTransaction',
        );
      });

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: _biometricOnly,
        persistAcrossBackgrounding: _persistAcrossBackgrounding,
        sensitiveTransaction: _sensitiveTransaction,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isAuthenticating = false;
        _result = didAuthenticate
            ? 'Authenticated successfully.'
            : 'Authentication finished without success.';
        _status = 'authenticate() completed with `$didAuthenticate`.';
        _appendEvent('authenticate result -> $didAuthenticate');
      });
    } on LocalAuthException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isAuthenticating = false;
        _lastError = _exceptionSummary(error);
        _result = 'Authentication failed with LocalAuthException.';
        _status = 'authenticate() threw `${error.code.name}`.';
        _appendEvent('authenticate error -> ${error.code.name}');
      });
    } on MissingPluginException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isAuthenticating = false;
        _lastError = error.message ?? error.toString();
        _result = 'Authentication could not start on this platform.';
        _status = 'No `local_auth` implementation is registered here.';
        _appendEvent('authenticate missing plugin');
      });
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isAuthenticating = false;
        _lastError = error.message ?? error.toString();
        _result = 'Authentication failed with PlatformException.';
        _status = 'authenticate() failed with platform code `${error.code}`.';
        _appendEvent('authenticate platform error -> ${error.code}');
      });
    }
  }

  Future<void> _cancelAuthentication() async {
    try {
      final bool didCancel = await _auth.stopAuthentication();
      if (!mounted) {
        return;
      }

      setState(() {
        _isAuthenticating = false;
        _status = 'stopAuthentication() returned `$didCancel`.';
        _result = didCancel
            ? 'An in-flight authentication request was canceled.'
            : 'No authentication request was canceled.';
        _appendEvent('stopAuthentication -> $didCancel');
      });
    } on MissingPluginException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isAuthenticating = false;
        _lastError = error.message ?? error.toString();
        _status = 'stopAuthentication() is unavailable on this platform.';
        _appendEvent('stopAuthentication missing plugin');
      });
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isAuthenticating = false;
        _lastError = error.message ?? error.toString();
        _status = 'stopAuthentication() failed with `${error.code}`.';
        _appendEvent('stopAuthentication platform error -> ${error.code}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('local_auth Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Use `local_auth` to query device-authentication capability and trigger biometric or device-credential prompts from Flutter.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This module demonstrates `canCheckBiometrics`, `isDeviceSupported()`, `getAvailableBiometrics()`, `authenticate()`, and `stopAuthentication()` while also showing more Flutter widget usage through cards, chips, switches, buttons, text fields, and event logs.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(_status),
                  const SizedBox(height: 8),
                  Text(
                    _result,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_lastError != null) ...<Widget>[
                    const SizedBox(height: 12),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          'Last error: $_lastError',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (_isAuthenticating) ...<Widget>[
                    const SizedBox(height: 16),
                    const LinearProgressIndicator(),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Capability Snapshot',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _CapabilityTile(
                    icon: Icons.memory_outlined,
                    label: 'canCheckBiometrics',
                    value: _boolLabel(_canCheckBiometrics),
                    description:
                        'True when biometric hardware is available for checks.',
                  ),
                  _CapabilityTile(
                    icon: Icons.phone_android_outlined,
                    label: 'isDeviceSupported()',
                    value: _boolLabel(_isDeviceSupported),
                    description:
                        'True when biometrics or other local device credentials are supported.',
                  ),
                  _CapabilityTile(
                    icon: Icons.fingerprint,
                    label: 'Enrolled biometrics',
                    value: _availableBiometrics.isEmpty
                        ? 'none reported'
                        : '${_availableBiometrics.length}',
                    description:
                        'Use `getAvailableBiometrics()` to inspect what the OS reports as enrolled.',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _availableBiometrics.isEmpty
                        ? <Widget>[
                            const Chip(
                              label: Text('No enrolled biometrics reported'),
                            ),
                          ]
                        : _availableBiometrics
                              .map(
                                (BiometricType type) => Chip(
                                  avatar: const Icon(Icons.verified_user),
                                  label: Text(_biometricLabel(type)),
                                ),
                              )
                              .toList(),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _refreshCapabilities,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Capabilities'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isAuthenticating
                            ? _cancelAuthentication
                            : null,
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancel Prompt'),
                      ),
                    ],
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
                    'Authentication Options',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _reasonController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'localizedReason',
                      border: OutlineInputBorder(),
                      helperText:
                          'This message is shown by the operating system in the authentication prompt.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _biometricOnly,
                    title: const Text('biometricOnly'),
                    subtitle: const Text(
                      'Require biometrics instead of allowing passcode, PIN, or pattern fallback when supported.',
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        _biometricOnly = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _persistAcrossBackgrounding,
                    title: const Text('persistAcrossBackgrounding'),
                    subtitle: const Text(
                      'Retry the prompt when the app returns to foreground instead of failing immediately after backgrounding.',
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        _persistAcrossBackgrounding = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _sensitiveTransaction,
                    title: const Text('sensitiveTransaction'),
                    subtitle: const Text(
                      'Keep platform safeguards enabled for higher-sensitivity authentication flows.',
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        _sensitiveTransaction = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilterChip(
                        label: const Text('Biometric-only preset'),
                        selected: _biometricOnly && _sensitiveTransaction,
                        onSelected: (_) {
                          setState(() {
                            _biometricOnly = true;
                            _sensitiveTransaction = true;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text('Flexible fallback preset'),
                        selected:
                            !_biometricOnly && _persistAcrossBackgrounding,
                        onSelected: (_) {
                          setState(() {
                            _biometricOnly = false;
                            _persistAcrossBackgrounding = true;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _isAuthenticating ? null : _authenticate,
                        icon: const Icon(Icons.lock_open_outlined),
                        label: const Text('Authenticate'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isAuthenticating
                            ? _cancelAuthentication
                            : null,
                        icon: const Icon(Icons.pause_circle_outline),
                        label: const Text('Stop Authentication'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Core local_auth Pattern',
              code: r'''
final LocalAuthentication auth = LocalAuthentication();

final bool canCheckBiometrics = await auth.canCheckBiometrics;
final bool canAuthenticate =
    canCheckBiometrics || await auth.isDeviceSupported();

final List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();

final bool didAuthenticate = await auth.authenticate(
  localizedReason: 'Authenticate to unlock the demo',
  biometricOnly: true,
  persistAcrossBackgrounding: true,
  sensitiveTransaction: true,
);

final bool didCancel = await auth.stopAuthentication();
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

class _CapabilityTile extends StatelessWidget {
  const _CapabilityTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(description),
      trailing: Chip(label: Text(value)),
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
                'No plugin calls have been logged yet.',
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
