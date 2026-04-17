import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'DioRoute')
class DioPage extends StatefulWidget {
  const DioPage({super.key});

  @override
  State<DioPage> createState() => _DioPageState();
}

class _DioPageState extends State<DioPage> {
  late final _DioDemoService _service;
  final List<_DioLogEntry> _logs = <_DioLogEntry>[];

  CancelToken? _activeCancelToken;
  List<_PostPreview> _posts = const <_PostPreview>[];
  String _statusMessage = 'No request has been sent yet.';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _service = _DioDemoService(_appendLog);
  }

  @override
  void dispose() {
    _cancelActiveRequest(showSnackBar: false);
    _service.dispose();
    super.dispose();
  }

  void _appendLog(_DioLogEntry entry) {
    if (!mounted) {
      return;
    }

    setState(() {
      _logs.insert(0, entry);
      if (_logs.length > 12) {
        _logs.removeRange(12, _logs.length);
      }
    });
  }

  void _cancelActiveRequest({bool showSnackBar = true}) {
    final CancelToken? cancelToken = _activeCancelToken;
    if (cancelToken == null || cancelToken.isCancelled) {
      return;
    }

    cancelToken.cancel('Cancelled from the dio demo page.');
    if (showSnackBar && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Active Dio request cancelled.')),
      );
    }
  }

  Future<void> _loadPosts() async {
    final CancelToken cancelToken = CancelToken();

    setState(() {
      _activeCancelToken = cancelToken;
      _isLoading = true;
      _statusMessage = 'Fetching posts with query parameters and headers...';
    });

    try {
      final List<_PostPreview> posts = await _service.fetchPosts(
        cancelToken: cancelToken,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _posts = posts;
        _statusMessage =
            'Loaded ${posts.length} posts with Dio GET + query parameters.';
      });
    } on DioException catch (error) {
      _handleDioException(error);
    } finally {
      if (mounted) {
        setState(() {
          if (identical(_activeCancelToken, cancelToken)) {
            _activeCancelToken = null;
          }
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createDraftPost() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Creating a draft post with Dio POST...';
    });

    try {
      final _PostPreview draftPost = await _service.createDraftPost();

      if (!mounted) {
        return;
      }

      setState(() {
        _posts = <_PostPreview>[draftPost, ..._posts];
        _statusMessage =
            'POST completed. Dio encoded the body and decoded the response.';
      });
    } on DioException catch (error) {
      _handleDioException(error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _runErrorExample() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Calling an invalid endpoint to demonstrate errors...';
    });

    try {
      await _service.triggerBadResponse();
    } on DioException catch (error) {
      _handleDioException(error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleDioException(DioException error) {
    if (!mounted) {
      return;
    }

    final String message = _formatDioException(error);
    setState(() {
      _statusMessage = message;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDioException(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      return 'Request cancelled: ${error.message ?? 'unknown reason'}';
    }

    final int? statusCode = error.response?.statusCode;
    if (statusCode != null) {
      return 'Request failed with status $statusCode via DioException.';
    }

    return 'DioException: ${error.message ?? error.type.name}';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('dio Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Dio is a flexible HTTP client for Flutter. This module shows a configured client, interceptors, query parameters, POST bodies, cancellation, and DioException handling.',
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
                      'Configured Dio Client',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'The demo service uses `BaseOptions`, request and response interceptors, `Options(headers: ...)`, query parameters, and `CancelToken` so the page exercises common Dio setup patterns.',
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const <Widget>[
                        Chip(label: Text('BaseOptions')),
                        Chip(label: Text('InterceptorsWrapper')),
                        Chip(label: Text('GET + queryParameters')),
                        Chip(label: Text('POST + JSON body')),
                        Chip(label: Text('CancelToken')),
                        Chip(label: Text('DioException')),
                      ],
                    ),
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
                      'Interactive Requests',
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
                          onPressed: _isLoading ? null : _createDraftPost,
                          icon: const Icon(Icons.upload_outlined),
                          label: const Text('POST Draft'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _isLoading ? _runErrorExample : null,
                          icon: const Icon(Icons.error_outline),
                          label: const Text('Simulate Error'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _activeCancelToken == null
                              ? null
                              : _cancelActiveRequest,
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text('Cancel Request'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.45,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: <Widget>[
                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          Expanded(child: Text(_statusMessage)),
                        ],
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
                    if (_posts.isEmpty)
                      const Text(
                        'No responses rendered yet. Try GET or POST to populate the preview list.',
                      )
                    else
                      ..._posts.map(
                        (_PostPreview post) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(post.title),
                            subtitle: Text(post.body),
                            trailing: post.id == null
                                ? const Chip(label: Text('draft'))
                                : Chip(label: Text('#${post.id}')),
                          ),
                        ),
                      ),
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
                      'Interceptor Timeline',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_logs.isEmpty)
                      const Text(
                        'No interceptor events yet. Send a request to inspect the request and response lifecycle.',
                      )
                    else
                      ..._logs.map(
                        (_DioLogEntry entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(top: 6),
                                decoration: BoxDecoration(
                                  color: entry.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}:${entry.timestamp.second.toString().padLeft(2, '0')}  ${entry.message}',
                                ),
                              ),
                            ],
                          ),
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
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Core dio Pattern',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: SelectableText(
                        _dioSampleCode,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                          height: 1.45,
                        ),
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
}

class _DioDemoService {
  _DioDemoService(this._onLog)
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://jsonplaceholder.typicode.com',
          connectTimeout: const Duration(seconds: 6),
          receiveTimeout: const Duration(seconds: 6),
          headers: const <String, String>{
            'accept': 'application/json',
            'x-demo-client': 'widget_layout_example2',
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          options.extra['startedAt'] = DateTime.now();
          _onLog(
            _DioLogEntry(
              message:
                  'REQUEST ${options.method} ${options.uri} headers=${options.headers.keys.join(', ')}',
              color: const Color(0xFF1D4ED8),
            ),
          );
          handler.next(options);
        },
        onResponse:
            (Response<dynamic> response, ResponseInterceptorHandler handler) {
              final DateTime? startedAt =
                  response.requestOptions.extra['startedAt'] as DateTime?;
              final int elapsedMs = startedAt == null
                  ? 0
                  : DateTime.now().difference(startedAt).inMilliseconds;

              _onLog(
                _DioLogEntry(
                  message:
                      'RESPONSE ${response.statusCode} ${response.requestOptions.path} in ${elapsedMs}ms',
                  color: const Color(0xFF15803D),
                ),
              );
              handler.next(response);
            },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          final bool isCancelled = error.type == DioExceptionType.cancel;
          _onLog(
            _DioLogEntry(
              message:
                  'ERROR ${error.requestOptions.method} ${error.requestOptions.path}: ${error.message}',
              color: isCancelled
                  ? const Color(0xFFB45309)
                  : const Color(0xFFDC2626),
            ),
          );
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  final void Function(_DioLogEntry entry) _onLog;

  Future<List<_PostPreview>> fetchPosts({
    required CancelToken cancelToken,
  }) async {
    final Response<List<dynamic>> response = await _dio.get<List<dynamic>>(
      '/posts',
      cancelToken: cancelToken,
      queryParameters: const <String, dynamic>{
        '_limit': 4,
        '_sort': 'id',
        '_order': 'desc',
      },
      options: Options(
        headers: const <String, String>{'x-demo-action': 'fetch-posts'},
        extra: const <String, String>{'feature': 'dio-get'},
      ),
    );

    final List<dynamic> body = response.data ?? const <dynamic>[];
    return body
        .whereType<Map<String, dynamic>>()
        .map(_PostPreview.fromJson)
        .toList();
  }

  Future<_PostPreview> createDraftPost() async {
    final Response<Map<String, dynamic>>
    response = await _dio.post<Map<String, dynamic>>(
      '/posts',
      data: const <String, dynamic>{
        'title': 'Widget Layout Example',
        'body':
            'Created from the dio module to demonstrate POST bodies and response decoding.',
        'userId': 42,
      },
      options: Options(
        headers: const <String, String>{'x-demo-action': 'create-post'},
        contentType: Headers.jsonContentType,
      ),
    );

    final Map<String, dynamic> body =
        response.data ?? const <String, dynamic>{};
    return _PostPreview.fromJson(body);
  }

  Future<void> triggerBadResponse() async {
    await _dio.get<void>(
      '/invalid-demo-endpoint',
      options: Options(
        headers: const <String, String>{'x-demo-action': 'force-error'},
      ),
    );
  }

  void dispose() {
    _dio.close(force: true);
  }
}

class _PostPreview {
  const _PostPreview({required this.title, required this.body, this.id});

  factory _PostPreview.fromJson(Map<String, dynamic> json) {
    return _PostPreview(
      id: json['id'] as int?,
      title: (json['title'] as String? ?? 'Untitled').trim(),
      body: (json['body'] as String? ?? 'No body').trim(),
    );
  }

  final int? id;
  final String title;
  final String body;
}

class _DioLogEntry {
  _DioLogEntry({required this.message, required this.color})
    : timestamp = DateTime.now();

  final String message;
  final Color color;
  final DateTime timestamp;
}

const String _dioSampleCode = r'''
final dio = Dio(
  BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 6),
    receiveTimeout: const Duration(seconds: 6),
  ),
);

dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      options.extra['startedAt'] = DateTime.now();
      handler.next(options);
    },
    onResponse: (response, handler) {
      handler.next(response);
    },
    onError: (error, handler) {
      handler.next(error);
    },
  ),
);

final cancelToken = CancelToken();

final response = await dio.get<List<dynamic>>(
  '/posts',
  cancelToken: cancelToken,
  queryParameters: {'_limit': 4, '_sort': 'id'},
  options: Options(headers: {'x-demo-action': 'fetch-posts'}),
);
''';
