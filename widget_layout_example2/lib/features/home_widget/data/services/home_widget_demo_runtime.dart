import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:widget_layout_example2/features/home_widget/domain/entities/installed_home_widget.dart';

HomeWidgetDemoRuntime? _homeWidgetDemoRuntimeInstance;

class HomeWidgetRuntimeState {
  const HomeWidgetRuntimeState({
    required this.isConfigured,
    required this.isPinSupported,
    required this.title,
    required this.message,
    required this.widgetLaunchSummary,
    required this.statusMessage,
    required this.renderedImagePath,
    required this.installedWidgets,
    required this.logEntries,
  });

  final bool isConfigured;
  final bool isPinSupported;
  final String title;
  final String message;
  final String widgetLaunchSummary;
  final String statusMessage;
  final String? renderedImagePath;
  final List<InstalledHomeWidget> installedWidgets;
  final List<String> logEntries;
}

class HomeWidgetDemoRuntime {
  HomeWidgetDemoRuntime() {
    _homeWidgetDemoRuntimeInstance = this;
  }

  static const String androidWidgetProviderName =
      'WidgetLayoutExampleHomeWidgetProvider';
  static const String androidQualifiedWidgetProviderName =
      'com.example.widget_layout_example2.WidgetLayoutExampleHomeWidgetProvider';
  static const String iOSWidgetName = 'WidgetLayoutExampleHomeWidget';

  final StreamController<HomeWidgetRuntimeState> _controller =
      StreamController<HomeWidgetRuntimeState>.broadcast();

  bool _initialized = false;
  bool _isPinSupported = false;
  String _title = 'Widget Layout Example';
  String _message = 'Update me from Flutter.';
  String _widgetLaunchSummary = 'No widget click detected yet.';
  String _statusMessage = 'Plugin has not been configured yet.';
  String? _renderedImagePath;
  List<InstalledHomeWidget> _installedWidgets = const <InstalledHomeWidget>[];
  List<String> _logEntries = const <String>[];

  bool get isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  String get platformLabel {
    if (kIsWeb) {
      return 'Web';
    }
    if (Platform.isAndroid) {
      return 'Android';
    }
    if (Platform.isIOS) {
      return 'iOS';
    }
    if (Platform.isMacOS) {
      return 'macOS';
    }
    if (Platform.isWindows) {
      return 'Windows';
    }
    if (Platform.isLinux) {
      return 'Linux';
    }
    return 'Unknown';
  }

  Stream<HomeWidgetRuntimeState> watchState() => _controller.stream;

  Future<void> initialize() async {
    if (!isSupported) {
      return;
    }

    if (_initialized) {
      _emitStatus(
        'home_widget was already configured. Use the buttons below to push and inspect widget data.',
      );
      return;
    }

    HomeWidget.registerInteractivityCallback(homeWidgetInteractivityCallback);
    HomeWidget.widgetClicked.listen(_handleWidgetUri);
    final Uri? launchUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
    _handleWidgetUri(launchUri);
    _isPinSupported = await HomeWidget.isRequestPinWidgetSupported() ?? false;
    _initialized = true;
    _statusMessage =
        'home_widget configured. Flutter can now write shared data and request widget refresh.';
    _appendLog('Initialized home_widget runtime on $platformLabel.');
    _controller.add(_snapshot());
  }

  Future<HomeWidgetRuntimeState> refresh() async {
    if (!isSupported) {
      return _snapshot();
    }
    return readPersistedData(
      statusMessage:
          'Refreshed from native widget storage and launcher capabilities.',
    );
  }

  Future<HomeWidgetRuntimeState> updateDraft({
    required String title,
    required String message,
  }) async {
    _title = title;
    _message = message;
    _statusMessage = 'Edited draft values in Flutter UI.';
    _appendLog('Edited draft title/message in Flutter.');
    final HomeWidgetRuntimeState state = _snapshot();
    _controller.add(state);
    return state;
  }

  Future<HomeWidgetRuntimeState> pushWidgetData() async {
    await _guardSupported();
    await Future.wait(<Future<dynamic>>[
      HomeWidget.saveWidgetData<String>('title', _title),
      HomeWidget.saveWidgetData<String>('message', _message),
    ]);
    await _updateWidget();
    _statusMessage =
        'Saved title/message into shared widget storage and requested widget refresh.';
    _appendLog('Pushed title/message to widget storage.');
    final HomeWidgetRuntimeState state = _snapshot();
    _controller.add(state);
    return state;
  }

  Future<HomeWidgetRuntimeState> readPersistedData({
    String? statusMessage,
  }) async {
    await _guardSupported();
    final String title =
        await HomeWidget.getWidgetData<String>('title', defaultValue: _title) ??
        _title;
    final String message =
        await HomeWidget.getWidgetData<String>(
          'message',
          defaultValue: _message,
        ) ??
        _message;
    final String? renderedImagePath = await HomeWidget.getWidgetData<String>(
      'flutterIcon',
      defaultValue: _renderedImagePath,
    );
    _title = title;
    _message = message;
    _renderedImagePath = renderedImagePath;
    _statusMessage =
        statusMessage ?? 'Loaded current values from shared widget storage.';
    _appendLog('Read title/message from widget storage.');
    final HomeWidgetRuntimeState state = _snapshot();
    _controller.add(state);
    return state;
  }

