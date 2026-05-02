import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:widget_layout_example2/app_navigation.dart';

enum _WebViewSource { inlineHtml, flutterSite, packagePage }

@RoutePage(name: RouteName.webviewFlutter)
class WebviewFlutterPage extends StatefulWidget {
  const WebviewFlutterPage({super.key});

  @override
  State<WebviewFlutterPage> createState() => _WebviewFlutterPageState();
}

class _WebviewFlutterPageState extends State<WebviewFlutterPage> {
  static const String _inlineHtmlBaseUrl =
      'https://widget-layout-example.local/demo/';

  static const String _inlineHtml = '''
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>webview_flutter demo</title>
    <style>
      :root {
        color-scheme: light;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      }
      body {
        margin: 0;
        padding: 20px;
        background: linear-gradient(180deg, #f8fafc 0%, #e2e8f0 100%);
        color: #0f172a;
      }
      .shell {
        max-width: 860px;
        margin: 0 auto;
      }
      .hero {
        padding: 24px;
        border-radius: 24px;
        background: #ffffff;
        box-shadow: 0 20px 60px rgba(15, 23, 42, 0.08);
      }
      .eyebrow {
        display: inline-flex;
        padding: 6px 10px;
        border-radius: 999px;
        background: #e0f2fe;
        color: #075985;
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.08em;
        text-transform: uppercase;
      }
      h1 {
        margin: 14px 0 10px;
        font-size: 32px;
      }
      p {
        line-height: 1.65;
      }
      .grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 14px;
        margin: 20px 0 0;
      }
      .card {
        padding: 16px;
        border-radius: 18px;
        background: #f8fafc;
        border: 1px solid #dbeafe;
      }
      .label {
        font-size: 13px;
        color: #475569;
        margin-bottom: 6px;
      }
      .value {
        font-size: 30px;
        font-weight: 800;
      }
      .actions {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin: 20px 0;
      }
      button,
      a.link-button {
        border: none;
        border-radius: 999px;
        padding: 12px 16px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 700;
        text-decoration: none;
        color: #ffffff;
        background: linear-gradient(135deg, #2563eb, #0f766e);
      }
      a.link-button.secondary,
      button.secondary {
        color: #0f172a;
        background: #e2e8f0;
      }
      .notes {
        margin-top: 24px;
        padding: 18px;
        border-radius: 18px;
        background: rgba(255, 255, 255, 0.72);
      }
      .log {
        margin-top: 18px;
        padding: 18px;
        border-radius: 18px;
        background: #0f172a;
        color: #e2e8f0;
      }
      .spacer {
        height: 560px;
      }
    </style>
    <script>
      let counter = 0;

      function updateCounter() {
        document.getElementById('counter').textContent = counter;
      }

      function incrementCounter() {
        counter += 1;
        updateCounter();
        console.log('Counter increased to ' + counter);
      }

      function pingFlutter() {
        if (window.FlutterBridge) {
          FlutterBridge.postMessage('Inline HTML counter is ' + counter);
        }
      }

      function openAlertDemo() {
        alert('alert() from inside the inline WebView page');
      }

      function openConfirmDemo() {
        const confirmed = confirm('Keep the inline HTML page active?');
        document.getElementById('confirm-result').textContent =
          confirmed ? 'accepted' : 'cancelled';
        console.info('confirm() result -> ' + confirmed);
      }

      function openPromptDemo() {
        const label = prompt('Rename the badge label', 'webview_flutter');
        document.getElementById('prompt-result').textContent =
          label === null ? 'dismissed' : label;
        console.debug('prompt() result -> ' + label);
      }

      window.addEventListener('load', () => {
        updateCounter();
        console.log('Inline webview page loaded');
      });
    </script>
  </head>
  <body>
    <div class="shell">
      <div class="hero">
        <div class="eyebrow">Embedded HTML</div>
        <h1>webview_flutter in a real widget tree</h1>
        <p>
          This page is loaded with <code>loadHtmlString</code>. The Flutter side
          wires a <code>NavigationDelegate</code>, a JavaScript channel, console
          logging callbacks, dialog handlers, progress updates, and controller
          actions such as reload, history navigation, scroll control, cache
          clearing, and metadata inspection.
        </p>

        <div class="grid">
          <div class="card">
            <div class="label">Counter</div>
            <div class="value" id="counter">0</div>
          </div>
          <div class="card">
            <div class="label">confirm()</div>
            <div class="value" id="confirm-result">pending</div>
          </div>
          <div class="card">
            <div class="label">prompt()</div>
            <div class="value" id="prompt-result">pending</div>
          </div>
        </div>

        <div class="actions">
          <button onclick="incrementCounter()">Increment Counter</button>
          <button onclick="pingFlutter()">Send JS Channel Message</button>
          <button onclick="openAlertDemo()">Open alert()</button>
          <button onclick="openConfirmDemo()">Open confirm()</button>
          <button onclick="openPromptDemo()">Open prompt()</button>
          <a class="link-button secondary" href="https://flutter.dev">
            Load flutter.dev
          </a>
          <a
            class="link-button secondary"
            href="https://www.youtube.com/results?search_query=flutter"
          >
            Try blocked URL
          </a>
        </div>

        <div class="notes">
          <strong>Tip:</strong> use the Flutter buttons around the WebView to
          reload, read DOM state with <code>runJavaScriptReturningResult</code>,
          inject additional UI, scroll, and inspect title, URL, and history.
        </div>
      </div>

      <div class="log">
        Scroll inside this page to trigger the Flutter-side
        <code>setOnScrollPositionChange</code> callback.
      </div>

      <div class="spacer"></div>
    </div>
  </body>
</html>
''';

