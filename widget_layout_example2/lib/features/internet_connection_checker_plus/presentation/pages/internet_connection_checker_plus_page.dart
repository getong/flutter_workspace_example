import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.internetConnectionCheckerPlus)
class InternetConnectionCheckerPlusPage extends StatefulWidget {
  const InternetConnectionCheckerPlusPage({super.key});

  @override
  State<InternetConnectionCheckerPlusPage> createState() =>
      _InternetConnectionCheckerPlusPageState();
}

class _InternetConnectionCheckerPlusPageState
    extends State<InternetConnectionCheckerPlusPage> {
  final InternetConnection _defaultConnection = InternetConnection();
  late final InternetConnection _customConnection;

  StreamSubscription<InternetStatus>? _statusSubscription;
  bool _isCheckingNow = false;
  bool _isListening = false;
  bool _isCustomChecking = false;
  bool? _hasInternetAccess;
  InternetStatus? _currentStatus;
  InternetStatus? _customStatus;
  String _checkMessage =
      'Tap "Check Now" to verify actual internet reachability.';
  String _streamMessage =
      'Tap "Start Listening" to watch connectivity changes over time.';
  String _customMessage =
      'Run a custom endpoint check to see how success rules can be tailored.';
  final List<String> _statusHistory = <String>[];

  @override
  void initState() {
    super.initState();
    _customConnection = InternetConnection.createInstance(
      useDefaultOptions: false,
      customCheckOptions: <InternetCheckOption>[
        InternetCheckOption(
          uri: Uri.parse('https://img.shields.io/pub/'),
          responseStatusFn: (response) => response.statusCode == 404,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkNow() async {
    setState(() {
      _isCheckingNow = true;
      _checkMessage = 'Checking remote endpoints with HEAD requests...';
    });

    try {
      final bool hasInternetAccess = await _defaultConnection.hasInternetAccess;

      if (!mounted) {
        return;
      }

      setState(() {
        _hasInternetAccess = hasInternetAccess;
        _checkMessage = hasInternetAccess
            ? 'At least one endpoint responded successfully, so internet is reachable.'
            : 'No configured endpoint responded successfully, so internet is treated as unavailable.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _checkMessage = 'Connectivity check failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingNow = false;
        });
      }
    }
  }

  Future<void> _runCustomCheck() async {
    setState(() {
      _isCustomChecking = true;
      _customMessage = 'Checking a custom URI with a custom success rule...';
    });

    try {
      final InternetStatus status = await _customConnection.internetStatus;

      if (!mounted) {
        return;
      }

      setState(() {
        _customStatus = status;
        _customMessage = status == InternetStatus.connected
            ? 'The custom rule marked the request as successful because the endpoint returned 404 as expected.'
            : 'The custom rule did not pass, so this custom configuration reported disconnected.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _customMessage = 'Custom check failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCustomChecking = false;
        });
      }
    }
  }

  void _startListening() {
    if (_isListening) {
      return;
    }

    setState(() {
      _isListening = true;
      _streamMessage =
          'Listening to onStatusChange. New events will appear below.';
    });

    _statusSubscription = _defaultConnection.onStatusChange.listen(
      (InternetStatus status) {
        if (!mounted) {
          return;
        }

        final String timestamp = TimeOfDay.fromDateTime(
          DateTime.now(),
        ).format(context);

        setState(() {
          _currentStatus = status;
          _statusHistory.insert(
            0,
            '$timestamp  ${status == InternetStatus.connected ? 'Connected' : 'Disconnected'}',
          );
          if (_statusHistory.length > 6) {
            _statusHistory.removeLast();
          }
        });
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!mounted) {
          return;
        }

        setState(() {
          _streamMessage = 'Status stream failed: $error';
        });
      },
    );
  }

  Future<void> _stopListening() async {
    await _statusSubscription?.cancel();
    _statusSubscription = null;

    if (!mounted) {
      return;
    }

    setState(() {
      _isListening = false;
      _streamMessage =
          'Listening stopped. Start again if you want new status events.';
    });
  }

  Color _statusColor(InternetStatus? status) {
    return switch (status) {
      InternetStatus.connected => Colors.green,
      InternetStatus.disconnected => Colors.red,
      null => Colors.grey,
    };
  }

  String _statusLabel(InternetStatus? status) {
    return switch (status) {
      InternetStatus.connected => 'Connected',
      InternetStatus.disconnected => 'Disconnected',
      null => 'Unknown',
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('internet_connection_checker_plus Module'),
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'internet_connection_checker_plus verifies real internet reachability instead of only checking whether the device is attached to a local network.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This matters because Wi-Fi or mobile data can be "connected" while remote traffic is still blocked by DNS problems, captive portals, or an upstream outage.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _InfoCard(
              title: 'What this package does',
              description:
                  'It sends HEAD requests to well-known endpoints and reports connected only when those reachability checks succeed.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const <Widget>[
                  _TagChip(label: 'Real internet check'),
                  _TagChip(label: 'Future API'),
                  _TagChip(label: 'Stream API'),
                  _TagChip(label: 'Custom endpoints'),
                  _TagChip(label: 'Custom success rules'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: '1. One-time verification',
              description:
                  'Use `hasInternetAccess` or `internetStatus` when you need an on-demand answer before fetching data or retrying a failed request.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _isCheckingNow ? null : _checkNow,
                    icon: const Icon(Icons.wifi_find),
                    label: const Text('Check Now'),
                  ),
                  const SizedBox(height: 16),
                  _StatusBanner(
                    label: _hasInternetAccess == null
                        ? 'Not checked yet'
                        : (_hasInternetAccess!
                              ? 'Internet Reachable'
                              : 'No Internet Reachability'),
                    color: _hasInternetAccess == null
                        ? Colors.grey
                        : (_hasInternetAccess! ? Colors.green : Colors.red),
                  ),
                  const SizedBox(height: 12),
                  if (_isCheckingNow)
                    const LinearProgressIndicator()
                  else
                    Text(_checkMessage),
                  const SizedBox(height: 16),
                  const _CodeBlock(
                    code:
                        'final bool isConnected =\\n'
                        '    await InternetConnection().hasInternetAccess;',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: '2. Continuous monitoring',
              description:
                  'Use `onStatusChange` when your UI should react to connectivity changes while the page stays open.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _isListening ? null : _startListening,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Listening'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isListening ? _stopListening : null,
                        icon: const Icon(Icons.pause),
                        label: const Text('Stop Listening'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _StatusBanner(
                    label: _statusLabel(_currentStatus),
                    color: _statusColor(_currentStatus),
                  ),
                  const SizedBox(height: 12),
                  Text(_streamMessage),
                  const SizedBox(height: 16),
                  const _CodeBlock(
                    code:
                        'final subscription = InternetConnection()\\n'
                        '    .onStatusChange\\n'
                        '    .listen((InternetStatus status) {\\n'
                        '  // update UI\\n'
                        '});',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Recent events',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_statusHistory.isEmpty)
                    const Text('No status events yet.')
                  else
                    ..._statusHistory.map(
                      (String event) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(event),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: '3. Custom success criteria',
              description:
                  'The package can treat a non-200 response as success when that matches your endpoint contract.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _isCustomChecking ? null : _runCustomCheck,
                    icon: const Icon(Icons.tune),
                    label: const Text('Run Custom Check'),
                  ),
                  const SizedBox(height: 16),
                  _StatusBanner(
                    label: _statusLabel(_customStatus),
                    color: _statusColor(_customStatus),
                  ),
                  const SizedBox(height: 12),
                  if (_isCustomChecking)
                    const LinearProgressIndicator()
                  else
                    Text(_customMessage),
                  const SizedBox(height: 16),
                  const _CodeBlock(
                    code:
                        'final connection = InternetConnection.createInstance(\\n'
                        '  useDefaultOptions: false,\\n'
                        '  customCheckOptions: [\\n'
                        '    InternetCheckOption(\\n'
                        "      uri: Uri.parse('https://img.shields.io/pub/'),\\n"
                        '      responseStatusFn: (response) =>\\n'
                        '          response.statusCode == 404,\\n'
                        '    ),\\n'
                        '  ],\\n'
                        ');',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Practical notes',
              description:
                  'Default behavior considers the internet reachable when any configured endpoint succeeds. Strict mode requires all endpoints to succeed, which is better suited to your own custom URI list.',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Default check interval: 10 seconds for stream updates.',
                  ),
                  SizedBox(height: 8),
                  Text('Default endpoint success rule: HTTP status code 200.'),
                  SizedBox(height: 8),
                  Text(
                    'On Web, custom URIs must allow CORS or the check can fail even if the site is online.',
                  ),
                ],
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.circle, size: 12, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        code.replaceAll(r'\n', '\n'),
        style: const TextStyle(
          fontFamily: 'monospace',
          color: Colors.white,
          height: 1.5,
        ),
      ),
    );
  }
}
