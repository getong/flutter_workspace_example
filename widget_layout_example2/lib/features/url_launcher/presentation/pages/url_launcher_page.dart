import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.urlLauncher)
class UrlLauncherPage extends StatefulWidget {
  const UrlLauncherPage({super.key});

  @override
  State<UrlLauncherPage> createState() => _UrlLauncherPageState();
}

class _UrlLauncherPageState extends State<UrlLauncherPage> {
  final TextEditingController _customUrlController = TextEditingController(
    text: 'https://pub.dev/packages/url_launcher',
  );
  final TextEditingController _subjectController = TextEditingController(
    text: 'Widget Layout Example',
  );
  final TextEditingController _bodyController = TextEditingController(
    text: 'Testing url_launcher from the demo module.',
  );

  final List<String> _eventLog = <String>[];

  String _status =
      'Use the actions below to inspect support, launch URLs in different modes, and exercise the string-based helpers.';
  bool _supportsExternalApplication = false;
  bool _supportsExternalNonBrowserApplication = false;
  bool _supportsInAppBrowserView = false;
  bool _supportsInAppWebView = false;
  bool _supportsCloseForBrowserView = false;
  bool _supportsCloseForWebView = false;

  @override
  void initState() {
    super.initState();
    unawaited(_refreshLaunchCapabilities());
  }

  @override
  void dispose() {
    _customUrlController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _refreshLaunchCapabilities() async {
    final bool externalApplication = await supportsLaunchMode(
      LaunchMode.externalApplication,
    );
    final bool externalNonBrowserApplication = await supportsLaunchMode(
      LaunchMode.externalNonBrowserApplication,
    );
    final bool inAppBrowserView = await supportsLaunchMode(
      LaunchMode.inAppBrowserView,
    );
    final bool inAppWebView = await supportsLaunchMode(LaunchMode.inAppWebView);
    final bool closeForBrowserView = await supportsCloseForLaunchMode(
      LaunchMode.inAppBrowserView,
    );
    final bool closeForWebView = await supportsCloseForLaunchMode(
      LaunchMode.inAppWebView,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _supportsExternalApplication = externalApplication;
      _supportsExternalNonBrowserApplication = externalNonBrowserApplication;
      _supportsInAppBrowserView = inAppBrowserView;
      _supportsInAppWebView = inAppWebView;
      _supportsCloseForBrowserView = closeForBrowserView;
      _supportsCloseForWebView = closeForWebView;
      _status =
          'Capability check refreshed with supportsLaunchMode(...) and supportsCloseForLaunchMode(...).';
    });
    _addLog('Refreshed launch mode capability summary.');
  }

  Uri _mailUri() {
    return Uri(
      scheme: 'mailto',
      path: 'hello@example.com',
      queryParameters: <String, String>{
        'subject': _subjectController.text,
        'body': _bodyController.text,
      },
    );
  }

  Uri _phoneUri() {
    return Uri(scheme: 'tel', path: '+1234567890');
  }

  Uri _smsUri() {
    return Uri(
      scheme: 'sms',
      path: '+1234567890',
      queryParameters: <String, String>{'body': 'Testing SMS launch'},
    );
  }

