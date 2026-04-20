import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart' as logging;

@RoutePage()
class ChopperPage extends StatefulWidget {
  const ChopperPage({super.key});

  @override
  State<ChopperPage> createState() => _ChopperPageState();
}

class _ChopperPageState extends State<ChopperPage> {
  static const List<String> _availableScopes = <String>[
    'profile',
    'stats',
    'tasks',
  ];

  final List<String> _timeline = <String>[
    'Ready. Run any action to inspect Chopper request flow.',
  ];

  late final logging.Logger _logger;
  late final StreamSubscription<logging.LogRecord> _loggerSubscription;
  late final ChopperClient _client;

  bool _isLoading = false;
  bool _includeCompletedTasks = false;
  final Set<String> _selectedScopes = <String>{'profile', 'stats'};
  int _draftPriority = 2;

  String _statusMessage = 'No request has been sent yet.';
  int? _lastStatusCode;
  _UserSnapshot? _userSnapshot;
  _DraftSummary? _draftSummary;
  _ServiceHealth? _serviceHealth;
  Map<String, dynamic>? _convertedError;

  @override
  void initState() {
    super.initState();
    logging.hierarchicalLoggingEnabled = true;
    _logger = logging.Logger('chopper_demo')..level = logging.Level.ALL;
    _loggerSubscription = _logger.onRecord.listen((logging.LogRecord record) {
      _appendTimeline('[logger] ${record.message}');
    });
    _client = ChopperClient(
      baseUrl: Uri.parse('https://demo.local/api'),
      client: _MockChopperHttpClient(),
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
      interceptors: <Interceptor>[
        const HeadersInterceptor(<String, String>{
          'accept': 'application/json',
          'x-demo-client': 'widget_layout_example2',
        }),
        _TimelineInterceptor(_appendTimeline),
        HttpLoggingInterceptor(level: Level.headers, logger: _logger),
      ],
    );
  }

  @override
  void dispose() {
    _loggerSubscription.cancel();
    _client.dispose();
    super.dispose();
  }

  void _appendTimeline(String message) {
    if (!mounted) {
      return;
    }

    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';

    setState(() {
      _timeline.insert(0, '$stamp  $message');
      if (_timeline.length > 18) {
        _timeline.removeRange(18, _timeline.length);
      }
    });
  }