  Future<HomeWidgetRuntimeState> renderDemoImage() async {
    await _guardSupported();
    _renderedImagePath = await HomeWidget.renderFlutterWidget(
      Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF0E7490), Color(0xFF22C55E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.all(20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.widgets_rounded, size: 44, color: Colors.white),
            Text(
              'Flutter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      key: 'flutterIcon',
      logicalSize: const Size(180, 180),
    );
    await _updateWidget();
    _statusMessage =
        'Rendered a Flutter widget into a PNG file and asked the native widget to display it.';
    _appendLog('Rendered Flutter widget image for home widget.');
    final HomeWidgetRuntimeState state = _snapshot();
    _controller.add(state);
    return state;
  }

  Future<HomeWidgetRuntimeState> requestPinWidget() async {
    await _guardSupported();
    if (!Platform.isAndroid) {
      _statusMessage =
          'Pinning is Android launcher specific. iOS users add widgets from the widget gallery.';
      _appendLog('Pin widget requested on iOS; no-op.');
      final HomeWidgetRuntimeState state = _snapshot();
      _controller.add(state);
      return state;
    }
    await HomeWidget.requestPinWidget(
      qualifiedAndroidName: androidQualifiedWidgetProviderName,
    );
    _statusMessage =
        'Requested launcher to pin the Android home widget, if supported by the current launcher.';
    _appendLog('Requested Android launcher pin widget flow.');
    final HomeWidgetRuntimeState state = _snapshot();
    _controller.add(state);
    return state;
  }

  Future<HomeWidgetRuntimeState> loadInstalledWidgets() async {
    await _guardSupported();
    final List<HomeWidgetInfo> info = await HomeWidget.getInstalledWidgets();
    _installedWidgets = info
        .map(
          (HomeWidgetInfo widget) => InstalledHomeWidget(
            iOSFamily: widget.iOSFamily,
            iOSKind: widget.iOSKind,
            androidWidgetId: widget.androidWidgetId,
            androidClassName: widget.androidClassName,
            androidLabel: widget.androidLabel,
          ),
        )
        .toList();
    _statusMessage =
        'Loaded currently installed home widgets from the platform.';
    _appendLog('Loaded installed widget metadata.');
    final HomeWidgetRuntimeState state = _snapshot();
    _controller.add(state);
    return state;
  }

  Future<void> _updateWidget() async {
    await Future.wait(<Future<dynamic>>[
      HomeWidget.updateWidget(
        name: androidWidgetProviderName,
        iOSName: iOSWidgetName,
      ),
      if (Platform.isAndroid)
        HomeWidget.updateWidget(
          qualifiedAndroidName: androidQualifiedWidgetProviderName,
        ),
    ]);
  }

  void _handleWidgetUri(Uri? uri) {
    if (uri == null) {
      return;
    }
    _widgetLaunchSummary = uri.toString();
    _statusMessage = 'Flutter received a widget click callback: $uri';
    _appendLog('Received widget click URI: $uri');
    _controller.add(_snapshot());
  }

  void _emitStatus(String message) {
    _statusMessage = message;
    _appendLog(message);
    _controller.add(_snapshot());
  }

  void _appendLog(String entry) {
    final DateTime now = DateTime.now();
    _logEntries = <String>[
      '${now.toIso8601String()}  $entry',
      ..._logEntries,
    ].take(20).toList();
  }

  HomeWidgetRuntimeState _snapshot() {
    return HomeWidgetRuntimeState(
      isConfigured: _initialized,
      isPinSupported: _isPinSupported,
      title: _title,
      message: _message,
      widgetLaunchSummary: _widgetLaunchSummary,
      statusMessage: _statusMessage,
      renderedImagePath: _renderedImagePath,
      installedWidgets: _installedWidgets,
      logEntries: _logEntries,
    );
  }

  Future<void> _guardSupported() async {
    if (!isSupported) {
      throw UnsupportedError(
        'home_widget is only supported on Android and iOS.',
      );
    }
    if (!_initialized) {
      await initialize();
    }
  }
}

@pragma('vm:entry-point')
Future<void> homeWidgetInteractivityCallback(Uri? uri) async {
  final HomeWidgetDemoRuntime? runtime = _homeWidgetDemoRuntimeInstance;
  if (uri == null || runtime == null) {
    return;
  }

  runtime._handleWidgetUri(uri);
  if (uri.host == 'messageClicked') {
    runtime._message = 'Clicked from widget at ${DateTime.now().toLocal()}';
    await Future.wait(<Future<dynamic>>[
      HomeWidget.saveWidgetData<String>('message', runtime._message),
      HomeWidget.updateWidget(
        name: HomeWidgetDemoRuntime.androidWidgetProviderName,
        iOSName: HomeWidgetDemoRuntime.iOSWidgetName,
      ),
    ]);
    if (Platform.isAndroid) {
      await HomeWidget.updateWidget(
        qualifiedAndroidName:
            HomeWidgetDemoRuntime.androidQualifiedWidgetProviderName,
      );
    }
    runtime._statusMessage =
        'Widget background callback updated the shared message value.';
    runtime._appendLog('Background interactivity callback updated message.');
    runtime._controller.add(runtime._snapshot());
  }
}
