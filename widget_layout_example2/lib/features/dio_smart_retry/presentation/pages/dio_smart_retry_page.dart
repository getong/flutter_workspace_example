import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.dioSmartRetry)
class DioSmartRetryPage extends StatefulWidget {
  const DioSmartRetryPage({super.key});

  @override
  State<DioSmartRetryPage> createState() => _DioSmartRetryPageState();
}

class _DioSmartRetryPageState extends State<DioSmartRetryPage> {
  final List<String> _logLines = <String>[];

  int _statusCode = 503;
  int _failuresBeforeSuccess = 2;
  int _adapterCallCount = 0;
  bool _useCustomEvaluator = false;
  bool _disableRetryForRequest = false;
  bool _isRunning = false;
  String _status =
      'Configure the fake adapter and send a request to inspect retry behavior.';

  Future<void> _runScenario() async {
    setState(() {
      _isRunning = true;
      _logLines.clear();
      _adapterCallCount = 0;
      _status = 'Running request through Dio and RetryInterceptor.';
    });

    final Dio dio = Dio();
    dio.httpClientAdapter = _ScenarioAdapter(
      onFetch: (RequestOptions options) async {
        _adapterCallCount += 1;
        final int callNumber = _adapterCallCount;
        _appendLog(
          'adapter fetch #$callNumber • path=${options.path} • stored attempt=${options.attempt}',
        );

        if (callNumber <= _failuresBeforeSuccess) {
          return ResponseBody.fromString(
            '{"ok":false,"call":$callNumber,"status":$_statusCode}',
            _statusCode,
            headers: <String, List<String>>{
              Headers.contentTypeHeader: <String>['application/json'],
            },
          );
        }

        return ResponseBody.fromString(
          '{"ok":true,"call":$callNumber,"message":"recovered after retries"}',
          200,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>['application/json'],
          },
        );
      },
    );

    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: 3,
        retryDelays: const <Duration>[
          Duration.zero,
          Duration(milliseconds: 250),
          Duration(milliseconds: 700),
        ],
        retryableExtraStatuses: _useCustomEvaluator
            ? <int>{}
            : (_statusCode == 429 ? <int>{429} : <int>{}),
        retryEvaluator: _useCustomEvaluator
            ? (DioException error, int attempt) {
                final int? status = error.response?.statusCode;
                final bool shouldRetry = status == 429 || status == 503;
                _appendLog(
                  'retryEvaluator attempt=$attempt • status=$status • retry=$shouldRetry',
                );
                return shouldRetry;
              }
            : null,
        logPrint: _appendLog,
      ),
    );

    final Options options = Options();
    options.disableRetry = _disableRetryForRequest;

    try {
      final Response<dynamic> response = await dio.get<dynamic>(
        '/catalog',
        options: options,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _status =
            'Request completed with HTTP ${response.statusCode} after $_adapterCallCount adapter calls.';
      });
      _appendLog('final response data=${response.data}');
    } on DioException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status =
            'Request failed with HTTP ${error.response?.statusCode ?? 'none'} after $_adapterCallCount adapter calls.';
      });
      _appendLog(
        'final DioException type=${error.type} • status=${error.response?.statusCode}',
      );
    } finally {
      dio.close(force: true);
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
    }
  }

  void _appendLog(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    if (!mounted) {
      return;
    }
    setState(() {
      _logLines.insert(0, '$stamp  $message');
      if (_logLines.length > 18) {
        _logLines.removeRange(18, _logLines.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('dio_smart_retry Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'dio_smart_retry adds a retry interceptor to Dio so transient HTTP failures can be retried with configurable delays and custom retry rules.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `RetryInterceptor`, `retryDelays`, `retryableExtraStatuses`, `retryEvaluator`, and the per-request `disableRetry` flag without relying on a real network endpoint.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Scenario Controls',
              description:
                  'The page swaps Dio onto a fake adapter that returns a chosen status code for a few calls before succeeding. That lets the retry interceptor show its behavior deterministically.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Simulated status code',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      ChoiceChip(
                        label: const Text('503 Service Unavailable'),
                        selected: _statusCode == 503,
                        onSelected: (bool selected) {
                          if (!selected) {
                            return;
                          }
                          setState(() {
                            _statusCode = 503;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('429 Too Many Requests'),
                        selected: _statusCode == 429,
                        onSelected: (bool selected) {
                          if (!selected) {
                            return;
                          }
                          setState(() {
                            _statusCode = 429;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Failures before success: $_failuresBeforeSuccess',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Slider(
                    value: _failuresBeforeSuccess.toDouble(),
                    min: 0,
                    max: 3,
                    divisions: 3,
                    label: _failuresBeforeSuccess.toString(),
                    onChanged: (double value) {
                      setState(() {
                        _failuresBeforeSuccess = value.round();
                      });
                    },
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilterChip(
                        label: const Text('Use custom retryEvaluator'),
                        selected: _useCustomEvaluator,
                        onSelected: (bool value) {
                          setState(() {
                            _useCustomEvaluator = value;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text('Disable retry on request'),
                        selected: _disableRetryForRequest,
                        onSelected: (bool value) {
                          setState(() {
                            _disableRetryForRequest = value;
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
                        onPressed: _isRunning ? null : _runScenario,
                        icon: const Icon(Icons.http_outlined),
                        label: const Text('Send Demo Request'),
                      ),
                      Chip(label: Text('Adapter calls: $_adapterCallCount')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Execution Summary',
              description:
                  'The summary below reflects the current run and shows whether the retry interceptor reached a success response or stopped early.',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_status),
                      const SizedBox(height: 12),
                      Text(
                        'Configured delays: 0ms, 250ms, 700ms • Retries: 3',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current mode: ${_useCustomEvaluator ? 'custom retryEvaluator' : (_statusCode == 429 ? 'default evaluator + retryableExtraStatuses {429}' : 'default evaluator')}${_disableRetryForRequest ? ' + request disableRetry=true' : ''}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Log Output',
              description:
                  'The retry interceptor logs each retry decision, and the adapter logs every fetch so you can compare request attempts with actual transport calls.',
              child: _logLines.isEmpty
                  ? Text(
                      'No run yet. Send the demo request to populate the retry log.',
                      style: theme.textTheme.bodyMedium,
                    )
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _logLines
                              .map(
                                (String line) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    line,
                                    style: const TextStyle(
                                      color: Color(0xFFE2E8F0),
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
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

class _ScenarioAdapter implements HttpClientAdapter {
  _ScenarioAdapter({required this.onFetch});

  final Future<ResponseBody> Function(RequestOptions options) onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return onFetch(options);
  }

  @override
  void close({bool force = false}) {}
}
