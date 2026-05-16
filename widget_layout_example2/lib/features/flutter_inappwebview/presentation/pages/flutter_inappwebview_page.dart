import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

enum _InAppWebViewPreset { inlineHtml, flutterSite, packagePage }

class _DemoInAppBrowser extends InAppBrowser {
  _DemoInAppBrowser({required this.onEvent});

  final ValueChanged<String> onEvent;

  @override
  void onBrowserCreated() {
    onEvent('InAppBrowser created.');
  }

  @override
  void onLoadStart(WebUri? url) {
    onEvent('InAppBrowser load start -> ${url ?? 'unknown'}');
  }

  @override
  void onLoadStop(WebUri? url) {
    onEvent('InAppBrowser load stop -> ${url ?? 'unknown'}');
  }

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    onEvent(
      'InAppBrowser error -> ${request.url} (${error.type.name()}: ${error.description})',
    );
  }

  @override
  void onProgressChanged(int progress) {
    onEvent('InAppBrowser progress -> $progress%');
  }

  @override
  void onConsoleMessage(ConsoleMessage consoleMessage) {
    onEvent('InAppBrowser console -> ${consoleMessage.message}');
  }

  @override
  void onExit() {
    onEvent('InAppBrowser closed.');
  }
}

@RoutePage(name: RouteName.flutterInappwebview)
class FlutterInappwebviewPage extends StatefulWidget {
  const FlutterInappwebviewPage({super.key});

  @override
  State<FlutterInappwebviewPage> createState() =>
      _FlutterInappwebviewPageState();
}

class _FlutterInappwebviewPageState extends State<FlutterInappwebviewPage> {
  static const String _inlineHtmlBaseUrl =
      'https://widget-layout-example.local/flutter-inappwebview/';
  static const String _cookieOrigin = 'https://flutter.dev';
  static const String _handlerName = 'flutterDemoHandler';
  static const String _userScriptGroup = 'flutter_demo_badge';
  static const String _inlineHtml = '''
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>flutter_inappwebview inline demo</title>
    <style>
      :root {
        --demo-accent: #0f766e;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        color-scheme: light;
      }
      * {
        box-sizing: border-box;
      }
      body {
        margin: 0;
        min-height: 100vh;
        color: #0f172a;
        background:
          radial-gradient(circle at top right, #ccfbf1 0, #f8fafc 42%),
          linear-gradient(180deg, #ecfeff 0%, #f8fafc 100%);
      }
      .shell {
        max-width: 920px;
        margin: 0 auto;
        padding: 24px;
      }
      .hero {
        background: rgba(255, 255, 255, 0.88);
        backdrop-filter: blur(14px);
        border-radius: 28px;
        padding: 24px;
        box-shadow: 0 18px 48px rgba(15, 23, 42, 0.10);
      }
      .eyebrow {
        display: inline-flex;
        padding: 6px 12px;
        border-radius: 999px;
        background: rgba(15, 118, 110, 0.12);
        color: var(--demo-accent);
        font-size: 12px;
        font-weight: 800;
        letter-spacing: 0.08em;
        text-transform: uppercase;
      }
      h1 {
        margin: 16px 0 10px;
        font-size: 34px;
      }
      p {
        line-height: 1.65;
      }
      .grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
        gap: 14px;
        margin-top: 22px;
      }
      .card {
        padding: 16px;
        border-radius: 20px;
        border: 1px solid rgba(15, 118, 110, 0.14);
        background: rgba(240, 253, 250, 0.92);
      }
      .label {
        margin-bottom: 8px;
        font-size: 13px;
        color: #475569;
      }
      .value {
        font-size: 28px;
        font-weight: 800;
      }
      .status {
        min-height: 24px;
        color: var(--demo-accent);
        font-weight: 700;
      }
      .actions {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin-top: 22px;
      }
      button,
      a {
        border: none;
        border-radius: 999px;
        padding: 12px 16px;
        background: linear-gradient(135deg, #0f766e, #2563eb);
        color: #fff;
        font-size: 14px;
        font-weight: 700;
        text-decoration: none;
        cursor: pointer;
      }
      .secondary {
        background: #e2e8f0;
        color: #0f172a;
      }
      .notes {
        margin-top: 22px;
        padding: 16px;
        border-radius: 18px;
        background: rgba(15, 23, 42, 0.05);
      }
      .spacer {
        height: 520px;
      }
      code {
        background: rgba(15, 23, 42, 0.06);
        border-radius: 8px;
        padding: 2px 6px;
      }
    </style>
    <script>
      let counter = 0;

      function refreshCounter() {
        document.getElementById('counter').textContent = String(counter);
      }

      function incrementCounter() {
        counter += 1;
        refreshCounter();
        console.log('Counter incremented to ' + counter);
      }

      function sendToFlutter() {
        const payload = {
          counter,
          href: window.location.href,
          title: document.title,
          timestamp: new Date().toISOString(),
        };

        if (!window.flutter_inappwebview) {
          document.getElementById('handler-result').textContent =
            'Bridge unavailable';
          return;
        }

        window.flutter_inappwebview
          .callHandler('flutterDemoHandler', payload)
          .then((response) => {
            document.getElementById('handler-result').textContent =
              JSON.stringify(response);
          });
      }

      function setStatus(message) {
        document.getElementById('page-status').textContent = message;
      }

      function openBlockedUrl() {
        window.location.href =
          'https://www.youtube.com/results?search_query=flutter';
      }

      window.addEventListener('load', () => {
        refreshCounter();
        setStatus('Inline HTML is ready for Flutter bridge calls.');
        console.log('Inline flutter_inappwebview demo loaded.');
      });
    </script>
  </head>
  <body>
    <div class="shell">
      <section class="hero">
        <div class="eyebrow">Inline HTML</div>
        <h1>flutter_inappwebview inside a normal widget tree</h1>
        <p>
          This demo page is loaded with <code>loadData</code> and then controlled
          from Flutter with <code>evaluateJavascript</code>,
          <code>callAsyncJavaScript</code>, <code>addJavaScriptHandler</code>,
          <code>PullToRefreshController</code>, and cookie APIs.
        </p>

        <div class="grid">
          <article class="card">
            <div class="label">Counter</div>
            <div class="value" id="counter">0</div>
          </article>
          <article class="card">
            <div class="label">Handler Response</div>
            <div class="value" id="handler-result">pending</div>
          </article>
          <article class="card">
            <div class="label">Status</div>
            <div class="status" id="page-status">waiting</div>
          </article>
        </div>

        <div class="actions">
          <button onclick="incrementCounter()">Increment Counter</button>
          <button onclick="sendToFlutter()">Call Flutter Handler</button>
          <a class="secondary" href="https://flutter.dev">Open flutter.dev</a>
          <button class="secondary" onclick="openBlockedUrl()">
            Try blocked URL
          </button>
        </div>

        <div class="notes">
          Flutter can also inject additional DOM changes after load, including a
          floating badge added with <code>UserScript</code>.
        </div>
      </section>

      <div class="spacer"></div>
    </div>
  </body>
</html>
''';