  Future<void> _runAction(
    Future<void> Function() action, {
    required String pendingMessage,
  }) async {
    setState(() {
      _isLoading = true;
      _statusMessage = pendingMessage;
      _convertedError = null;
    });

    try {
      await action();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadUserSnapshot() async {
    await _runAction(() async {
      final Response<Map<String, dynamic>> response = await _client
          .get<Map<String, dynamic>, dynamic>(
            Uri(path: '/users/current'),
            headers: const <String, String>{
              'x-demo-operation': 'load-user-snapshot',
            },
            parameters: <String, dynamic>{
              'scope': _selectedScopes.toList(growable: false),
              'includeCompleted': _includeCompletedTasks,
            },
          );

      final Map<String, dynamic> body =
          response.body ?? const <String, dynamic>{};

      setState(() {
        _lastStatusCode = response.statusCode;
        _userSnapshot = _UserSnapshot.fromJson(body);
        _statusMessage =
            'GET completed with Chopper `get(...)`, headers, query parameters, and JSON conversion.';
      });
    }, pendingMessage: 'Fetching a user snapshot with Chopper GET...');
  }

  Future<void> _createDraft() async {
    await _runAction(() async {
      final Response<Map<String, dynamic>> response = await _client
          .post<Map<String, dynamic>, dynamic>(
            Uri(path: '/drafts'),
            headers: const <String, String>{'x-demo-operation': 'create-draft'},
            body: <String, dynamic>{
              'title': 'Ship a stronger package demo',
              'priority': _draftPriority,
              'published': false,
              'tags': <String>['flutter', 'chopper', 'mock-api'],
            },
          );

      final Map<String, dynamic> body =
          response.body ?? const <String, dynamic>{};

      setState(() {
        _lastStatusCode = response.statusCode;
        _draftSummary = _DraftSummary.fromJson(body);
        _statusMessage =
            'POST completed with JSON request encoding and converted response data.';
      });
    }, pendingMessage: 'Creating a draft with Chopper POST...');
  }

  Future<void> _loadHealth() async {
    await _runAction(
      () async {
        final Request request = Request(
          HttpMethod.Get,
          Uri(path: '/health'),
          _client.baseUrl,
          headers: const <String, String>{'x-demo-operation': 'load-health'},
          parameters: const <String, dynamic>{'verbose': true},
        );

        final Response<_ServiceHealth> response = await _client
            .send<_ServiceHealth, dynamic>(
              request,
              responseConverter: (Response<dynamic> rawResponse) {
                final Map<String, dynamic> json = _decodeJsonObject(
                  rawResponse.body,
                );
                return rawResponse.copyWith<_ServiceHealth>(
                  body: _ServiceHealth.fromJson(json),
                );
              },
            );

        setState(() {
          _lastStatusCode = response.statusCode;
          _serviceHealth = response.body;
          _statusMessage =
              'Raw `Request(...)` + `client.send(...)` mapped the response into a local model.';
        });
      },
      pendingMessage:
          'Sending a raw Chopper request with a custom converter...',
    );
  }

  Future<void> _triggerConvertedError() async {
    await _runAction(
      () async {
        final Response<Map<String, dynamic>> response = await _client
            .get<Map<String, dynamic>, dynamic>(
              Uri(path: '/error-example'),
              headers: const <String, String>{
                'x-demo-operation': 'trigger-error',
              },
            );

        try {
          response.bodyOrThrow;
        } on ChopperHttpException catch (error) {
          final Map<String, dynamic>? converted =
              response.error as Map<String, dynamic>?;

          if (!mounted) {
            return;
          }

          setState(() {
            _lastStatusCode = response.statusCode;
            _convertedError = converted;
            _statusMessage =
                'Error converted by `errorConverter` and surfaced via `bodyOrThrow`.';
          });

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  'Converted ChopperHttpException: ${error.response.statusCode}',
                ),
              ),
            );
        }
      },
      pendingMessage:
          'Calling an endpoint that intentionally returns an error...',
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('chopper Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'chopper provides an HTTP client with interceptors, request/response converters, raw request support, and optional generated services.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates `ChopperClient`, `JsonConverter`, `HeadersInterceptor`, `HttpLoggingInterceptor`, `get`, `post`, raw `Request`, `send`, a custom `responseConverter`, and converted error handling.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Configured client',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The backend is mocked with a custom `http.BaseClient` so the page remains deterministic while still exercising the real Chopper pipeline.',
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const <Widget>[
                        Chip(label: Text('baseUrl: https://demo.local/api')),
                        Chip(label: Text('JsonConverter')),
                        Chip(label: Text('HeadersInterceptor')),
                        Chip(label: Text('HttpLoggingInterceptor')),
                        Chip(label: Text('Custom BaseClient')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const SelectableText(
                        'final client = ChopperClient(\n'
                        "  baseUrl: Uri.parse('https://demo.local/api'),\n"
                        '  converter: const JsonConverter(),\n'
                        '  errorConverter: const JsonConverter(),\n'
                        '  interceptors: [\n'
                        "    const HeadersInterceptor({'accept': 'application/json'}),\n"
                        '    HttpLoggingInterceptor(level: Level.headers),\n'
                        '  ],\n'
                        ');',
                        style: TextStyle(fontFamily: 'monospace', height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Request controls',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Adjust the query parameters and POST payload, then run the demo actions below.',
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableScopes
                          .map((String scope) {
                            final bool selected = _selectedScopes.contains(
                              scope,
                            );
                            return FilterChip(
                              label: Text(scope),
                              selected: selected,
                              onSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    _selectedScopes.add(scope);
                                  } else if (_selectedScopes.length > 1) {
                                    _selectedScopes.remove(scope);
                                  }
                                });
                              },
                            );
                          })
                          .toList(growable: false),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _includeCompletedTasks,
                      title: const Text('Include completed tasks'),
                      subtitle: const Text(
                        'Passed as a GET query parameter for the user snapshot request.',
                      ),
                      onChanged: (bool value) {
                        setState(() => _includeCompletedTasks = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Draft priority: $_draftPriority',
                      style: theme.textTheme.titleMedium,
                    ),
                    Slider(
                      value: _draftPriority.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: '$_draftPriority',
                      onChanged: (double value) {
                        setState(() => _draftPriority = value.round());
                      },
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _isLoading ? null : _loadUserSnapshot,
                          icon: const Icon(Icons.download_outlined),
                          label: const Text('Run GET'),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: _isLoading ? null : _createDraft,
                          icon: const Icon(Icons.send_outlined),
                          label: const Text('Run POST'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _isLoading ? null : _loadHealth,
                          icon: const Icon(Icons.route_outlined),
                          label: const Text('Run Raw Request'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _isLoading ? null : _triggerConvertedError,
                          icon: const Icon(Icons.warning_amber_outlined),
                          label: const Text('Run Error Example'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Request state',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ValueRow(
                      label: 'Loading',
                      value: _isLoading ? 'yes' : 'no',
                    ),
                    _ValueRow(
                      label: 'Selected scopes',
                      value: _selectedScopes.join(', '),
                    ),
                    _ValueRow(
                      label: 'Last status code',
                      value: _lastStatusCode?.toString() ?? 'none',
                    ),
                    _ValueRow(label: 'Status', value: _statusMessage),
                  ],
                ),
              ),
            ),
            if (_userSnapshot != null) ...<Widget>[
              const SizedBox(height: 16),
              _ResultCard(
                title: 'GET result',
                subtitle:
                    'Decoded from JSON into a local model after `client.get(...)`.',
                rows: <MapEntry<String, String>>[
                  MapEntry<String, String>('Name', _userSnapshot!.name),
                  MapEntry<String, String>('Role', _userSnapshot!.role),
                  MapEntry<String, String>(
                    'Open tasks',
                    '${_userSnapshot!.openTaskCount}',
                  ),
                  MapEntry<String, String>(
                    'Completed tasks',
                    '${_userSnapshot!.completedTaskCount}',
                  ),
                  MapEntry<String, String>(
                    'Scopes echoed by backend',
                    _userSnapshot!.scopes.join(', '),
                  ),
                ],
                chips: _userSnapshot!.tags,
              ),
            ],
            if (_draftSummary != null) ...<Widget>[
              const SizedBox(height: 16),
              _ResultCard(
                title: 'POST result',
                subtitle:
                    'The mocked endpoint echoes the JSON body that Chopper encoded for the request.',
                rows: <MapEntry<String, String>>[
                  MapEntry<String, String>('Draft id', _draftSummary!.id),
                  MapEntry<String, String>('Title', _draftSummary!.title),
                  MapEntry<String, String>(
                    'Priority',
                    '${_draftSummary!.priority}',
                  ),
                  MapEntry<String, String>(
                    'Published',
                    _draftSummary!.published ? 'true' : 'false',
                  ),
                ],
                chips: _draftSummary!.tags,
              ),
            ],
            if (_serviceHealth != null) ...<Widget>[
              const SizedBox(height: 16),
              _ResultCard(
                title: 'Raw Request result',
                subtitle:
                    'This section came from `client.send(...)` plus a custom `responseConverter`.',
                rows: <MapEntry<String, String>>[
                  MapEntry<String, String>('Service', _serviceHealth!.service),
                  MapEntry<String, String>(
                    'Environment',
                    _serviceHealth!.environment,
                  ),
                  MapEntry<String, String>(
                    'Latency',
                    _serviceHealth!.latencyLabel,
                  ),
                  MapEntry<String, String>(
                    'Interceptors',
                    '${_serviceHealth!.interceptorCount}',
                  ),
                ],
                chips: _serviceHealth!.capabilities,
              ),
            ],
            if (_convertedError != null) ...<Widget>[
              const SizedBox(height: 16),
              Card(
                clipBehavior: Clip.antiAlias,
                color: colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Converted error body',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The payload below was decoded by `errorConverter` before `bodyOrThrow` raised a `ChopperHttpException`.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._convertedError!.entries.map((
                        MapEntry<String, dynamic> entry,
                      ) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${entry.key}: ${entry.value}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Timeline and interceptor logs',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The custom interceptor records request milestones and the built-in logging interceptor records formatted request and response lines.',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _timeline
                            .map((String line) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  line,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    height: 1.4,
                                  ),
                                ),
                              );
                            })
                            .toList(growable: false),
                      ),
                    ),
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

  Map<String, dynamic> _decodeJsonObject(Object? body) {
    if (body is Map<String, dynamic>) {
      return body;
    }

    if (body is Map) {
      return Map<String, dynamic>.from(body);
    }

    if (body is String && body.isNotEmpty) {
      final Object? decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    }

    return const <String, dynamic>{};
  }
}

