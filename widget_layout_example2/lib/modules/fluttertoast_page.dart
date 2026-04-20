import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

@RoutePage()
class FluttertoastPage extends StatefulWidget {
  const FluttertoastPage({super.key});

  @override
  State<FluttertoastPage> createState() => _FluttertoastPageState();
}

class _FluttertoastPageState extends State<FluttertoastPage> {
  final FToast _fToast = FToast();
  final List<String> _eventLog = <String>[];

  bool _fToastInitialized = false;
  int _nativeToastCount = 0;
  int _overlayToastCount = 0;
  String _status =
      'Tap one of the toast actions below to test either the native plugin API or the custom overlay API.';

  bool get _supportsNativeToast {
    if (kIsWeb) {
      return true;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  String get _platformLabel {
    if (kIsWeb) {
      return 'web';
    }

    return defaultTargetPlatform.name;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_fToastInitialized) {
      return;
    }

    _fToast.init(context);
    _fToastInitialized = true;
    _addLog('Initialized FToast with the page context.');
  }

  Future<void> _showNativeBasicToast() async {
    await _showNativeToast(
      label: 'Basic native toast',
      msg: 'Saved changes with Fluttertoast.showToast(...)',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xFF111827),
      textColor: Colors.white,
    );
  }

  Future<void> _showNativeStyledToast() async {
    await _showNativeToast(
      label: 'Styled native toast',
      msg: 'Top-aligned toast with custom colors and longer duration.',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      fontSize: 16,
      backgroundColor: const Color(0xFF0F766E),
      textColor: const Color(0xFFF0FDFA),
      webBgColor: 'linear-gradient(to right, #0f766e, #14b8a6)',
      webPosition: 'center',
      webShowClose: true,
    );
  }

  Future<void> _showWebConfiguredToast() async {
    await _showNativeToast(
      label: 'Web-configured native toast',
      msg: 'This call also passes the web-specific close button and gradient.',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 4,
      backgroundColor: const Color(0xFF4338CA),
      textColor: Colors.white,
      webBgColor: 'linear-gradient(to right, #4338ca, #7c3aed)',
      webPosition: 'left',
      webShowClose: true,
    );
  }

