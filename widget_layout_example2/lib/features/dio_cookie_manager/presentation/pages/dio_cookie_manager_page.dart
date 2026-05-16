import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.dioCookieManager)
class DioCookieManagerPage extends StatefulWidget {
  const DioCookieManagerPage({super.key});

  @override
  State<DioCookieManagerPage> createState() => _DioCookieManagerPageState();
}

class _DioCookieManagerPageState extends State<DioCookieManagerPage> {
  final List<_DemoLogEntry> _logs = <_DemoLogEntry>[];

  late CookieJar _cookieJar;
  late CookieManager _cookieManager;
  late Dio _dio;

  bool _clientConfigured = false;
  bool _isBusy = false;
  bool _ignoreInvalidCookies = false;

  int _completedScenarios = 0;
  String _statusMessage =
      'Ready. Trigger the login request to watch Dio persist cookies into '
      'CookieJar automatically.';
  String _lastRequestCookieHeader = 'No Cookie header has been attached yet.';
  String _lastResponseBody = '{\n  "hint": "Run a demo action."\n}';

  List<Cookie> _rootCookies = const <Cookie>[];
  List<Cookie> _apiCookies = const <Cookie>[];

  @override
  void initState() {
    super.initState();
    _rebuildClient(
      reason:
          'Created Dio with CookieManager(cookieJar). All requests stay local '
          'through a mock adapter so the demo is deterministic.',
    );
  }

  @override
  void dispose() {
    if (_clientConfigured) {
      _dio.close(force: true);
    }
    super.dispose();
  }

  void _appendLog(_DemoLogEntry entry) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    final _DemoLogEntry stampedEntry = entry.copyWith(time: stamp);

    if (!mounted) {
      _logs.insert(0, stampedEntry);
      return;
    }