class _TimelineInterceptor implements Interceptor {
  const _TimelineInterceptor(this.onLog);

  final void Function(String message) onLog;

  @override
  Future<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    onLog(
      '[interceptor] ${chain.request.method} ${chain.request.url.path} '
      'query=${chain.request.parameters.isEmpty ? '{}' : chain.request.parameters}',
    );
    final Response<BodyType> response = await chain.proceed(chain.request);
    onLog(
      '[interceptor] response ${response.statusCode} '
      'for ${chain.request.method} ${chain.request.url.path}',
    );
    return response;
  }
}

class _MockChopperHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 280));

    final Uri url = request.url;
    final Map<String, dynamic> requestBody = await _readJsonBody(request);

    late final Map<String, dynamic> payload;
    late final int statusCode;

    if (request.method == 'GET' && url.path == '/api/users/current') {
      final List<String> scopes = url.queryParametersAll['scope'] ?? <String>[];
      final bool includeCompleted =
          url.queryParameters['includeCompleted'] == 'true';
      payload = <String, dynamic>{
        'name': 'Flutter Engineer',
        'role': 'Package Demo Author',
        'openTaskCount': 6,
        'completedTaskCount': includeCompleted ? 14 : 0,
        'scopes': scopes,
        'tags': <String>[
          if (scopes.contains('profile')) 'identity',
          if (scopes.contains('stats')) 'metrics',
          if (scopes.contains('tasks')) 'tasks',
        ],
      };
      statusCode = 200;
    } else if (request.method == 'POST' && url.path == '/api/drafts') {
      payload = <String, dynamic>{
        'id': 'draft-2048',
        'title': requestBody['title'] ?? 'Untitled',
        'priority': requestBody['priority'] ?? 1,
        'published': requestBody['published'] ?? false,
        'tags': requestBody['tags'] ?? const <String>[],
      };
      statusCode = 201;
    } else if (request.method == 'GET' && url.path == '/api/health') {
      payload = <String, dynamic>{
        'service': 'mock-chopper-api',
        'environment': 'demo',
        'latencyMs': 42,
        'interceptorCount': 3,
        'capabilities': <String>[
          'converter',
          'errorConverter',
          'raw-request',
          if (url.queryParameters['verbose'] == 'true') 'verbose',
        ],
      };
      statusCode = 200;
    } else if (request.method == 'GET' && url.path == '/api/error-example') {
      payload = <String, dynamic>{
        'error': 'validation_failed',
        'message': 'The mocked endpoint intentionally rejected this request.',
        'hint': 'Inspect response.error after errorConverter runs.',
      };
      statusCode = 422;
    } else {
      payload = <String, dynamic>{
        'error': 'not_found',
        'message':
            'No mocked response exists for ${request.method} ${url.path}.',
      };
      statusCode = 404;
    }

    final List<int> bytes = utf8.encode(jsonEncode(payload));
    return http.StreamedResponse(
      Stream<List<int>>.value(bytes),
      statusCode,
      request: request,
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-demo-endpoint': url.path,
      },
      reasonPhrase: statusCode >= 400 ? 'Error' : 'OK',
    );
  }

  Future<Map<String, dynamic>> _readJsonBody(http.BaseRequest request) async {
    final List<int> bytes = await request.finalize().toBytes();
    if (bytes.isEmpty) {
      return const <String, dynamic>{};
    }
    final Object? decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return const <String, dynamic>{};
  }
}

