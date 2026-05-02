// ignore_for_file: experimental_member_use

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart'
    as custom_tabs_lite;
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.flutterCustomTabs)
class FlutterCustomTabsPage extends StatefulWidget {
  const FlutterCustomTabsPage({super.key});

  @override
  State<FlutterCustomTabsPage> createState() => _FlutterCustomTabsPageState();
}

class _FlutterCustomTabsPageState extends State<FlutterCustomTabsPage> {
  final TextEditingController _urlController = TextEditingController(
    text: 'https://flutter.dev',
  );
  final List<String> _eventLog = <String>[];

  CustomTabsSession? _session;
  SafariViewPrewarmingSession? _prewarmingSession;
  Timer? _closeTimer;

  String _status =
      'Warm up the browser session, prefetch likely URLs, and launch themed tabs with different configurations.';
  bool _prefersDefaultBrowser = true;
  bool _prefersDeepLink = false;
  bool _entersReaderIfAvailable = false;

  @override
  void dispose() {
    _closeTimer?.cancel();
    _urlController.dispose();
    unawaited(_disposeSessions());
    super.dispose();
  }

  Future<void> _disposeSessions() async {
    final SafariViewPrewarmingSession? prewarmingSession = _prewarmingSession;
    final CustomTabsSession? session = _session;
    _prewarmingSession = null;
    _session = null;

    if (prewarmingSession != null) {
      await invalidateSession(prewarmingSession);
    }
    if (session != null) {
      await invalidateSession(session);
    }
  }