  final List<String> _eventLog = <String>[];
  late final WebViewController _controller;

  int _progress = 0;
  String _currentUrl = 'No page loaded yet.';
  String _pageTitle = 'No title reported yet.';
  String _userAgent = 'Not fetched yet.';
  String _jsResult = 'Run the JavaScript actions to inspect the page state.';
  Offset _scrollPosition = Offset.zero;
  bool _controllerReady = false;
  bool _canGoBack = false;
  bool _canGoForward = false;
  _WebViewSource _selectedSource = _WebViewSource.inlineHtml;

  bool get _supportsWebView {
    if (kIsWeb) {
      return false;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();

    if (_supportsWebView) {
      _controller = WebViewController();
      unawaited(_initializeController());
    }
  }

  Future<void> _initializeController() async {
    try {
      await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await _configureBackgroundColor();
      await _controller.enableZoom(true);
      await _controller.setUserAgent('widget_layout_example2/webview-demo');
      await _controller.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('youtube.com') ||
                request.url.startsWith('mailto:')) {
              _addLog('Blocked navigation: ${request.url}');
              _showSnackBar('NavigationDelegate blocked ${request.url}');
              return NavigationDecision.prevent;
            }

            _addLog('Navigation request: ${request.url}');
            return NavigationDecision.navigate;
          },
          onProgress: (int progress) {
            if (!mounted) {
              return;
            }

            setState(() {
              _progress = progress;
            });
          },
          onPageStarted: (String url) {
            if (!mounted) {
              return;
            }

            setState(() {
              _currentUrl = url;
            });
            _addLog('Page started: $url');
          },
          onPageFinished: (String url) {
            if (!mounted) {
              return;
            }

            setState(() {
              _progress = 100;
              _currentUrl = url;
            });
            _addLog('Page finished: $url');
            unawaited(_refreshMetadata());
          },
          onUrlChange: (UrlChange change) {
            final String url = change.url ?? 'unknown';
            if (!mounted) {
              return;
            }

            setState(() {
              _currentUrl = url;
            });
            _addLog('URL changed: $url');
          },
          onHttpError: (HttpResponseError error) {
            final int? statusCode = error.response?.statusCode;
            _addLog('HTTP error: ${statusCode ?? 'unknown status'}');
          },
          onWebResourceError: (WebResourceError error) {
            _addLog(
              'Web resource error: ${error.description} (${error.errorType ?? error.errorCode})',
            );
          },
        ),
      );
      await _controller.addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: (JavaScriptMessage message) {
          _addLog('JS channel message: ${message.message}');
          _showSnackBar(message.message);
        },
      );
      await _controller.setOnConsoleMessage((JavaScriptConsoleMessage message) {
        _addLog('console.${message.level.name}: ${message.message}');
      });
      await _configureScrollPositionListener();
      await _controller.setOnJavaScriptAlertDialog(_handleJavaScriptAlert);
      await _controller.setOnJavaScriptConfirmDialog(_handleJavaScriptConfirm);
      await _controller.setOnJavaScriptTextInputDialog(_handleJavaScriptPrompt);

      if (!mounted) {
        return;
      }

      setState(() {
        _controllerReady = true;
      });

      await _loadInlineHtml();
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'webview_flutter module',
          context: ErrorDescription('while initializing the demo controller'),
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _jsResult = 'WebView initialization failed: $error';
      });
      _addLog('WebView initialization failed: $error');
      _showSnackBar('WebView initialization failed');
    }
  }

  Future<void> _configureBackgroundColor() async {
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      _addLog(
        'Skipped setBackgroundColor on macOS because the current WKWebView backend does not implement opaque surface updates.',
      );
      return;
    }

    try {
      await _controller.setBackgroundColor(const Color(0xFFF8FAFC));
    } on UnimplementedError {
      _addLog(
        'Skipped setBackgroundColor because the current WebView platform backend does not implement it.',
      );
    }
  }

  Future<void> _configureScrollPositionListener() async {
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      _addLog(
        'Skipped setOnScrollPositionChange on macOS because the current WKWebView backend does not implement it.',
      );
      return;
    }

    try {
      await _controller.setOnScrollPositionChange((
        ScrollPositionChange change,
      ) {
        if (!mounted) {
          return;
        }

        setState(() {
          _scrollPosition = Offset(change.x, change.y);
        });
      });
    } on UnimplementedError {
      _addLog(
        'Skipped setOnScrollPositionChange because the current WebView platform backend does not implement it.',
      );
    }
  }

  Future<void> _loadInlineHtml() async {
    await _controller.loadHtmlString(_inlineHtml, baseUrl: _inlineHtmlBaseUrl);
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedSource = _WebViewSource.inlineHtml;
      _jsResult = 'Loaded the inline HTML demo with loadHtmlString(...).';
    });
    _addLog('Loaded inline HTML via loadHtmlString');
  }

  Future<void> _loadFlutterSite() async {
    await _controller.loadRequest(Uri.parse('https://flutter.dev'));
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedSource = _WebViewSource.flutterSite;
      _jsResult = 'Requested https://flutter.dev with loadRequest(...).';
    });
    _addLog('Loaded https://flutter.dev');
  }

  Future<void> _loadPackagePage() async {
    await _controller.loadRequest(
      Uri.parse('https://pub.dev/packages/webview_flutter'),
    );
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedSource = _WebViewSource.packagePage;
      _jsResult =
          'Requested the package page with loadRequest(Uri.parse(...)).';
    });
    _addLog('Loaded the package page on pub.dev');
  }

  Future<void> _refreshMetadata() async {
    final String currentUrl = await _controller.currentUrl() ?? _currentUrl;
    final String title = await _controller.getTitle() ?? 'No title reported.';
    final String userAgent = await _controller.getUserAgent() ?? 'Unknown';
    Offset scrollPosition = _scrollPosition;
    if (defaultTargetPlatform != TargetPlatform.macOS) {
      try {
        scrollPosition = await _controller.getScrollPosition();
      } on UnimplementedError {
        // getScrollPosition is not supported on macOS.
      }
    }
    final bool canGoBack = await _controller.canGoBack();
    final bool canGoForward = await _controller.canGoForward();

    if (!mounted) {
      return;
    }

    setState(() {
      _currentUrl = currentUrl;
      _pageTitle = title;
      _userAgent = userAgent;
      _scrollPosition = scrollPosition;
      _canGoBack = canGoBack;
      _canGoForward = canGoForward;
    });
  }

  Future<void> _readInlineCounter() async {
    try {
      final Object result = await _controller.runJavaScriptReturningResult(
        'Number(document.getElementById("counter")?.textContent ?? 0)',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _jsResult = 'runJavaScriptReturningResult -> counter = $result';
      });
      _addLog('Read DOM counter with runJavaScriptReturningResult');
    } catch (error) {
      _reportActionError('Reading DOM state', error);
    }
  }

  Future<void> _injectBanner() async {
    try {
      await _controller.runJavaScript('''
        (function () {
          const existing = document.getElementById('flutter-banner');
          if (existing) {
            existing.remove();
          }
          const banner = document.createElement('div');
          banner.id = 'flutter-banner';
          banner.textContent = 'Injected from Flutter via runJavaScript';
          banner.style.position = 'fixed';
          banner.style.right = '16px';
          banner.style.bottom = '16px';
          banner.style.padding = '12px 16px';
          banner.style.borderRadius = '999px';
          banner.style.background = '#111827';
          banner.style.color = '#F8FAFC';
          banner.style.zIndex = '9999';
          banner.style.boxShadow = '0 16px 36px rgba(15, 23, 42, 0.25)';
          document.body.appendChild(banner);
          console.log('Flutter injected a banner into the DOM');
        })();
      ''');

      if (!mounted) {
        return;
      }

      setState(() {
        _jsResult = 'Injected a DOM banner with runJavaScript(...).';
      });
      _addLog('Injected DOM banner from Flutter');
    } catch (error) {
      _reportActionError('Injecting a DOM banner', error);
    }
  }

  Future<void> _scrollToTop() async {
    try {
      await _controller.scrollTo(0, 0);
      _addLog('Scrolled the WebView back to the top');
      await _refreshMetadata();
    } catch (error) {
      _reportActionError('Scrolling the WebView', error);
    }
  }

  Future<void> _clearBrowserData() async {
    try {
      await _controller.clearCache();
      await _controller.clearLocalStorage();
      if (!mounted) {
        return;
      }

      setState(() {
        _jsResult =
            'Called clearCache() and clearLocalStorage() on the controller.';
      });
      _addLog('Cleared cache and local storage');
    } catch (error) {
      _reportActionError('Clearing WebView data', error);
    }
  }

  Future<void> _goBack() async {
    if (!_canGoBack) {
      return;
    }

    await _controller.goBack();
    _addLog('Navigated backward in WebView history');
    await _refreshMetadata();
  }

  Future<void> _goForward() async {
    if (!_canGoForward) {
      return;
    }

    await _controller.goForward();
    _addLog('Navigated forward in WebView history');
    await _refreshMetadata();
  }

  Future<void> _reload() async {
    await _controller.reload();
    _addLog('Reloaded the current page');
    await _refreshMetadata();
  }

  Future<void> _handleJavaScriptAlert(
    JavaScriptAlertDialogRequest request,
  ) async {
    _addLog('alert(): ${request.message}');

    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('JavaScript alert()'),
          content: Text(request.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _handleJavaScriptConfirm(
    JavaScriptConfirmDialogRequest request,
  ) async {
    _addLog('confirm(): ${request.message}');

    if (!mounted) {
      return false;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('JavaScript confirm()'),
          content: Text(request.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  Future<String> _handleJavaScriptPrompt(
    JavaScriptTextInputDialogRequest request,
  ) async {
    _addLog('prompt(): ${request.message}');

    if (!mounted) {
      return request.defaultText ?? '';
    }

    final TextEditingController controller = TextEditingController(
      text: request.defaultText ?? '',
    );
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('JavaScript prompt()'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(request.message),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Return value',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(request.defaultText),
              child: const Text('Use Default'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Send'),
            ),
          ],
        );
      },
    );

    controller.dispose();
    return result ?? request.defaultText ?? '';
  }

  void _reportActionError(String action, Object error) {
    if (!mounted) {
      return;
    }

    setState(() {
      _jsResult = '$action failed: $error';
    });
    _addLog('$action failed: $error');
    _showSnackBar('$action failed');
  }

  void _addLog(String message) {
    if (!mounted) {
      return;
    }

    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    setState(() {
      _eventLog.insert(0, '$stamp  $message');
      if (_eventLog.length > 18) {
        _eventLog.removeRange(18, _eventLog.length);
      }
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('webview_flutter Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'Embed web content with controller-driven navigation, JavaScript interop, and lifecycle callbacks.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This module demonstrates `WebViewController`, `WebViewWidget`, '
            '`loadHtmlString`, `loadRequest`, `NavigationDelegate`, '
            '`addJavaScriptChannel`, `runJavaScript`, '
            '`runJavaScriptReturningResult`, dialog interception, console '
            'logging, scroll listeners, cache clearing, and history controls.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          if (_supportsWebView)
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool useWideLayout = constraints.maxWidth >= 1080;
                final Widget preview = _PreviewCard(
                  controllerReady: _controllerReady,
                  progress: _progress,
                  selectedSource: _selectedSource,
                  currentUrl: _currentUrl,
                  pageTitle: _pageTitle,
                  canGoBack: _canGoBack,
                  canGoForward: _canGoForward,
                  child: _controllerReady
                      ? WebViewWidget(controller: _controller)
                      : const Center(child: CircularProgressIndicator()),
                );
                final Widget controls = _ControlsColumn(
                  onLoadInlineHtml: _controllerReady ? _loadInlineHtml : null,
                  onLoadFlutterSite: _controllerReady ? _loadFlutterSite : null,
                  onLoadPackagePage: _controllerReady ? _loadPackagePage : null,
                  onReadInlineCounter: _controllerReady
                      ? _readInlineCounter
                      : null,
                  onInjectBanner: _controllerReady ? _injectBanner : null,
                  onRefreshMetadata: _controllerReady ? _refreshMetadata : null,
                  onGoBack: _controllerReady && _canGoBack ? _goBack : null,
                  onGoForward: _controllerReady && _canGoForward
                      ? _goForward
                      : null,
                  onReload: _controllerReady ? _reload : null,
                  onScrollToTop: _controllerReady ? _scrollToTop : null,
                  onClearBrowserData: _controllerReady
                      ? _clearBrowserData
                      : null,
                  jsResult: _jsResult,
                  userAgent: _userAgent,
                  scrollPosition: _scrollPosition,
                  eventLog: _eventLog,
                );

                if (useWideLayout) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 7, child: preview),
                      const SizedBox(width: 20),
                      Expanded(flex: 5, child: controls),
                    ],
                  );
                }

                return Column(
                  children: <Widget>[
                    preview,
                    const SizedBox(height: 20),
                    controls,
                  ],
                );
              },
            )
          else
            const _UnsupportedWebViewCard(),
          const SizedBox(height: 20),
          const _CodeSampleCard(
            title: 'Controller Setup',
            code: '''
final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0xFFF8FAFC))
  ..setUserAgent('widget_layout_example2/webview-demo')
  ..addJavaScriptChannel(
    'FlutterBridge',
    onMessageReceived: (message) {
      debugPrint(message.message);
    },
  )
  ..loadHtmlString(html, baseUrl: 'https://widget-layout-example.local/');
''',
          ),
          const SizedBox(height: 16),
          const _CodeSampleCard(
            title: 'Delegate, JS, and Metadata',
            code: r'''
await controller.setNavigationDelegate(
  NavigationDelegate(
    onNavigationRequest: (request) {
      if (request.url.contains('youtube.com')) {
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    },
    onProgress: (progress) => debugPrint('progress: $progress'),
    onPageFinished: (_) async {
      final title = await controller.getTitle();
      final canGoBack = await controller.canGoBack();
      debugPrint('title=$title canGoBack=$canGoBack');
    },
  ),
);

final count = await controller.runJavaScriptReturningResult(
  'Number(document.getElementById("counter")?.textContent ?? 0)',
);
''',
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

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.controllerReady,
    required this.progress,
    required this.selectedSource,
    required this.currentUrl,
    required this.pageTitle,
    required this.canGoBack,
    required this.canGoForward,
    required this.child,
  });

  final bool controllerReady;
  final int progress;
  final _WebViewSource selectedSource;
  final String currentUrl;
  final String pageTitle;
  final bool canGoBack;
  final bool canGoForward;
  final Widget child;

  String get _sourceLabel {
    switch (selectedSource) {
      case _WebViewSource.inlineHtml:
        return 'Inline HTML';
      case _WebViewSource.flutterSite:
        return 'flutter.dev';
      case _WebViewSource.packagePage:
        return 'pub.dev package page';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Live WebView',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _InfoChip(label: 'Source', value: _sourceLabel),
                _InfoChip(label: 'Progress', value: '$progress%'),
                _InfoChip(label: 'Back', value: canGoBack ? 'Yes' : 'No'),
                _InfoChip(label: 'Forward', value: canGoForward ? 'Yes' : 'No'),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: controllerReady ? progress / 100 : null,
              minHeight: 6,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.45,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Current URL',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(currentUrl, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  Text(
                    'Page Title',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(pageTitle, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: SizedBox(height: 460, child: child),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsColumn extends StatelessWidget {
  const _ControlsColumn({
    required this.onLoadInlineHtml,
    required this.onLoadFlutterSite,
    required this.onLoadPackagePage,
    required this.onReadInlineCounter,
    required this.onInjectBanner,
    required this.onRefreshMetadata,
    required this.onGoBack,
    required this.onGoForward,
    required this.onReload,
    required this.onScrollToTop,
    required this.onClearBrowserData,
    required this.jsResult,
    required this.userAgent,
    required this.scrollPosition,
    required this.eventLog,
  });

  final Future<void> Function()? onLoadInlineHtml;
  final Future<void> Function()? onLoadFlutterSite;
  final Future<void> Function()? onLoadPackagePage;
  final Future<void> Function()? onReadInlineCounter;
  final Future<void> Function()? onInjectBanner;
  final Future<void> Function()? onRefreshMetadata;
  final Future<void> Function()? onGoBack;
  final Future<void> Function()? onGoForward;
  final Future<void> Function()? onReload;
  final Future<void> Function()? onScrollToTop;
  final Future<void> Function()? onClearBrowserData;
  final String jsResult;
  final String userAgent;
  final Offset scrollPosition;
  final List<String> eventLog;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _SectionCard(
          title: 'Load Sources',
          subtitle:
              'Switch between inline HTML and remote HTTPS pages with the same controller.',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              FilledButton.icon(
                onPressed: onLoadInlineHtml == null
                    ? null
                    : () => unawaited(onLoadInlineHtml!()),
                icon: const Icon(Icons.code),
                label: const Text('Inline HTML'),
              ),
              OutlinedButton.icon(
                onPressed: onLoadFlutterSite == null
                    ? null
                    : () => unawaited(onLoadFlutterSite!()),
                icon: const Icon(Icons.flutter_dash),
                label: const Text('flutter.dev'),
              ),
              OutlinedButton.icon(
                onPressed: onLoadPackagePage == null
                    ? null
                    : () => unawaited(onLoadPackagePage!()),
                icon: const Icon(Icons.inventory_2_outlined),
                label: const Text('pub.dev'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Controller Actions',
          subtitle:
              'These buttons call WebViewController methods directly from Flutter.',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              FilledButton(
                onPressed: onReadInlineCounter == null
                    ? null
                    : () => unawaited(onReadInlineCounter!()),
                child: const Text('Read DOM Counter'),
              ),
              FilledButton(
                onPressed: onInjectBanner == null
                    ? null
                    : () => unawaited(onInjectBanner!()),
                child: const Text('Inject Banner'),
              ),
              OutlinedButton(
                onPressed: onRefreshMetadata == null
                    ? null
                    : () => unawaited(onRefreshMetadata!()),
                child: const Text('Refresh Metadata'),
              ),
              OutlinedButton(
                onPressed: onGoBack == null
                    ? null
                    : () => unawaited(onGoBack!()),
                child: const Text('Back'),
              ),
              OutlinedButton(
                onPressed: onGoForward == null
                    ? null
                    : () => unawaited(onGoForward!()),
                child: const Text('Forward'),
              ),
              OutlinedButton(
                onPressed: onReload == null
                    ? null
                    : () => unawaited(onReload!()),
                child: const Text('Reload'),
              ),
              OutlinedButton(
                onPressed: onScrollToTop == null
                    ? null
                    : () => unawaited(onScrollToTop!()),
                child: const Text('Scroll To Top'),
              ),
              OutlinedButton(
                onPressed: onClearBrowserData == null
                    ? null
                    : () => unawaited(onClearBrowserData!()),
                child: const Text('Clear Cache + Storage'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Runtime State',
          subtitle:
              'The state below comes back from JavaScript execution and controller metadata APIs.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(jsResult),
              const SizedBox(height: 12),
              Text('User-Agent: $userAgent'),
              const SizedBox(height: 8),
              Text(
                'Scroll position: x=${scrollPosition.dx.toStringAsFixed(0)}, '
                'y=${scrollPosition.dy.toStringAsFixed(0)}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Event Log',
          subtitle:
              'Navigation, console output, JS channel messages, and WebView errors land here.',
          child: Column(
            children: eventLog.isEmpty
                ? const <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('No events yet.'),
                    ),
                  ]
                : eventLog
                      .map(
                        (String entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(entry),
                          ),
                        ),
                      )
                      .toList(),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

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
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(subtitle),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
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
                code,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Chip(
      label: Text(
        '$label: $value',
        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _UnsupportedWebViewCard extends StatelessWidget {
  const _UnsupportedWebViewCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              'Live WebView is unavailable on this runtime.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),
            Text(
              'This demo page still documents how to use `webview_flutter`, '
              'but the embedded preview is intentionally limited to Android, '
              'iOS, and macOS in this app so unsupported targets do not crash.',
            ),
          ],
        ),
      ),
    );
  }
}