  final TextEditingController _urlController = TextEditingController(
    text: 'https://flutter.dev',
  );
  final TextEditingController _messageController = TextEditingController(
    text: 'Updated from Flutter with evaluateJavascript(...)',
  );
  final List<String> _eventLog = <String>[];

  PullToRefreshController? _pullToRefreshController;
  late final _DemoInAppBrowser _browser;

  InAppWebViewController? _controller;
  int _progress = 0;
  String _status =
      'Load the inline demo or an external page to exercise controller methods, cookies, pull-to-refresh, and browser launches.';
  String _currentUrl = 'No page loaded yet.';
  String _pageTitle = 'No title reported yet.';
  String _userAgent = 'Not requested yet.';
  String _jsResult = 'Run "Inspect DOM" to capture async JavaScript output.';
  String _cookieSummary = 'No cookies inspected yet.';
  bool _controllerReady = false;
  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _pullToRefreshEnabled = true;
  _InAppWebViewPreset _preset = _InAppWebViewPreset.inlineHtml;

  bool get _supportsEmbeddedWebView {
    if (kIsWeb) {
      return true;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return true;
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  bool get _supportsPullToRefresh {
    if (kIsWeb) {
      return false;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _browser = _DemoInAppBrowser(onEvent: _addLog);
    if (_supportsPullToRefresh) {
      _pullToRefreshController = PullToRefreshController(
        settings: PullToRefreshSettings(
          enabled: _pullToRefreshEnabled,
          color: Colors.teal,
        ),
        onRefresh: () async {
          _addLog('Pull-to-refresh requested.');
          await _controller?.reload();
        },
      );
    } else {
      _pullToRefreshEnabled = false;
    }
    unawaited(_refreshDefaultUserAgent());
  }

  @override
  void dispose() {
    _urlController.dispose();
    _messageController.dispose();
    _pullToRefreshController?.dispose();
    _browser.dispose();
    super.dispose();
  }

  void _addLog(String message) {
    if (!mounted) {
      return;
    }

    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    setState(() {
      _eventLog.insert(0, '$timestamp  $message');
      if (_eventLog.length > 14) {
        _eventLog.removeLast();
      }
    });
  }

  void _recordError(String label, Object error) {
    if (!mounted) {
      return;
    }

    setState(() {
      _status = '$label failed: $error';
    });
    _addLog('$label failed: $error');
  }

  Uri? _activeUri() {
    final String raw = _urlController.text.trim();
    final Uri? uri = Uri.tryParse(raw);
    if (uri == null) {
      return null;
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return null;
    }
    return uri;
  }

  Future<void> _refreshDefaultUserAgent() async {
    try {
      final String defaultUserAgent =
          await InAppWebViewController.getDefaultUserAgent();

      if (!mounted) {
        return;
      }

      setState(() {
        _userAgent = defaultUserAgent;
        _status =
            'Fetched the default user agent with InAppWebViewController.getDefaultUserAgent().';
      });
      _addLog('Fetched default user agent.');
    } catch (error) {
      _recordError('getDefaultUserAgent', error);
    }
  }

  Future<void> _syncControllerState() async {
    final InAppWebViewController? controller = _controller;
    if (controller == null) {
      return;
    }

    final WebUri? url = await controller.getUrl();
    final String? title = await controller.getTitle();
    final bool canGoBack = await controller.canGoBack();
    final bool canGoForward = await controller.canGoForward();

    if (!mounted) {
      return;
    }

    setState(() {
      _controllerReady = true;
      _currentUrl = url?.toString() ?? 'No URL loaded yet.';
      _pageTitle = title ?? 'No title reported yet.';
      _canGoBack = canGoBack;
      _canGoForward = canGoForward;
    });
  }

  Future<void> _loadInlineDemo() async {
    final InAppWebViewController? controller = _controller;
    if (controller == null) {
      setState(() {
        _status = 'The WebView controller is not ready yet.';
      });
      return;
    }

    try {
      await controller.loadData(
        data: _inlineHtml,
        mimeType: 'text/html',
        encoding: 'utf-8',
        baseUrl: WebUri(_inlineHtmlBaseUrl),
        historyUrl: WebUri('${_inlineHtmlBaseUrl}index.html'),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _preset = _InAppWebViewPreset.inlineHtml;
        _status =
            'Loaded inline HTML with loadData(...), ready for JavaScript handlers and injected scripts.';
      });
      _addLog('Loaded inline HTML demo.');
    } catch (error) {
      _recordError('loadData', error);
    }
  }

  Future<void> _loadTypedUrl({String sourceLabel = 'URL field'}) async {
    final InAppWebViewController? controller = _controller;
    final Uri? uri = _activeUri();
    if (controller == null) {
      setState(() {
        _status = 'The WebView controller is not ready yet.';
      });
      return;
    }
    if (uri == null) {
      setState(() {
        _status =
            'Enter a valid http/https URL before calling loadUrl(URLRequest(...)).';
      });
      return;
    }

    try {
      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri(uri.toString()),
          headers: const <String, String>{
            'X-Demo-Source': 'flutter_inappwebview_page',
          },
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Loading ${uri.toString()} from $sourceLabel.';
      });
      _addLog('loadUrl from $sourceLabel -> ${uri.toString()}');
    } catch (error) {
      _recordError('loadUrl', error);
    }
  }