class _UserSnapshot {
  const _UserSnapshot({
    required this.name,
    required this.role,
    required this.openTaskCount,
    required this.completedTaskCount,
    required this.scopes,
    required this.tags,
  });

  factory _UserSnapshot.fromJson(Map<String, dynamic> json) {
    return _UserSnapshot(
      name: json['name'] as String? ?? 'Unknown',
      role: json['role'] as String? ?? 'Unknown',
      openTaskCount: json['openTaskCount'] as int? ?? 0,
      completedTaskCount: json['completedTaskCount'] as int? ?? 0,
      scopes: (json['scopes'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic value) => '$value')
          .toList(growable: false),
      tags: (json['tags'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic value) => '$value')
          .toList(growable: false),
    );
  }

  final String name;
  final String role;
  final int openTaskCount;
  final int completedTaskCount;
  final List<String> scopes;
  final List<String> tags;
}

class _DraftSummary {
  const _DraftSummary({
    required this.id,
    required this.title,
    required this.priority,
    required this.published,
    required this.tags,
  });

  factory _DraftSummary.fromJson(Map<String, dynamic> json) {
    return _DraftSummary(
      id: json['id'] as String? ?? 'unknown',
      title: json['title'] as String? ?? 'Untitled',
      priority: json['priority'] as int? ?? 0,
      published: json['published'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic value) => '$value')
          .toList(growable: false),
    );
  }

  final String id;
  final String title;
  final int priority;
  final bool published;
  final List<String> tags;
}

class _ServiceHealth {
  const _ServiceHealth({
    required this.service,
    required this.environment,
    required this.latencyMs,
    required this.interceptorCount,
    required this.capabilities,
  });

  factory _ServiceHealth.fromJson(Map<String, dynamic> json) {
    return _ServiceHealth(
      service: json['service'] as String? ?? 'unknown',
      environment: json['environment'] as String? ?? 'unknown',
      latencyMs: json['latencyMs'] as int? ?? 0,
      interceptorCount: json['interceptorCount'] as int? ?? 0,
      capabilities:
          (json['capabilities'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic value) => '$value')
              .toList(growable: false),
    );
  }

  final String service;
  final String environment;
  final int latencyMs;
  final int interceptorCount;
  final List<String> capabilities;

  String get latencyLabel => '$latencyMs ms';
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.title,
    required this.subtitle,
    required this.rows,
    required this.chips,
  });

  final String title;
  final String subtitle;
  final List<MapEntry<String, String>> rows;
  final List<String> chips;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 16),
            ...rows.map(
              (MapEntry<String, String> row) =>
                  _ValueRow(label: row.key, value: row.value),
            ),
            if (chips.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: chips
                    .map((String value) => Chip(label: Text(value)))
                    .toList(growable: false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