  Uri? _activeUri() {
    final String raw = _urlController.text.trim();
    if (raw.isEmpty) {
      return null;
    }
    final Uri? uri = Uri.tryParse(raw);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return null;
    }
    return uri;
  }

  void _addLog(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    setState(() {
      _eventLog.insert(0, '$timestamp  $message');
      if (_eventLog.length > 10) {
        _eventLog.removeLast();
      }
    });
  }

  Future<void> _runAction(
    String label,
    Future<void> Function(Uri uri) action,
  ) async {
    final Uri? uri = _activeUri();
    if (uri == null) {
      setState(() {
        _status =
            'Enter a valid http/https URL before running "$label". `flutter_custom_tabs` only accepts web URLs.';
      });
      _addLog('$label skipped because the URL was invalid.');
      return;
    }

    try {
      await action(uri);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = '$label failed: $error';
      });
      _addLog('$label failed: $error');
    }
  }

  CustomTabsBrowserConfiguration _browserConfiguration() {
    final CustomTabsSession? session = _session;
    if (session != null) {
      return CustomTabsBrowserConfiguration.session(
        session,
        headers: const <String, String>{'X-Demo-Source': 'flutter_custom_tabs'},
      );
    }

    return CustomTabsBrowserConfiguration(
      prefersDefaultBrowser: _prefersDefaultBrowser,
      fallbackCustomTabs: const <String>[
        'org.mozilla.firefox',
        'com.microsoft.emmx',
      ],
    );
  }

  Future<void> _warmupSession() async {
    try {
      final CustomTabsSession session = await warmupCustomTabs(
        options: CustomTabsSessionOptions(
          prefersDefaultBrowser: _prefersDefaultBrowser,
          fallbackCustomTabs: const <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
      );

      if (!mounted) {
        await invalidateSession(session);
        return;
      }

      setState(() {
        _session = session;
        _status =
            'Created a warmup session. On Android this can reduce launch latency; on other platforms it becomes a safe no-op.';
      });
      _addLog('warmupCustomTabs -> $session');
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'warmupCustomTabs failed: $error';
      });
      _addLog('warmupCustomTabs failed: $error');
    }
  }

  Future<void> _prefetchLikelyUrls(Uri uri) async {
    final SafariViewPrewarmingSession session = await mayLaunchUrls(<Uri>[
      uri,
      Uri.parse('https://dart.dev'),
      Uri.parse('https://pub.dev'),
    ], customTabsSession: _session);

    if (!mounted) {
      await invalidateSession(session);
      return;
    }

    setState(() {
      _prewarmingSession = session;
      _status =
          'Prefetched likely destinations with mayLaunchUrls(...). This is most useful shortly before a launch.';
    });
    _addLog('mayLaunchUrls prepared $uri and two secondary URLs.');
  }

  Future<void> _launchStandard(Uri uri) async {
    final ThemeData theme = Theme.of(context);
    await launchUrl(
      uri,
      prefersDeepLink: _prefersDeepLink,
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          colorScheme: theme.brightness.toColorScheme(),
          toolbarColor: theme.colorScheme.surface,
          navigationBarColor: theme.colorScheme.surfaceContainer,
          navigationBarDividerColor: theme.dividerColor,
        ),
        shareState: CustomTabsShareState.on,
        showTitle: true,
        urlBarHidingEnabled: true,
        bookmarksButtonEnabled: true,
        downloadButtonEnabled: true,
        closeButton: CustomTabsCloseButton(
          icon: CustomTabsCloseButtonIcons.back,
          position: CustomTabsCloseButtonPosition.start,
        ),
        animations: CustomTabsSystemAnimations.slideIn(),
        browser: _browserConfiguration(),
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: _entersReaderIfAvailable,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _status =
          'Launched a themed custom tab with browser selection, toolbar colors, sharing, animations, and Safari view controller options.';
    });
    _addLog('launchUrl(theme) -> $uri');
  }

  Future<void> _launchPartialSheet(Uri uri) async {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    await launchUrl(
      uri,
      customTabsOptions: CustomTabsOptions.partial(
        configuration: PartialCustomTabsConfiguration.adaptiveSheet(
          initialHeight: size.height * 0.72,
          initialWidth: size.width * 0.55,
          activityHeightResizeBehavior:
              CustomTabsActivityHeightResizeBehavior.adjustable,
          activitySideSheetMaximizationEnabled: true,
          activitySideSheetDecorationType:
              CustomTabsActivitySideSheetDecorationType.divider,
          activitySideSheetRoundedCornersPosition:
              CustomTabsActivitySideSheetRoundedCornersPosition.top,
          cornerRadius: 16,
          backgroundInteractionEnabled: true,
        ),
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.primaryContainer,
          navigationBarColor: theme.colorScheme.surfaceContainerHighest,
        ),
        showTitle: true,
        shareState: CustomTabsShareState.on,
        browser: _browserConfiguration(),
      ),
      safariVCOptions: SafariViewControllerOptions.pageSheet(
        configuration: const SheetPresentationControllerConfiguration(
          detents: <SheetPresentationControllerDetent>{
            SheetPresentationControllerDetent.medium,
            SheetPresentationControllerDetent.large,
          },
          prefersScrollingExpandsWhenScrolledToEdge: true,
          prefersGrabberVisible: true,
          prefersEdgeAttachedInCompactHeight: true,
          preferredCornerRadius: 20,
        ),
        preferredBarTintColor: theme.colorScheme.primaryContainer,
        preferredControlTintColor: theme.colorScheme.onPrimaryContainer,
        entersReaderIfAvailable: _entersReaderIfAvailable,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _status =
          'Opened the URL as a partial sheet. Android uses Partial Custom Tabs, while iOS uses a page sheet Safari presentation.';
    });
    _addLog('launchUrl(partial sheet) -> $uri');
  }

  Future<void> _launchLite(Uri uri) async {
    final ThemeData theme = Theme.of(context);
    await custom_tabs_lite.launchUrl(
      uri,
      options: custom_tabs_lite.LaunchOptions(
        barColor: theme.colorScheme.surfaceContainerHighest,
        onBarColor: theme.colorScheme.onSurface,
        systemNavigationBarParams: custom_tabs_lite.SystemNavigationBarParams(
          backgroundColor: theme.colorScheme.surface,
          dividerColor: theme.dividerColor,
        ),
        barFixingEnabled: false,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _status =
          'Used the lite launcher API. This path is smaller when you only need simple bar colors and fixed-bar behavior.';
    });
    _addLog('flutter_custom_tabs_lite.launchUrl -> $uri');
  }

  Future<void> _launchAndAutoClose(Uri uri) async {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(seconds: 4), () async {
      try {
        await closeCustomTabs();
        if (!mounted) {
          return;
        }
        setState(() {
          _status = 'Called closeCustomTabs() after a short delay.';
        });
        _addLog('closeCustomTabs() fired from timer.');
      } catch (error) {
        if (!mounted) {
          return;
        }
        setState(() {
          _status = 'closeCustomTabs() failed: $error';
        });
        _addLog('closeCustomTabs() failed: $error');
      }
    });

    await _launchStandard(uri);
  }

  Future<void> _closeTabsNow() async {
    try {
      await closeCustomTabs();
      if (!mounted) {
        return;
      }
      setState(() {
        _status =
            'Requested closeCustomTabs(). Android and iOS can close earlier custom-tab presentations when supported.';
      });
      _addLog('closeCustomTabs() requested manually.');
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'closeCustomTabs() failed: $error';
      });
      _addLog('closeCustomTabs() failed: $error');
    }
  }

  String _platformSummary() {
    if (kIsWeb) {
      return 'Web: the plugin opens a browser tab and ignores native customization.';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android: Custom Tabs, partial sheets, browser warmup, sessions, animations, and extra browser selection are active.';
      case TargetPlatform.iOS:
        return 'iOS: SafariViewController options and page-sheet presentation are active.';
      default:
        return 'Desktop or other platform: availability depends on the current platform implementation, so the page catches unsupported calls.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_custom_tabs Module'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Launch current URL from AppBar',
            onPressed: () => _runAction('AppBar quick launch', _launchStandard),
            icon: const Icon(Icons.open_in_new),
          ),
        ],
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            _InfoCard(
              title: 'What This Module Shows',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'This page exercises the package beyond a single launch call: warmup sessions, URL prefetching, themed launches, partial sheets, the lite launcher, and manual close handling.',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _platformSummary(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'URL + Session State',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Web URL',
                      helperText:
                          'Use only http/https URLs for flutter_custom_tabs.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      _StateChip(
                        label: _session == null
                            ? 'Session: none'
                            : 'Session: ${_session!.packageName ?? 'ready'}',
                      ),
                      _StateChip(
                        label: _prewarmingSession == null
                            ? 'Prefetch: idle'
                            : 'Prefetch: prepared',
                      ),
                      _StateChip(
                        label: _prefersDefaultBrowser
                            ? 'Browser: prefer default'
                            : 'Browser: prefer Chrome/fallback',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Options',
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Prefer default browser session'),
                    subtitle: const Text(
                      'Passes prefersDefaultBrowser into warmup and fallback browser configuration.',
                    ),
                    value: _prefersDefaultBrowser,
                    onChanged: (bool value) {
                      setState(() {
                        _prefersDefaultBrowser = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Prefer deep link'),
                    subtitle: const Text(
                      'Lets the platform choose a native app first when possible.',
                    ),
                    value: _prefersDeepLink,
                    onChanged: (bool value) {
                      setState(() {
                        _prefersDeepLink = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Reader mode on iOS when available'),
                    subtitle: const Text(
                      'Wires entersReaderIfAvailable into SafariViewControllerOptions.',
                    ),
                    value: _entersReaderIfAvailable,
                    onChanged: (bool value) {
                      setState(() {
                        _entersReaderIfAvailable = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Actions',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _warmupSession,
                    icon: const Icon(Icons.bolt),
                    label: const Text('Warm Up Session'),
                  ),
                  FilledButton.icon(
                    onPressed: () =>
                        _runAction('Prefetch URLs', _prefetchLikelyUrls),
                    icon: const Icon(Icons.travel_explore),
                    label: const Text('Prefetch URLs'),
                  ),
                  FilledButton.icon(
                    onPressed: () =>
                        _runAction('Themed launch', _launchStandard),
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Launch Themed Tab'),
                  ),
                  FilledButton.icon(
                    onPressed: () =>
                        _runAction('Partial sheet launch', _launchPartialSheet),
                    icon: const Icon(Icons.splitscreen),
                    label: const Text('Launch Sheet'),
                  ),
                  FilledButton.icon(
                    onPressed: () => _runAction('Lite launch', _launchLite),
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Launch Lite API'),
                  ),
                  FilledButton.icon(
                    onPressed: () =>
                        _runAction('Auto-close launch', _launchAndAutoClose),
                    icon: const Icon(Icons.timer),
                    label: const Text('Launch + Auto Close'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _closeTabsNow,
                    icon: const Icon(Icons.close),
                    label: const Text('Close Tabs'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Usage Notes',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    'Standard launch uses CustomTabsOptions + SafariViewControllerOptions with colors, close button, share state, animation, and browser selection.',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Partial sheet launch demonstrates Android partial custom tabs and iOS page-sheet Safari presentation with detents.',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Warmup + mayLaunchUrls show the performance-oriented APIs that many examples skip.',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The lite launcher is useful when you only need a simpler API surface and light bar styling.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'AppBar Code Examples',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    'Use your page AppBar as a quick entry point for opening documentation, product detail pages, or support links.',
                  ),
                  SizedBox(height: 12),
                  _CodeSnippet(
                    code:
                        'AppBar(\n'
                        '  title: const Text(\'Docs\'),\n'
                        '  actions: <Widget>[\n'
                        '    IconButton(\n'
                        '      icon: const Icon(Icons.open_in_new),\n'
                        '      onPressed: () async {\n'
                        '        final theme = Theme.of(context);\n'
                        '        await launchUrl(\n'
                        '          Uri.parse(\'https://flutter.dev\'),\n'
                        '          customTabsOptions: CustomTabsOptions(\n'
                        '            colorSchemes: CustomTabsColorSchemes.defaults(\n'
                        '              toolbarColor: theme.colorScheme.surface,\n'
                        '            ),\n'
                        '            showTitle: true,\n'
                        '          ),\n'
                        '          safariVCOptions: SafariViewControllerOptions(\n'
                        '            preferredBarTintColor: theme.colorScheme.surface,\n'
                        '            preferredControlTintColor: theme.colorScheme.onSurface,\n'
                        '          ),\n'
                        '        );\n'
                        '      },\n'
                        '    ),\n'
                        '  ],\n'
                        ')',
                  ),
                  SizedBox(height: 12),
                  _CodeSnippet(
                    code:
                        'SliverAppBar(\n'
                        '  title: const Text(\'Article\'),\n'
                        '  actions: <Widget>[\n'
                        '    IconButton(\n'
                        '      icon: const Icon(Icons.language),\n'
                        '      onPressed: () async {\n'
                        '        await launchUrl(\n'
                        '          articleUrl,\n'
                        '          customTabsOptions: CustomTabsOptions.partial(\n'
                        '            configuration: PartialCustomTabsConfiguration.bottomSheet(\n'
                        '              initialHeight: 600,\n'
                        '            ),\n'
                        '            showTitle: true,\n'
                        '          ),\n'
                        '        );\n'
                        '      },\n'
                        '    ),\n'
                        '  ],\n'
                        ')',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(title: 'Status', child: Text(_status)),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Recent Events',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _eventLog.isEmpty
                    ? const <Widget>[
                        Text(
                          'No actions yet. Run any button above to populate the log.',
                        ),
                      ]
                    : _eventLog
                          .map(
                            (String entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(entry),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _StateChip extends StatelessWidget {
  const _StateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}

class _CodeSnippet extends StatelessWidget {
  const _CodeSnippet({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        code,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace', height: 1.45),
      ),
    );
  }
}