  Future<void> _loadPreset(_InAppWebViewPreset preset) async {
    switch (preset) {
      case _InAppWebViewPreset.inlineHtml:
        await _loadInlineDemo();
        return;
      case _InAppWebViewPreset.flutterSite:
        _urlController.text = 'https://flutter.dev';
      case _InAppWebViewPreset.packagePage:
        _urlController.text = 'https://pub.dev/packages/flutter_inappwebview';
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _preset = preset;
    });
    await _loadTypedUrl(sourceLabel: preset.name);
  }

  Future<void> _inspectDom() async {
    final InAppWebViewController? controller = _controller;
    if (controller == null) {
      setState(() {
        _status = 'The WebView controller is not ready yet.';
      });
      return;
    }

    try {
      final CallAsyncJavaScriptResult? result = await controller
          .callAsyncJavaScript(
            functionBody: '''
              const payload = {
                title: document.title,
                readyState: document.readyState,
                links: document.links.length,
                cards: document.querySelectorAll('.card').length,
                bodyTextLength: document.body?.innerText.length ?? 0,
              };
              return payload;
            ''',
          );

      if (!mounted) {
        return;
      }

      setState(() {
        _jsResult = const JsonEncoder.withIndent('  ').convert(result?.value);
        _status =
            'Collected DOM information with callAsyncJavaScript(functionBody: ...).';
      });
      _addLog('Collected DOM information with callAsyncJavaScript.');
    } catch (error) {
      _recordError('callAsyncJavaScript', error);
    }
  }

  Future<void> _injectStatusMessage() async {
    final InAppWebViewController? controller = _controller;
    if (controller == null) {
      setState(() {
        _status = 'The WebView controller is not ready yet.';
      });
      return;
    }

    final String message = _messageController.text.trim();
    if (message.isEmpty) {
      setState(() {
        _status = 'Enter a message before injecting JavaScript.';
      });
      return;
    }

    try {
      await controller.evaluateJavascript(
        source:
            '''
          (() => {
            const message = ${jsonEncode(message)};
            const target = document.getElementById('page-status');
            if (target) {
              target.textContent = message;
            }
            console.log('Flutter injected status: ' + message);
          })();
        ''',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Updated page UI with evaluateJavascript(source: ...).';
      });
      _addLog('Injected a status message with evaluateJavascript.');
    } catch (error) {
      _recordError('evaluateJavascript', error);
    }
  }

  Future<void> _installUserScript() async {
    final InAppWebViewController? controller = _controller;
    if (controller == null) {
      setState(() {
        _status = 'The WebView controller is not ready yet.';
      });
      return;
    }

    final String badgeText = _messageController.text.trim();
    final String source =
        '''
      (() => {
        const text = ${jsonEncode(badgeText.isEmpty ? 'UserScript badge' : badgeText)};
        document.documentElement.style.setProperty('--demo-accent', '#1d4ed8');

        let badge = document.getElementById('flutter-user-script-badge');
        if (!badge) {
          badge = document.createElement('div');
          badge.id = 'flutter-user-script-badge';
          badge.style.position = 'fixed';
          badge.style.right = '18px';
          badge.style.bottom = '18px';
          badge.style.zIndex = '999999';
          badge.style.padding = '10px 14px';
          badge.style.borderRadius = '999px';
          badge.style.background = 'linear-gradient(135deg, #1d4ed8, #0f766e)';
          badge.style.color = '#ffffff';
          badge.style.fontWeight = '800';
          badge.style.boxShadow = '0 14px 30px rgba(15, 23, 42, 0.20)';
          document.body.appendChild(badge);
        }

        badge.textContent = text;
      })();
    ''';

    try {
      await controller.removeUserScriptsByGroupName(
        groupName: _userScriptGroup,
      );
      await controller.addUserScript(
        userScript: UserScript(
          source: source,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
          groupName: _userScriptGroup,
        ),
      );
      await controller.evaluateJavascript(source: source);

      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            'Installed a reusable UserScript and executed it immediately to add a floating badge.';
      });
      _addLog('Installed a UserScript in group "$_userScriptGroup".');
    } catch (error) {
      _recordError('addUserScript', error);
    }
  }

  Future<void> _setCookie() async {
    final String value = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      final bool result = await CookieManager.instance().setCookie(
        url: WebUri(_cookieOrigin),
        name: 'widget_layout_demo',
        value: value,
        path: '/',
        isSecure: true,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            'CookieManager.setCookie(...) returned $result for $_cookieOrigin.';
      });
      _addLog('Set cookie widget_layout_demo=$value');
      await _readCookies(silentStatus: true);
    } catch (error) {
      _recordError('setCookie', error);
    }
  }

  Future<void> _readCookies({bool silentStatus = false}) async {
    try {
      final List<Cookie> cookies = await CookieManager.instance().getCookies(
        url: WebUri(_cookieOrigin),
      );
      final String summary = cookies.isEmpty
          ? 'No cookies stored for $_cookieOrigin.'
          : cookies
                .map((Cookie cookie) => '${cookie.name}=${cookie.value}')
                .join('\n');

      if (!mounted) {
        return;
      }

      setState(() {
        _cookieSummary = summary;
        if (!silentStatus) {
          _status =
              'Read ${cookies.length} cookie(s) with CookieManager.getCookies(...).';
        }
      });
      _addLog('Read ${cookies.length} cookie(s) for $_cookieOrigin.');
    } catch (error) {
      _recordError('getCookies', error);
    }
  }

  Future<void> _clearAllCookies() async {
    try {
      final bool result = await CookieManager.instance().deleteAllCookies();

      if (!mounted) {
        return;
      }

      setState(() {
        _cookieSummary = 'No cookies inspected yet.';
        _status = 'CookieManager.deleteAllCookies() returned $result.';
      });
      _addLog('Deleted all cookies -> $result');
    } catch (error) {
      _recordError('deleteAllCookies', error);
    }
  }

  Future<void> _openInAppBrowser() async {
    final Uri uri = _activeUri() ?? Uri.parse(_cookieOrigin);

    try {
      await _browser.openUrlRequest(
        urlRequest: URLRequest(url: WebUri(uri.toString())),
        settings: InAppBrowserClassSettings(
          browserSettings: InAppBrowserSettings(
            toolbarTopBackgroundColor: Theme.of(context).colorScheme.primary,
            hideToolbarTop: false,
          ),
          webViewSettings: InAppWebViewSettings(javaScriptEnabled: true),
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            'Opened a secondary browser surface with InAppBrowser.openUrlRequest(...).';
      });
      _addLog('Opened InAppBrowser for ${uri.toString()}.');
    } catch (error) {
      _recordError('openUrlRequest', error);
    }
  }

  Future<void> _openSystemBrowser() async {
    final Uri uri = _activeUri() ?? Uri.parse(_cookieOrigin);

    try {
      await InAppBrowser.openWithSystemBrowser(url: WebUri(uri.toString()));

      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Opened ${uri.toString()} with the system browser.';
      });
      _addLog('Opened system browser for ${uri.toString()}.');
    } catch (error) {
      _recordError('openWithSystemBrowser', error);
    }
  }

  Future<void> _setPullToRefreshEnabled(bool enabled) async {
    final PullToRefreshController? controller = _pullToRefreshController;
    if (!_supportsPullToRefresh || controller == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _pullToRefreshEnabled = false;
        _status =
            'Pull-to-refresh is only available on Android and iOS for flutter_inappwebview.';
      });
      _addLog('Ignored pull-to-refresh toggle on unsupported platform.');
      return;
    }

    try {
      await controller.setEnabled(enabled);

      if (!mounted) {
        return;
      }

      setState(() {
        _pullToRefreshEnabled = enabled;
        _status = 'PullToRefreshController.setEnabled($enabled) completed.';
      });
      _addLog('Pull-to-refresh enabled -> $enabled');
    } catch (error) {
      _recordError('setEnabled', error);
    }
  }

  Future<void> _endPullToRefreshIfNeeded() async {
    final PullToRefreshController? controller = _pullToRefreshController;
    if (!_supportsPullToRefresh || controller == null) {
      return;
    }

    await controller.endRefreshing();
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 210,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(description),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback? onPressed,
    required bool toned,
  }) {
    if (toned) {
      return FilledButton.tonal(onPressed: onPressed, child: Text(label));
    }
    return OutlinedButton(onPressed: onPressed, child: Text(label));
  }

  Widget _buildUnsupportedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'flutter_inappwebview is not supported on this platform in the current app configuration.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  Widget _buildWebViewPanel() {
    if (!_supportsEmbeddedWebView) {
      return _buildUnsupportedState();
    }

    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        javaScriptCanOpenWindowsAutomatically: true,
        mediaPlaybackRequiresUserGesture: false,
        useShouldOverrideUrlLoading: true,
      ),
      pullToRefreshController: _pullToRefreshController,
      initialUrlRequest: URLRequest(url: WebUri('https://flutter.dev')),
      onWebViewCreated: (InAppWebViewController controller) {
        _controller = controller;
        controller.addJavaScriptHandler(
          handlerName: _handlerName,
          callback: (dynamic args) {
            final String payload = const JsonEncoder.withIndent(
              '  ',
            ).convert(args);

            if (mounted) {
              setState(() {
                _status =
                    'Received a JavaScript bridge call from window.flutter_inappwebview.callHandler(...).';
                _jsResult = payload;
              });
            }
            _addLog('JavaScript handler invoked with payload: $payload');

            return <String, dynamic>{
              'receivedAt': DateTime.now().toIso8601String(),
              'argCount': args is List ? args.length : 0,
              'acknowledged': true,
            };
          },
        );
        _addLog('InAppWebView controller created.');
      },
      onLoadStart: (InAppWebViewController controller, WebUri? url) {
        if (!mounted) {
          return;
        }

        setState(() {
          _currentUrl = url?.toString() ?? 'No URL loaded yet.';
          _status = 'Started loading ${url ?? 'unknown URL'}.';
        });
        _addLog('Load start -> ${url ?? 'unknown URL'}');
        unawaited(_syncControllerState());
      },
      onLoadStop: (InAppWebViewController controller, WebUri? url) async {
        await _endPullToRefreshIfNeeded();
        _addLog('Load stop -> ${url ?? 'unknown URL'}');

        if (!mounted) {
          return;
        }

        setState(() {
          _progress = 100;
        });
        await _syncControllerState();
      },
      onProgressChanged: (InAppWebViewController controller, int progress) {
        if (!mounted) {
          return;
        }

        setState(() {
          _progress = progress;
        });
      },
      onTitleChanged: (InAppWebViewController controller, String? title) {
        if (!mounted) {
          return;
        }

        setState(() {
          _pageTitle = title ?? 'No title reported yet.';
        });
      },
      onConsoleMessage:
          (InAppWebViewController controller, ConsoleMessage consoleMessage) {
            _addLog('Console -> ${consoleMessage.message}');
          },
      shouldOverrideUrlLoading:
          (
            InAppWebViewController controller,
            NavigationAction navigationAction,
          ) async {
            final String url = navigationAction.request.url?.toString() ?? '';
            if (url.contains('youtube.com')) {
              if (mounted) {
                setState(() {
                  _status =
                      'Blocked $url from shouldOverrideUrlLoading to show navigation interception.';
                });
              }
              _addLog('Blocked navigation to $url');
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
      onUpdateVisitedHistory:
          (InAppWebViewController controller, WebUri? url, bool? isReload) {
            _addLog('Visited history updated -> ${url ?? 'unknown URL'}');
            unawaited(_syncControllerState());
          },
      onPermissionRequest:
          (
            InAppWebViewController controller,
            PermissionRequest permissionRequest,
          ) async {
            _addLog(
              'Permission request -> ${permissionRequest.resources.map((resource) => resource.name).join(', ')}',
            );
            return PermissionResponse(
              resources: permissionRequest.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
      onReceivedError:
          (
            InAppWebViewController controller,
            WebResourceRequest request,
            WebResourceError error,
          ) async {
            await _endPullToRefreshIfNeeded();
            _recordError(
              'onReceivedError',
              '${request.url}: ${error.type.name()} ${error.description}',
            );
          },
      onReceivedHttpError:
          (
            InAppWebViewController controller,
            WebResourceRequest request,
            WebResourceResponse errorResponse,
          ) {
            _addLog(
              'HTTP error -> ${request.url} (${errorResponse.statusCode} ${errorResponse.reasonPhrase ?? ''})',
            );
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_inappwebview Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'This module mirrors the richer patterns from the local flutter_inappwebview example app, but condensed into one page so you can exercise the plugin inside this demo project.',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              _buildMetricCard(
                context: context,
                title: 'Progress',
                value: '$_progress%',
              ),
              _buildMetricCard(
                context: context,
                title: 'Page Title',
                value: _pageTitle,
              ),
              _buildMetricCard(
                context: context,
                title: 'Current URL',
                value: _currentUrl,
              ),
              _buildMetricCard(
                context: context,
                title: 'Pull To Refresh',
                value: _supportsPullToRefresh
                    ? (_pullToRefreshEnabled ? 'Enabled' : 'Disabled')
                    : 'Android/iOS only',
              ),
              _buildMetricCard(
                context: context,
                title: 'Preset',
                value: _preset.name,
              ),
            ],
          ),
          const SizedBox(height: 18),
          _buildSectionCard(
            title: 'Navigation And Browser Actions',
            description:
                'Use loadUrl, loadData, navigation history, system browser launch, and secondary in-app browser launch from one place.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'HTTP/HTTPS URL',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) =>
                      unawaited(_loadTypedUrl(sourceLabel: 'keyboard submit')),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton(
                      onPressed: () =>
                          unawaited(_loadTypedUrl(sourceLabel: 'URL field')),
                      child: const Text('Load URL'),
                    ),
                    FilledButton.tonal(
                      onPressed: () => unawaited(
                        _loadPreset(_InAppWebViewPreset.inlineHtml),
                      ),
                      child: const Text('Load Inline HTML'),
                    ),
                    _buildActionButton(
                      label: 'Flutter Site',
                      onPressed: () => unawaited(
                        _loadPreset(_InAppWebViewPreset.flutterSite),
                      ),
                      toned: true,
                    ),
                    _buildActionButton(
                      label: 'pub.dev Package',
                      onPressed: () => unawaited(
                        _loadPreset(_InAppWebViewPreset.packagePage),
                      ),
                      toned: true,
                    ),
                    _buildActionButton(
                      label: 'Back',
                      onPressed: _canGoBack
                          ? () => unawaited(_controller?.goBack())
                          : null,
                      toned: false,
                    ),
                    _buildActionButton(
                      label: 'Forward',
                      onPressed: _canGoForward
                          ? () => unawaited(_controller?.goForward())
                          : null,
                      toned: false,
                    ),
                    _buildActionButton(
                      label: 'Reload',
                      onPressed: _controllerReady
                          ? () => unawaited(_controller?.reload())
                          : null,
                      toned: false,
                    ),
                    _buildActionButton(
                      label: 'Open InAppBrowser',
                      onPressed: () => unawaited(_openInAppBrowser()),
                      toned: false,
                    ),
                    _buildActionButton(
                      label: 'System Browser',
                      onPressed: () => unawaited(_openSystemBrowser()),
                      toned: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Card(
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 420,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(child: _buildWebViewPanel()),
                  if (_progress < 100)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(value: _progress / 100),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          _buildSectionCard(
            title: 'Controller APIs',
            description:
                'These actions cover JavaScript bridges, async JS evaluation, user scripts, pull-to-refresh toggling, and plugin-level static helpers.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Injected message / badge text',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.tonal(
                      onPressed: () => unawaited(_inspectDom()),
                      child: const Text('Inspect DOM'),
                    ),
                    _buildActionButton(
                      label: 'Inject JS',
                      onPressed: () => unawaited(_injectStatusMessage()),
                      toned: false,
                    ),
                    _buildActionButton(
                      label: 'Install UserScript',
                      onPressed: () => unawaited(_installUserScript()),
                      toned: false,
                    ),
                    _buildActionButton(
                      label: 'Enable Pull Refresh',
                      onPressed:
                          !_supportsPullToRefresh || _pullToRefreshEnabled
                          ? null
                          : () => unawaited(_setPullToRefreshEnabled(true)),
                      toned: false,
                    ),
                    _buildActionButton(
                      label: 'Disable Pull Refresh',
                      onPressed: _supportsPullToRefresh && _pullToRefreshEnabled
                          ? () => unawaited(_setPullToRefreshEnabled(false))
                          : null,
                      toned: false,
                    ),
                    _buildActionButton(
                      label: 'Refresh User Agent',
                      onPressed: () => unawaited(_refreshDefaultUserAgent()),
                      toned: false,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SelectableText(
                  'Status\n$_status',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                SelectableText(
                  'Default User Agent\n$_userAgent',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                SelectableText(
                  'JavaScript Result\n$_jsResult',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _buildSectionCard(
            title: 'CookieManager APIs',
            description:
                'The upstream example app exposes full cookie tooling. This module keeps the common flows: set, read, and clear.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.tonal(
                      onPressed: () => unawaited(_setCookie()),
                      child: const Text('Set Cookie'),
                    ),
                    _buildActionButton(
                      label: 'Read Cookies',
                      onPressed: () => unawaited(_readCookies()),
                      toned: false,
                    ),
                    _buildActionButton(
                      label: 'Clear All Cookies',
                      onPressed: () => unawaited(_clearAllCookies()),
                      toned: false,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SelectableText(
                  _cookieSummary,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _buildSectionCard(
            title: 'Event Log',
            description:
                'Navigation callbacks, console output, JavaScript bridge messages, and in-app browser events are collected here.',
            child: _eventLog.isEmpty
                ? const Text('No events yet.')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _eventLog
                        .map(
                          (String entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: SelectableText(entry),
                          ),
                        )
                        .toList(growable: false),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}