    setState(() {
      _logs.insert(0, stampedEntry);
      if (_logs.length > 14) {
        _logs.removeRange(14, _logs.length);
      }
    });
  }

  void _rebuildClient({required String reason}) {
    if (_clientConfigured) {
      _dio.close(force: true);
    }

    _cookieJar = CookieJar();
    _cookieManager = CookieManager(
      _cookieJar,
      ignoreInvalidCookies: _ignoreInvalidCookies,
    );
    _dio =
        Dio(
            BaseOptions(
              baseUrl: _CookieScenarioAdapter.baseUrl,
              responseType: ResponseType.json,
              followRedirects: false,
              validateStatus: (int? statusCode) =>
                  statusCode != null && statusCode < 500,
              headers: <String, Object?>{
                'x-demo-client': 'widget_layout_example2',
              },
            ),
          )
          ..httpClientAdapter = _CookieScenarioAdapter(
            onServerEvent: _appendLog,
          )
          ..interceptors.add(_cookieManager)
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest:
                  (RequestOptions options, RequestInterceptorHandler handler) {
                    final String cookieHeader =
                        options.headers[HttpHeaders.cookieHeader] as String? ??
                        '<empty>';
                    _appendLog(
                      _DemoLogEntry.request(
                        title: '${options.method} ${options.path}',
                        message:
                            'CookieManager injected `$cookieHeader` before the request '
                            'left Dio.',
                      ),
                    );
                    handler.next(options);
                  },
              onResponse:
                  (
                    Response<dynamic> response,
                    ResponseInterceptorHandler handler,
                  ) {
                    final int cookieCount =
                        response.headers[HttpHeaders.setCookieHeader]?.length ??
                        0;
                    _appendLog(
                      _DemoLogEntry.response(
                        title:
                            '${response.statusCode} ${response.requestOptions.path}',
                        message:
                            'Response returned $cookieCount Set-Cookie header(s). '
                            'CookieManager then persisted them into CookieJar.',
                      ),
                    );
                    handler.next(response);
                  },
              onError: (DioException error, ErrorInterceptorHandler handler) {
                _appendLog(
                  _DemoLogEntry.error(
                    title:
                        '${error.requestOptions.method} ${error.requestOptions.path}',
                    message: _describeError(error),
                  ),
                );
                handler.next(error);
              },
            ),
          );

    _clientConfigured = true;

    setState(() {
      _completedScenarios = 0;
      _rootCookies = const <Cookie>[];
      _apiCookies = const <Cookie>[];
      _logs.clear();
      _lastRequestCookieHeader = 'No Cookie header has been attached yet.';
      _lastResponseBody = '{\n  "hint": "Run a demo action."\n}';
      _statusMessage = reason;
    });

    _appendLog(_DemoLogEntry.info(title: 'Client rebuilt', message: reason));
  }

  Future<void> _runBusyAction(Future<void> Function() action) async {
    if (_isBusy) {
      return;
    }

    setState(() {
      _isBusy = true;
    });

    try {
      await action();
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<void> _refreshCookieViews() async {
    final Uri rootUri = Uri.parse('${_CookieScenarioAdapter.baseUrl}/');
    final Uri apiUri = Uri.parse(
      '${_CookieScenarioAdapter.baseUrl}/api/profile',
    );
    final List<Cookie> rootCookies = await _cookieJar.loadForRequest(rootUri);
    final List<Cookie> apiCookies = await _cookieJar.loadForRequest(apiUri);

    if (!mounted) {
      return;
    }

    setState(() {
      _rootCookies = rootCookies;
      _apiCookies = apiCookies;
    });
  }

  Future<void> _storeResponseSnapshot(
    Response<dynamic> response, {
    required String statusMessage,
  }) async {
    await _refreshCookieViews();

    if (!mounted) {
      return;
    }

    setState(() {
      _completedScenarios += 1;
      _statusMessage = statusMessage;
      _lastRequestCookieHeader =
          response.requestOptions.headers[HttpHeaders.cookieHeader]
              as String? ??
          'Request had no Cookie header.';
      _lastResponseBody = _prettyData(response.data);
    });
  }

  Future<void> _runLoginScenario() async {
    await _runBusyAction(() async {
      final Response<Map<String, dynamic>> response = await _dio
          .post<Map<String, dynamic>>(
            '/login',
            data: <String, Object?>{
              'user': 'flutter-demo',
              'source': 'dio_cookie_manager_page',
            },
          );

      await _storeResponseSnapshot(
        response,
        statusMessage:
            'Login completed. CookieManager persisted a root cookie plus a '
            'path-scoped `/api` cookie from the Set-Cookie response headers.',
      );
    });
  }

  Future<void> _runProfileScenario() async {
    await _runBusyAction(() async {
      final Response<Map<String, dynamic>> response = await _dio
          .get<Map<String, dynamic>>('/api/profile');
      final bool authenticated = response.data?['authenticated'] == true;

      await _storeResponseSnapshot(
        response,
        statusMessage: authenticated
            ? 'Profile completed. The request reused stored cookies automatically, and the longer `/api` path cookie was sent before the root cookie.'
            : 'Profile returned 401 because the session cookie was missing. Run Login first to populate the jar.',
      );
    });
  }

  Future<void> _runRedirectScenario() async {
    await _runBusyAction(() async {
      final Response<Map<String, dynamic>> firstResponse = await _dio
          .get<Map<String, dynamic>>('/redirect/start');
      final String? nextLocation = firstResponse.headers.value(
        HttpHeaders.locationHeader,
      );

      if (nextLocation == null) {
        await _storeResponseSnapshot(
          firstResponse,
          statusMessage:
              'Redirect response returned without a Location header, so the demo stopped after the first hop.',
        );
        return;
      }

      final Response<Map<String, dynamic>> secondResponse = await _dio
          .get<Map<String, dynamic>>(nextLocation);

      await _storeResponseSnapshot(
        secondResponse,
        statusMessage:
            'Manual redirect flow completed. The 302 response stored a cookie, '
            'and the follow-up request reused it on the redirected location.',
      );
    });
  }

  Future<void> _runInvalidCookieScenario() async {
    await _runBusyAction(() async {
      try {
        final Response<Map<String, dynamic>> response = await _dio
            .get<Map<String, dynamic>>('/invalid-cookie');
        await _storeResponseSnapshot(
          response,
          statusMessage:
              'Invalid cookie response completed because ignoreInvalidCookies '
              'is enabled, so CookieManager skipped the malformed header.',
        );
      } on DioException catch (error) {
        await _refreshCookieViews();
        if (!mounted) {
          return;
        }

        setState(() {
          _lastResponseBody = _prettyData(<String, String>{
            'error': _describeError(error),
          });
          _statusMessage =
              'CookieManager rejected the malformed Set-Cookie header. Turn on '
              '`ignoreInvalidCookies` to make this scenario succeed.';
        });
      }
    });
  }

  Future<void> _clearJar() async {
    await _runBusyAction(() async {
      await _cookieJar.deleteAll();
      await _refreshCookieViews();

      if (!mounted) {
        return;
      }

      setState(() {
        _lastRequestCookieHeader = 'No Cookie header has been attached yet.';
        _lastResponseBody = '{\n  "hint": "CookieJar was cleared."\n}';
        _statusMessage = 'Cleared all cookies from the in-memory CookieJar.';
      });

      _appendLog(
        _DemoLogEntry.info(
          title: 'CookieJar cleared',
          message: 'Called deleteAll() so the next request starts clean.',
        ),
      );
    });
  }

  void _toggleIgnoreInvalidCookies(bool value) {
    setState(() {
      _ignoreInvalidCookies = value;
    });

    _rebuildClient(
      reason: value
          ? 'Enabled ignoreInvalidCookies and rebuilt the demo client with a fresh CookieJar.'
          : 'Restored strict cookie parsing and rebuilt the demo client with a fresh CookieJar.',
    );
  }

  String _prettyData(Object? data) {
    if (data == null) {
      return 'null';
    }

    if (data is String) {
      return data;
    }

    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  String _describeError(DioException error) {
    final Object? innerError = error.error;
    if (innerError != null) {
      return '$innerError';
    }
    return error.message ?? error.type.name;
  }

  String _cookieHeaderPreview(List<Cookie> cookies) {
    if (cookies.isEmpty) {
      return 'No cookies would be attached for this request scope yet.';
    }

    return CookieManager.getCookies(List<Cookie>.of(cookies));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('dio_cookie_manager Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'dio_cookie_manager connects Dio and cookie_jar through an interceptor. This page shows how cookies are persisted from Set-Cookie headers, injected into later requests, filtered by path, and optionally ignored when malformed.',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _SummaryPanel(
              statusMessage: _statusMessage,
              isBusy: _isBusy,
              completedScenarios: _completedScenarios,
              ignoreInvalidCookies: _ignoreInvalidCookies,
              rootCookieCount: _rootCookies.length,
              apiCookieCount: _apiCookies.length,
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
                      'Interactive Scenarios',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Each button drives the same Dio instance. Watch the cookie tables and request timeline update after every response.',
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _isBusy ? null : _runLoginScenario,
                          icon: const Icon(Icons.login),
                          label: const Text('1. Login'),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: _isBusy ? null : _runProfileScenario,
                          icon: const Icon(Icons.person_search_outlined),
                          label: const Text('2. Load Profile'),
                        ),
                        FilledButton.icon(
                          onPressed: _isBusy ? null : _runRedirectScenario,
                          icon: const Icon(Icons.route_outlined),
                          label: const Text('3. Redirect Flow'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _isBusy ? null : _runInvalidCookieScenario,
                          icon: const Icon(Icons.warning_amber_outlined),
                          label: const Text('4. Invalid Cookie'),
                        ),
                        TextButton.icon(
                          onPressed: _isBusy ? null : _clearJar,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Clear Jar'),
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
              child: Column(
                children: <Widget>[
                  SwitchListTile.adaptive(
                    value: _ignoreInvalidCookies,
                    onChanged: _isBusy ? null : _toggleIgnoreInvalidCookies,
                    title: const Text('Ignore invalid cookies'),
                    subtitle: const Text(
                      'Rebuilds Dio with `CookieManager(cookieJar, ignoreInvalidCookies: ...)` and clears the in-memory jar.',
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.cookie_outlined),
                    title: const Text('Last request Cookie header'),
                    subtitle: Text(_lastRequestCookieHeader),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _CookieScopeCard(
              title: 'Cookies used for `/`',
              description:
                  'The root scope only receives cookies whose path matches the top level of the site.',
              cookies: _rootCookies,
              headerPreview: _cookieHeaderPreview(_rootCookies),
            ),
            const SizedBox(height: 16),
            _CookieScopeCard(
              title: 'Cookies used for `/api/profile`',
              description:
                  'This request receives both the root session cookie and the longer `/api` path-scoped cookies. CookieManager orders longer paths first.',
              cookies: _apiCookies,
              headerPreview: _cookieHeaderPreview(_apiCookies),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                initiallyExpanded: true,
                title: const Text('Minimal Setup'),
                subtitle: const Text(
                  'The same interceptor composition used in the live demo.',
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: SelectableText(
                      _minimalSetupSnippet,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                title: const Text('Redirect Handling'),
                subtitle: const Text(
                  'A common pattern when cookies arrive on 302 responses.',
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: SelectableText(
                      _redirectSnippet,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
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
                      'Last Response Body',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SelectableText(
                      _lastResponseBody,
                      style: textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        height: 1.45,
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
                      'Request Timeline',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'The timeline mixes Dio interceptor events with mock-server observations so you can see exactly when cookies were attached and saved.',
                    ),
                    if (_isBusy) ...<Widget>[
                      const SizedBox(height: 14),
                      const LinearProgressIndicator(),
                    ],
                    const SizedBox(height: 14),
                    for (final _DemoLogEntry entry in _logs)
                      _LogTile(entry: entry),
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

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({
    required this.statusMessage,
    required this.isBusy,
    required this.completedScenarios,
    required this.ignoreInvalidCookies,
    required this.rootCookieCount,
    required this.apiCookieCount,
  });

  final String statusMessage;
  final bool isBusy;
  final int completedScenarios;
  final bool ignoreInvalidCookies;
  final int rootCookieCount;
  final int apiCookieCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  isBusy ? Icons.sync : Icons.cookie,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    statusMessage,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                Chip(label: Text('Scenarios: $completedScenarios')),
                Chip(
                  label: Text(
                    ignoreInvalidCookies
                        ? 'Invalid cookies ignored'
                        : 'Strict cookie parsing',
                  ),
                ),
                Chip(label: Text('Root cookies: $rootCookieCount')),
                Chip(label: Text('API cookies: $apiCookieCount')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CookieScopeCard extends StatelessWidget {
  const _CookieScopeCard({
    required this.title,
    required this.description,
    required this.cookies,
    required this.headerPreview,
  });

  final String title;
  final String description;
  final List<Cookie> cookies;
  final String headerPreview;

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
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.label_outline),
              title: const Text('Header preview'),
              subtitle: Text(headerPreview),
            ),
            const SizedBox(height: 8),
            if (cookies.isEmpty)
              const Text('No cookies are available for this request scope yet.')
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Value')),
                    DataColumn(label: Text('Path')),
                    DataColumn(label: Text('Domain')),
                  ],
                  rows: cookies
                      .map(
                        (Cookie cookie) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(cookie.name)),
                            DataCell(Text(cookie.value)),
                            DataCell(Text(cookie.path ?? '/')),
                            DataCell(Text(cookie.domain ?? 'current host')),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.entry});

  final _DemoLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: entry.color.withValues(alpha: 0.14),
        foregroundColor: entry.color,
        child: Icon(entry.icon, size: 18),
      ),
      title: Text('${entry.time}  ${entry.title}'),
      subtitle: Text(entry.message),
    );
  }
}

class _DemoLogEntry {
  const _DemoLogEntry({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.time = '--:--:--',
  });

  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final String time;

  factory _DemoLogEntry.info({required String title, required String message}) {
    return _DemoLogEntry(
      title: title,
      message: message,
      icon: Icons.info_outline,
      color: Colors.blue,
    );
  }

  factory _DemoLogEntry.request({
    required String title,
    required String message,
  }) {
    return _DemoLogEntry(
      title: title,
      message: message,
      icon: Icons.arrow_upward,
      color: Colors.indigo,
    );
  }

  factory _DemoLogEntry.response({
    required String title,
    required String message,
  }) {
    return _DemoLogEntry(
      title: title,
      message: message,
      icon: Icons.arrow_downward,
      color: Colors.green,
    );
  }

  factory _DemoLogEntry.server({
    required String title,
    required String message,
  }) {
    return _DemoLogEntry(
      title: title,
      message: message,
      icon: Icons.dns_outlined,
      color: Colors.orange,
    );
  }

  factory _DemoLogEntry.error({
    required String title,
    required String message,
  }) {
    return _DemoLogEntry(
      title: title,
      message: message,
      icon: Icons.error_outline,
      color: Colors.red,
    );
  }

  _DemoLogEntry copyWith({String? time}) {
    return _DemoLogEntry(
      title: title,
      message: message,
      icon: icon,
      color: color,
      time: time ?? this.time,
    );
  }
}

class _CookieScenarioAdapter implements HttpClientAdapter {
  _CookieScenarioAdapter({required this.onServerEvent});

  static const String baseUrl = 'https://cookie.demo.local';

  final void Function(_DemoLogEntry entry) onServerEvent;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));

    final String cookieHeader =
        options.headers[HttpHeaders.cookieHeader] as String? ?? '<empty>';
    onServerEvent(
      _DemoLogEntry.server(
        title: 'Server saw ${options.method} ${options.path}',
        message: 'Incoming Cookie header: $cookieHeader',
      ),
    );

    switch (options.path) {
      case '/login':
        return ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'step': 'login',
            'savedCookies': <String>['session_id', 'feature_flag'],
            'explanation':
                'One cookie uses `/`, the other uses `/api` so later requests '
                'can demonstrate path matching.',
          }),
          200,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>[Headers.jsonContentType],
            HttpHeaders.setCookieHeader: <String>[
              'session_id=flutter-session-42; Path=/; HttpOnly',
              'feature_flag=grid-layout; Path=/api; Max-Age=3600',
            ],
          },
        );
      case '/api/profile':
        final bool authenticated = cookieHeader.contains(
          'session_id=flutter-session-42',
        );
        final int statusCode = authenticated ? 200 : 401;
        return ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'step': 'profile',
            'authenticated': authenticated,
            'receivedCookieHeader': cookieHeader,
            'pathScopedCookieAttached': cookieHeader.contains(
              'feature_flag=grid-layout',
            ),
          }),
          statusCode,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>[Headers.jsonContentType],
            if (authenticated)
              HttpHeaders.setCookieHeader: <String>[
                'last_screen=profile; Path=/api',
              ],
          },
        );
      case '/redirect/start':
        return ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'step': 'redirect-start',
            'message': 'Follow the Location header manually.',
          }),
          302,
          isRedirect: true,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>[Headers.jsonContentType],
            HttpHeaders.locationHeader: <String>['/redirect/landing'],
            HttpHeaders.setCookieHeader: <String>[
              'promo_banner=accepted; Path=/',
            ],
          },
        );
      case '/redirect/landing':
        return ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'step': 'redirect-landing',
            'receivedCookieHeader': cookieHeader,
            'promoCookieAttached': cookieHeader.contains(
              'promo_banner=accepted',
            ),
          }),
          200,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>[Headers.jsonContentType],
          },
        );
      case '/invalid-cookie':
        return ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'step': 'invalid-cookie',
            'message':
                'This response intentionally contains malformed cookie data.',
          }),
          200,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>[Headers.jsonContentType],
            HttpHeaders.setCookieHeader: <String>[
              'broken-cookie-without-equals',
            ],
          },
        );
      default:
        return ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'error': 'Unknown mock path: ${options.path}',
          }),
          404,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>[Headers.jsonContentType],
          },
        );
    }
  }

  @override
  void close({bool force = false}) {}
}

const String _minimalSetupSnippet = '''
final cookieJar = CookieJar();
final dio = Dio()
  ..interceptors.add(CookieManager(cookieJar));

await dio.post('/login');
await dio.get('/api/profile');

final apiCookies = await cookieJar.loadForRequest(
  Uri.parse('https://cookie.demo.local/api/profile'),
);
''';

const String _redirectSnippet = '''
final dio = Dio()
  ..options.followRedirects = false
  ..options.validateStatus = (status) => status != null && status < 400
  ..interceptors.add(CookieManager(cookieJar));

final redirected = await dio.get('/redirect/start');
final nextPath = redirected.headers.value(HttpHeaders.locationHeader)!;
final landing = await dio.get(nextPath);
''';