  Future<void> _checkCustomUrlSupport() async {
    final String raw = _customUrlController.text.trim();
    final Uri? uri = Uri.tryParse(raw);

    if (uri == null) {
      setState(() {
        _status = 'The custom URL is not a valid Uri: $raw';
      });
      _addLog('Custom URL parsing failed for "$raw".');
      return;
    }

    try {
      final bool canLaunch = await canLaunchUrl(uri);
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'canLaunchUrl($uri) returned $canLaunch.';
      });
      _addLog('Checked canLaunchUrl for $uri -> $canLaunch');
    } catch (error) {
      _recordError('canLaunchUrl($uri) failed', error);
    }
  }

  Future<void> _launchExternalSite() async {
    await _launchUri(
      Uri.parse('https://flutter.dev'),
      label: 'External site',
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _launchInAppBrowser() async {
    await _launchUri(
      Uri.parse('https://docs.flutter.dev'),
      label: 'In-app browser view',
      mode: LaunchMode.inAppBrowserView,
      browserConfiguration: const BrowserConfiguration(showTitle: true),
    );
  }

  Future<void> _launchInAppWebViewDemo() async {
    await _launchUri(
      Uri.parse('https://pub.dev/packages/url_launcher'),
      label: 'In-app web view',
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
        enableDomStorage: true,
        headers: <String, String>{'X-Demo-Source': 'url_launcher_module'},
      ),
    );
  }

  Future<void> _launchMailComposer() async {
    await _launchUri(
      _mailUri(),
      label: 'mailto launch',
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _launchTelephone() async {
    await _launchUri(
      _phoneUri(),
      label: 'tel launch',
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  Future<void> _launchSms() async {
    await _launchUri(
      _smsUri(),
      label: 'sms launch',
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  Future<void> _launchCustomUrlString() async {
    final String raw = _customUrlController.text.trim();
    if (raw.isEmpty) {
      setState(() {
        _status = 'Enter a custom URL before calling launchUrlString(...).';
      });
      _addLog('Skipped launchUrlString because the field was empty.');
      return;
    }

    try {
      final bool launched = await launchUrlString(
        raw,
        mode: LaunchMode.platformDefault,
        webOnlyWindowName: '_blank',
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'launchUrlString("$raw") returned $launched.';
      });
      _addLog('Called launchUrlString for "$raw" -> $launched');
    } catch (error) {
      _recordError('launchUrlString("$raw") failed', error);
    }
  }

  Future<void> _launchUri(
    Uri uri, {
    required String label,
    required LaunchMode mode,
    WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
    BrowserConfiguration browserConfiguration = const BrowserConfiguration(),
  }) async {
    try {
      final bool canLaunch = await canLaunchUrl(uri);
      final bool launched = await launchUrl(
        uri,
        mode: mode,
        webViewConfiguration: webViewConfiguration,
        browserConfiguration: browserConfiguration,
        webOnlyWindowName: '_blank',
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            '$label launched with mode ${mode.name}. canLaunchUrl(...) was $canLaunch and launchUrl(...) returned $launched.';
      });
      _addLog(
        '$label -> canLaunchUrl=$canLaunch, launchUrl=$launched, mode=${mode.name}, uri=$uri',
      );
    } catch (error) {
      _recordError('$label failed for $uri', error);
    }
  }

  Future<void> _closeInAppView() async {
    try {
      await closeInAppWebView();
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Called closeInAppWebView().';
      });
      _addLog('Requested closeInAppWebView().');
    } catch (error) {
      _recordError('closeInAppWebView() failed', error);
    }
  }

  void _recordError(String label, Object error) {
    if (!mounted) {
      return;
    }

    setState(() {
      _status = '$label: $error';
    });
    _addLog('$label: $error');
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
      if (_eventLog.length > 16) {
        _eventLog.removeRange(16, _eventLog.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('url_launcher Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Launch web pages, app links, and communication intents with `url_launcher`.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `canLaunchUrl`, `launchUrl`, '
              '`launchUrlString`, `supportsLaunchMode`, '
              '`supportsCloseForLaunchMode`, `closeInAppWebView`, multiple '
              '`LaunchMode` values, `BrowserConfiguration`, and '
              '`WebViewConfiguration`.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Capability Summary',
              subtitle:
                  'Support varies by platform, so this checks the current backend before you tap actions.',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  _StatusChip(
                    label: 'externalApplication',
                    value: _supportsExternalApplication ? 'Yes' : 'No',
                  ),
                  _StatusChip(
                    label: 'externalNonBrowserApplication',
                    value: _supportsExternalNonBrowserApplication
                        ? 'Yes'
                        : 'No',
                  ),
                  _StatusChip(
                    label: 'inAppBrowserView',
                    value: _supportsInAppBrowserView ? 'Yes' : 'No',
                  ),
                  _StatusChip(
                    label: 'inAppWebView',
                    value: _supportsInAppWebView ? 'Yes' : 'No',
                  ),
                  _StatusChip(
                    label: 'close browser view',
                    value: _supportsCloseForBrowserView ? 'Yes' : 'No',
                  ),
                  _StatusChip(
                    label: 'close web view',
                    value: _supportsCloseForWebView ? 'Yes' : 'No',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Status',
              subtitle:
                  'Each action updates the most recent result so you can inspect support and failures.',
              child: Text(_status),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Launch Examples',
              subtitle:
                  'Use these buttons to trigger common `url_launcher` flows with different modes and schemes.',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: () => unawaited(_launchExternalSite()),
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('External Site'),
                  ),
                  FilledButton.icon(
                    onPressed: () => unawaited(_launchInAppBrowser()),
                    icon: const Icon(Icons.web_asset),
                    label: const Text('In-App Browser View'),
                  ),
                  FilledButton.icon(
                    onPressed: () => unawaited(_launchInAppWebViewDemo()),
                    icon: const Icon(Icons.web),
                    label: const Text('In-App WebView'),
                  ),
                  FilledButton.icon(
                    onPressed: () => unawaited(_launchMailComposer()),
                    icon: const Icon(Icons.mail_outline),
                    label: const Text('mailto'),
                  ),
                  FilledButton.icon(
                    onPressed: () => unawaited(_launchTelephone()),
                    icon: const Icon(Icons.call_outlined),
                    label: const Text('tel'),
                  ),
                  FilledButton.icon(
                    onPressed: () => unawaited(_launchSms()),
                    icon: const Icon(Icons.sms_outlined),
                    label: const Text('sms'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => unawaited(_closeInAppView()),
                    icon: const Icon(Icons.close_fullscreen),
                    label: const Text('Close In-App View'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => unawaited(_refreshLaunchCapabilities()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Support'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Custom URL Playground',
              subtitle:
                  'Try `canLaunchUrl` with a parsed `Uri`, then compare it with the string-based helper.',
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _customUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Custom URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilledButton(
                        onPressed: () => unawaited(_checkCustomUrlSupport()),
                        child: const Text('canLaunchUrl'),
                      ),
                      OutlinedButton(
                        onPressed: () => unawaited(_launchCustomUrlString()),
                        child: const Text('launchUrlString'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Intent Data Builders',
              subtitle:
                  'These fields are used to build the demo `mailto:` URI with query parameters.',
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Email subject',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _bodyController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Email body',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'mailto URI preview: ${_mailUri()}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: 'Uri-Based API',
              code: r'''
final mailUri = Uri(
  scheme: 'mailto',
  path: 'hello@example.com',
  queryParameters: <String, String>{
    'subject': 'Widget Layout Example',
    'body': 'Testing url_launcher from the demo module.',
  },
);

final canLaunch = await canLaunchUrl(mailUri);
final launched = await launchUrl(
  mailUri,
  mode: LaunchMode.externalApplication,
);
''',
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: 'Modes, WebView, and String API',
              code: r'''
await launchUrl(
  Uri.parse('https://pub.dev/packages/url_launcher'),
  mode: LaunchMode.inAppWebView,
  webViewConfiguration: const WebViewConfiguration(
    enableJavaScript: true,
    enableDomStorage: true,
    headers: <String, String>{'X-Demo-Source': 'url_launcher_module'},
  ),
);

final supportsWebView = await supportsLaunchMode(LaunchMode.inAppWebView);
final supportsClose = await supportsCloseForLaunchMode(
  LaunchMode.inAppWebView,
);

await launchUrlString(
  'https://pub.dev/packages/url_launcher',
  mode: LaunchMode.platformDefault,
  webOnlyWindowName: '_blank',
);
''',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Event Log',
              subtitle:
                  'Each support check and launch call is recorded here for quick inspection.',
              child: Column(
                children: _eventLog.isEmpty
                    ? const <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('No url_launcher events yet.'),
                        ),
                      ]
                    : _eventLog
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}