  Future<void> _showNativeToast({
    required String label,
    required String msg,
    required Toast toastLength,
    required ToastGravity gravity,
    required int timeInSecForIosWeb,
    required Color backgroundColor,
    required Color textColor,
    double? fontSize,
    String? webBgColor,
    String? webPosition,
    bool webShowClose = false,
  }) async {
    if (!_supportsNativeToast) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            '$label is skipped on $_platformLabel because Fluttertoast native toasts are only supported here on Android, iOS, and web.';
      });
      _addLog(
        '$label skipped on $_platformLabel because the native platform channel is unsupported.',
      );
      return;
    }

    try {
      final bool? shown = await Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIosWeb,
        fontSize: fontSize,
        backgroundColor: backgroundColor,
        textColor: textColor,
        webBgColor: webBgColor ?? 'linear-gradient(to right, #111827, #374151)',
        webPosition: webPosition ?? 'right',
        webShowClose: webShowClose,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _nativeToastCount += 1;
        _status =
            '$label requested via Fluttertoast.showToast(...). Result: ${shown ?? 'null'}';
      });
      _addLog('$label requested through Fluttertoast.showToast(...)');
      _scheduleStatusRefresh();
    } on MissingPluginException catch (error) {
      _recordError('$label failed with MissingPluginException', error);
    } on PlatformException catch (error) {
      _recordError('$label failed with PlatformException', error);
    } catch (error) {
      _recordError('$label failed', error);
    }
  }

  Future<void> _cancelNativeToast() async {
    if (!_supportsNativeToast) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            'Fluttertoast.cancel() is unavailable on $_platformLabel because native toasts are not supported here.';
      });
      _addLog('Native toast cancel skipped on $_platformLabel.');
      return;
    }

    try {
      final bool? cancelled = await Fluttertoast.cancel();
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Fluttertoast.cancel() returned ${cancelled ?? 'null'}.';
      });
      _addLog('Called Fluttertoast.cancel().');
      _scheduleStatusRefresh();
    } catch (error) {
      _recordError('Fluttertoast.cancel() failed', error);
    }
  }

  void _showOverlayCardToast() {
    _overlayToastCount += 1;
    _fToast.showToast(
      child: _ToastCard(
        color: const Color(0xFF1D4ED8),
        icon: Icons.notifications_active_outlined,
        title: 'Overlay Toast',
        message:
            'FToast queued toast #$_overlayToastCount using a custom card.',
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
      fadeDuration: const Duration(milliseconds: 250),
    );

    setState(() {
      _status = 'Queued a custom FToast overlay card at the bottom.';
    });
    _addLog('Queued a custom FToast card toast.');
    _scheduleStatusRefresh();
  }

  void _showDismissibleToast() {
    _overlayToastCount += 1;
    _fToast.showToast(
      child: _ToastCard(
        color: const Color(0xFF7C3AED),
        icon: Icons.touch_app_outlined,
        title: 'Dismissible Toast',
        message: 'Tap this toast to dismiss it before the timeout finishes.',
      ),
      gravity: ToastGravity.TOP,
      isDismissible: true,
      toastDuration: const Duration(seconds: 4),
      fadeDuration: const Duration(milliseconds: 300),
    );

    setState(() {
      _status = 'Queued a dismissible FToast toast at the top.';
    });
    _addLog('Queued a dismissible FToast toast.');
    _scheduleStatusRefresh();
  }

  void _showSnackbarToast() {
    _overlayToastCount += 1;
    _fToast.showToast(
      child: _SnackbarLikeToast(
        message: 'SNACKBAR gravity keeps the toast docked to the bottom edge.',
      ),
      gravity: ToastGravity.SNACKBAR,
      toastDuration: const Duration(seconds: 3),
      fadeDuration: const Duration(milliseconds: 220),
      ignorePointer: true,
    );

    setState(() {
      _status = 'Queued an FToast toast with ToastGravity.SNACKBAR.';
    });
    _addLog('Queued a snackbar-style FToast toast.');
    _scheduleStatusRefresh();
  }

  void _showPositionedToast() {
    _overlayToastCount += 1;
    _fToast.showToast(
      child: _ToastCard(
        color: const Color(0xFFEA580C),
        icon: Icons.place_outlined,
        title: 'Positioned Builder',
        message: 'This toast uses positionedToastBuilder for exact placement.',
      ),
      positionedToastBuilder:
          (BuildContext context, Widget child, ToastGravity? gravity) {
            return Positioned(top: 24, right: 24, child: child);
          },
      toastDuration: const Duration(seconds: 3),
      fadeDuration: const Duration(milliseconds: 250),
    );

    setState(() {
      _status = 'Queued an FToast toast via positionedToastBuilder.';
    });
    _addLog('Queued a positioned FToast toast.');
    _scheduleStatusRefresh();
  }

  void _queueThreeToasts() {
    const List<Color> colors = <Color>[
      Color(0xFF111827),
      Color(0xFF0F766E),
      Color(0xFFB45309),
    ];
    const List<String> titles = <String>[
      'Queue Step 1',
      'Queue Step 2',
      'Queue Step 3',
    ];

    for (int index = 0; index < 3; index += 1) {
      _overlayToastCount += 1;
      _fToast.showToast(
        child: _ToastCard(
          color: colors[index],
          icon: Icons.layers_outlined,
          title: titles[index],
          message:
              'FToast maintains a queue, so these toasts appear one after another.',
        ),
        gravity: ToastGravity.BOTTOM_RIGHT,
        toastDuration: const Duration(seconds: 2),
        fadeDuration: const Duration(milliseconds: 250),
      );
    }

    setState(() {
      _status =
          'Queued three FToast overlays to demonstrate the built-in queue.';
    });
    _addLog('Queued three FToast overlays.');
    _scheduleStatusRefresh();
  }

  void _removeCurrentOverlayToast() {
    _fToast.removeCustomToast();
    setState(() {
      _status = 'Called FToast.removeCustomToast().';
    });
    _addLog('Removed the current custom overlay toast.');
    _scheduleStatusRefresh();
  }

  void _removeQueuedOverlayToasts() {
    _fToast.removeQueuedCustomToasts();
    setState(() {
      _status = 'Called FToast.removeQueuedCustomToasts().';
    });
    _addLog('Cleared the custom overlay toast queue.');
    _scheduleStatusRefresh();
  }

  void _scheduleStatusRefresh() {
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) {
          return;
        }

        setState(() {});
      }),
    );
  }

  void _recordError(String prefix, Object error) {
    if (!mounted) {
      return;
    }

    setState(() {
      _status = '$prefix: $error';
    });
    _addLog('$prefix: $error');
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
      appBar: AppBar(title: const Text('fluttertoast Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Show native toasts with `Fluttertoast.showToast(...)` or build fully custom overlay toasts with `FToast`.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates multiple `fluttertoast` entry points: '
              '`Fluttertoast.showToast`, `Fluttertoast.cancel`, '
              '`Fluttertoast.isCurrentlyShowingToast`, `FToast.init`, '
              '`FToast.showToast`, `positionedToastBuilder`, '
              '`ToastGravity`, `toastDuration`, `fadeDuration`, '
              '`isDismissible`, `ignorePointer`, `removeCustomToast`, and '
              '`removeQueuedCustomToasts`.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Runtime Status',
              subtitle:
                  'The plugin has two modes: native platform toasts and Dart-side overlay toasts.',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  _StatusChip(label: 'Platform', value: _platformLabel),
                  _StatusChip(
                    label: 'Native Toast API',
                    value: _supportsNativeToast ? 'Supported' : 'Unsupported',
                  ),
                  _StatusChip(
                    label: 'isCurrentlyShowingToast',
                    value: Fluttertoast.isCurrentlyShowingToast
                        ? 'true'
                        : 'false',
                  ),
                  _StatusChip(
                    label: 'Native Count',
                    value: '$_nativeToastCount',
                  ),
                  _StatusChip(
                    label: 'Overlay Count',
                    value: '$_overlayToastCount',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Status Message',
              subtitle:
                  'This updates after each demo action so you can see what was requested.',
              child: Text(_status),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Native Fluttertoast API',
              subtitle:
                  'These buttons call the plugin method channel. They are available on Android, iOS, and web.',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _supportsNativeToast
                        ? () => unawaited(_showNativeBasicToast())
                        : null,
                    icon: const Icon(Icons.message_outlined),
                    label: const Text('Basic Toast'),
                  ),
                  FilledButton.icon(
                    onPressed: _supportsNativeToast
                        ? () => unawaited(_showNativeStyledToast())
                        : null,
                    icon: const Icon(Icons.vertical_align_top),
                    label: const Text('Styled Top Toast'),
                  ),
                  FilledButton.icon(
                    onPressed: _supportsNativeToast
                        ? () => unawaited(_showWebConfiguredToast())
                        : null,
                    icon: const Icon(Icons.language),
                    label: const Text('Web Config Toast'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _supportsNativeToast
                        ? () => unawaited(_cancelNativeToast())
                        : null,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancel Native Toast'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Custom FToast Overlay API',
              subtitle:
                  'These demos stay in Dart and work by inserting overlay entries with custom widgets.',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  FilledButton(
                    onPressed: _showOverlayCardToast,
                    child: const Text('Overlay Card'),
                  ),
                  FilledButton(
                    onPressed: _showDismissibleToast,
                    child: const Text('Dismissible Top Toast'),
                  ),
                  FilledButton(
                    onPressed: _showSnackbarToast,
                    child: const Text('Snackbar Gravity'),
                  ),
                  FilledButton(
                    onPressed: _showPositionedToast,
                    child: const Text('Positioned Builder'),
                  ),
                  FilledButton(
                    onPressed: _queueThreeToasts,
                    child: const Text('Queue 3 Toasts'),
                  ),
                  OutlinedButton(
                    onPressed: _removeCurrentOverlayToast,
                    child: const Text('Remove Current'),
                  ),
                  OutlinedButton(
                    onPressed: _removeQueuedOverlayToasts,
                    child: const Text('Clear Queue'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: 'Native API Example',
              code: r'''
await Fluttertoast.showToast(
  msg: 'Saved changes',
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.TOP,
  timeInSecForIosWeb: 3,
  backgroundColor: Color(0xFF0F766E),
  textColor: Colors.white,
  webShowClose: true,
  webBgColor: 'linear-gradient(to right, #0f766e, #14b8a6)',
);

await Fluttertoast.cancel();
final showing = Fluttertoast.isCurrentlyShowingToast;
''',
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: 'FToast Overlay Example',
              code: r'''
final fToast = FToast()..init(context);

fToast.showToast(
  child: MyToastCard(),
  gravity: ToastGravity.BOTTOM_RIGHT,
  toastDuration: Duration(seconds: 2),
  fadeDuration: Duration(milliseconds: 250),
  isDismissible: true,
);

fToast.showToast(
  child: MyToastCard(),
  positionedToastBuilder: (context, child, gravity) {
    return Positioned(top: 24, right: 24, child: child);
  },
);

fToast.removeCustomToast();
fToast.removeQueuedCustomToasts();
''',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Event Log',
              subtitle:
                  'Each action records what path was taken so you can see when native calls are skipped versus queued.',
              child: Column(
                children: _eventLog.isEmpty
                    ? const <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('No toast events yet.'),
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

class _ToastCard extends StatelessWidget {
  const _ToastCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.message,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(color: Color(0xFFE5E7EB), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SnackbarLikeToast extends StatelessWidget {
  const _SnackbarLikeToast({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.info_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
