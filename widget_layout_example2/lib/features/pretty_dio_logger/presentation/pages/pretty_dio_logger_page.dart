import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.prettyDioLogger)
class PrettyDioLoggerPage extends StatefulWidget {
  const PrettyDioLoggerPage({super.key});

  @override
  State<PrettyDioLoggerPage> createState() => _PrettyDioLoggerPageState();
}

class _PrettyDioLoggerPageState extends State<PrettyDioLoggerPage> {
  static const String _loggerSnippet = '''
final Dio dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

dio.interceptors.add(
  PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    logPrint: debugPrint,
  ),
);
''';

  late final Dio _dio;
  final List<String> _logs = <String>[];

  bool _isLoading = false;
  String _statusMessage =
      'Ready. Trigger direct Dio requests to inspect PrettyDioLogger output.';
  List<Map<String, dynamic>> _responses = const <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        compact: true,
        maxWidth: 110,
        logPrint: (Object object) => _appendLog(object.toString()),
      ),
    );
  }

  void _appendLog(String message) {
    if (!mounted) {
      return;
    }

    final String stamp = DateFormat.Hms().format(DateTime.now());
    setState(() {
      _logs.insert(0, '$stamp  $message');
      if (_logs.length > 80) {
        _logs.removeRange(80, _logs.length);
      }
    });
  }

  Future<void> _runRequest(
    Future<Response<dynamic>> Function() action, {
    required String pendingMessage,
    required String successMessage,
  }) async {
    setState(() {
      _isLoading = true;
      _statusMessage = pendingMessage;
    });

    try {
      final Response<dynamic> response = await action();
      final dynamic data = response.data;

      if (!mounted) {
        return;
      }

      setState(() {
        _responses = _normalizeResponse(data);
        _statusMessage = successMessage;
      });
    } on DioException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'DioException: ${error.message ?? error.type.name}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _normalizeResponse(dynamic data) {
    if (data is List) {
      return data
          .take(6)
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (Map<dynamic, dynamic> item) =>
                item.map((dynamic key, dynamic value) {
                  return MapEntry(key.toString(), value);
                }),
          )
          .toList(growable: false);
    }

    if (data is Map<dynamic, dynamic>) {
      return <Map<String, dynamic>>[
        data.map((dynamic key, dynamic value) {
          return MapEntry(key.toString(), value);
        }),
      ];
    }

    return <Map<String, dynamic>>[
      <String, dynamic>{'value': data.toString()},
    ];
  }

  Future<void> _loadPosts() async {
    await _runRequest(
      () => _dio.get<dynamic>(
        '/posts',
        queryParameters: <String, dynamic>{'userId': 1, '_limit': 5},
        options: Options(
          headers: const <String, Object>{'x-demo-operation': 'logger-posts'},
        ),
      ),
      pendingMessage: 'Fetching GET /posts with query parameters...',
      successMessage:
          'Loaded direct-Dio GET data. PrettyDioLogger captured request and response details.',
    );
  }

  Future<void> _loadComments() async {
    await _runRequest(
      () => _dio.get<dynamic>(
        '/comments',
        queryParameters: const <String, dynamic>{'postId': 1, '_limit': 4},
        options: Options(
          headers: const <String, Object>{
            'x-demo-operation': 'logger-comments',
          },
        ),
      ),
      pendingMessage: 'Fetching GET /comments...',
      successMessage:
          'Loaded comment data with PrettyDioLogger still attached to the same client.',
    );
  }

  Future<void> _createPost() async {
    await _runRequest(
      () => _dio.post<dynamic>(
        '/posts',
        data: const <String, dynamic>{
          'userId': 7,
          'title': 'PrettyDioLogger draft',
          'body': 'Logging request and response bodies from direct Dio usage.',
        },
        options: Options(
          headers: const <String, Object>{'x-demo-operation': 'logger-create'},
        ),
      ),
      pendingMessage: 'Posting JSON to /posts...',
      successMessage:
          'POST completed. PrettyDioLogger captured headers, body, and response payload.',
    );
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
      _responses = const <Map<String, dynamic>>[];
      _statusMessage = 'Cleared PrettyDioLogger output.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('pretty_dio_logger Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'pretty_dio_logger is a Dio interceptor, so this page uses plain '
              'Dio requests to make the logging behavior obvious. The log panel '
              'below is fed by the interceptor via a custom `logPrint` callback.',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Direct Dio Actions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _isLoading ? null : _loadPosts,
                          icon: const Icon(Icons.download_outlined),
                          label: const Text('GET Posts'),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: _isLoading ? null : _loadComments,
                          icon: const Icon(Icons.forum_outlined),
                          label: const Text('GET Comments'),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: _isLoading ? null : _createPost,
                          icon: const Icon(Icons.send_outlined),
                          label: const Text('POST Draft'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _clearLogs,
                          icon: const Icon(Icons.cleaning_services_outlined),
                          label: const Text('Clear'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _statusMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const <Widget>[
                        Chip(label: Text('requestHeader: true')),
                        Chip(label: Text('requestBody: true')),
                        Chip(label: Text('responseBody: true')),
                        Chip(label: Text('compact: true')),
                        Chip(label: Text('custom logPrint')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _CodeBlock(code: _loggerSnippet),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'PrettyDioLogger Timeline',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 260,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.45,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _logs.isEmpty
                            ? Center(
                                child: Text(
                                  'Run any request to populate logs.',
                                  style: theme.textTheme.bodySmall,
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(12),
                                itemCount: _logs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      _logs[index],
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(fontFamily: 'monospace'),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_responses.isNotEmpty) ...<Widget>[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Response Preview',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: _responses
                            .map(
                              (Map<String, dynamic> item) =>
                                  _ResponsePreviewCard(item: item),
                            )
                            .toList(growable: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: SelectableText(
        code.trim(),
        style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
      ),
    );
  }
}

class _ResponsePreviewCard extends StatelessWidget {
  const _ResponsePreviewCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          const JsonEncoder.withIndent('  ').convert(item),
          style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
        ),
      ),
    );
  }
}
