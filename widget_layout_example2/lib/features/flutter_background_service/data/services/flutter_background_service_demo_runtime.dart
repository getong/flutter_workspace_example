import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _serviceStateEvent = 'background_service_demo.state';
const String _stopServiceCommand = 'background_service_demo.stop_service';
const String _setForegroundCommand =
    'background_service_demo.set_as_foreground';
const String _setBackgroundCommand =
    'background_service_demo.set_as_background';

const String _channelId = 'background_service_demo_channel';
const String _channelName = 'Background Service Demo';
const String _channelDescription =
    'Foreground notification channel for flutter_background_service demo.';
const int _foregroundNotificationId = 9701;

const String _tickCountKey = 'background_service_demo.tick_count';
const String _lastTickAtKey = 'background_service_demo.last_tick_at';
const String _isForegroundModeKey = 'background_service_demo.is_foreground';
const String _lastMessageKey = 'background_service_demo.last_message';
const String _permissionSummaryKey = 'background_service_demo.permission';
const String _logEntriesKey = 'background_service_demo.logs';

class BackgroundServiceRuntimeState {
  const BackgroundServiceRuntimeState({
    required this.isRunning,
    required this.isForegroundMode,
    required this.tickCount,
    required this.lastTickAt,
    required this.permissionSummary,
    required this.lastMessage,
    required this.logEntries,
  });

  final bool isRunning;
  final bool isForegroundMode;
  final int tickCount;
  final DateTime? lastTickAt;
  final String permissionSummary;
  final String lastMessage;
  final List<String> logEntries;
}

class BackgroundServiceDemoRuntime {
  BackgroundServiceDemoRuntime({
    FlutterBackgroundService? service,
    FlutterLocalNotificationsPlugin? notificationsPlugin,
  }) : _service = service ?? FlutterBackgroundService(),
       _notificationsPlugin =
           notificationsPlugin ?? FlutterLocalNotificationsPlugin();

  final FlutterBackgroundService _service;
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  final StreamController<BackgroundServiceRuntimeState> _controller =
      StreamController<BackgroundServiceRuntimeState>.broadcast();

  StreamSubscription<Map<String, dynamic>?>? _serviceSubscription;
  bool _initialized = false;

  bool get isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  bool get isInitialized => _initialized;

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

  Stream<BackgroundServiceRuntimeState> watchState() => _controller.stream;

  Future<void> initialize() async {
    if (!isSupported) {
      return;
    }

    if (_initialized) {
      await refreshState(
        statusMessage:
            'Service was already configured in app bootstrap. Ready to use.',
      );
      return;
    }

    await _notificationsPlugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.low,
        ),
      );
    }

    _serviceSubscription ??= _service.on(_serviceStateEvent).listen((
      Map<String, dynamic>? _,
    ) {
      unawaited(refreshState());
    });

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: backgroundServiceDemoOnStart,
        autoStart: false,
        autoStartOnBoot: false,
        isForegroundMode: true,
        notificationChannelId: _channelId,
        initialNotificationTitle: 'flutter_background_service Demo',
        initialNotificationContent: 'Waiting for the first background task.',
        foregroundServiceNotificationId: _foregroundNotificationId,
        foregroundServiceTypes: <AndroidForegroundType>[
          AndroidForegroundType.dataSync,
        ],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: backgroundServiceDemoOnStart,
        onBackground: backgroundServiceDemoOnIosBackground,
      ),
    );

    _initialized = true;
    await _persistPermissionSummary(await _buildPermissionSummary());
    await refreshState(
      statusMessage:
          'Service configured. Tap Start Service to spawn a dedicated isolate.',
    );
  }

  Future<BackgroundServiceRuntimeState> refreshState({
    String? statusMessage,
  }) async {
    final BackgroundServiceRuntimeState state = await readPersistedState(
      statusMessage: statusMessage,
    );
    _controller.add(state);
    return state;
  }

  Future<BackgroundServiceRuntimeState> readPersistedState({
    String? statusMessage,
  }) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();

    final String? lastTickAtRaw = preferences.getString(_lastTickAtKey);
    final bool isRunning = isSupported && _initialized
        ? await _service.isRunning()
        : false;

    return BackgroundServiceRuntimeState(
      isRunning: isRunning,
      isForegroundMode: preferences.getBool(_isForegroundModeKey) ?? false,
      tickCount: preferences.getInt(_tickCountKey) ?? 0,
      lastTickAt: lastTickAtRaw == null
          ? null
          : DateTime.tryParse(lastTickAtRaw),
      permissionSummary:
          preferences.getString(_permissionSummaryKey) ??
          await _buildPermissionSummary(),
      lastMessage:
          statusMessage ??
          preferences.getString(_lastMessageKey) ??
          'No background events received yet.',
      logEntries: preferences.getStringList(_logEntriesKey) ?? const <String>[],
    );
  }

  Future<BackgroundServiceRuntimeState> requestNotificationPermission() async {
    if (!isSupported) {
      return refreshState(
        statusMessage:
            'Notification permission is only relevant on Android and iOS.',
      );
    }

    final String summary;
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      final bool? granted = await androidPlugin
          ?.requestNotificationsPermission();
      summary = 'Android notification permission: ${granted ?? 'unknown'}.';
    } else {
      final IOSFlutterLocalNotificationsPlugin? iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final bool? granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: false,
      );
      summary = 'iOS notification permission: ${granted ?? 'unknown'}.';
    }

    await _persistPermissionSummary(summary);
    return refreshState(statusMessage: summary);
  }

  Future<BackgroundServiceRuntimeState> startService() async {
    if (!isSupported) {
      return refreshState(
        statusMessage: 'This platform cannot start flutter_background_service.',
      );
    }
    await initialize();
    final bool started = await _service.startService();
    await _pushUiLog('UI isolate requested service start.');
    return refreshState(
      statusMessage: started
          ? 'startService() returned true. Wait for the first heartbeat.'
          : 'startService() returned false.',
    );
  }

  Future<BackgroundServiceRuntimeState> stopService() async {
    if (!isSupported) {
      return refreshState(
        statusMessage: 'This platform cannot stop flutter_background_service.',
      );
    }
    _service.invoke(_stopServiceCommand);
    await _pushUiLog('UI isolate requested service stop.');
    return refreshState(
      statusMessage: 'Stop command sent to the background isolate.',
    );
  }

  Future<BackgroundServiceRuntimeState> setForegroundMode() async {
    if (!isSupported || !Platform.isAndroid) {
      return refreshState(
        statusMessage:
            'Foreground/background mode switching is only meaningful on Android.',
      );
    }
    _service.invoke(_setForegroundCommand);
    await _pushUiLog('UI isolate requested foreground mode.');
    return refreshState(
      statusMessage: 'Foreground mode command sent to the service.',
    );
  }

  Future<BackgroundServiceRuntimeState> setBackgroundMode() async {
    if (!isSupported || !Platform.isAndroid) {
      return refreshState(
        statusMessage:
            'Foreground/background mode switching is only meaningful on Android.',
      );
    }
    _service.invoke(_setBackgroundCommand);
    await _pushUiLog('UI isolate requested background mode.');
    return refreshState(
      statusMessage:
          'Background mode command sent. Android may kill it in debug mode.',
    );
  }

  Future<BackgroundServiceRuntimeState> clearDemoData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String permissionSummary =
        preferences.getString(_permissionSummaryKey) ??
        await _buildPermissionSummary();
    await preferences.remove(_tickCountKey);
    await preferences.remove(_lastTickAtKey);
    await preferences.remove(_isForegroundModeKey);
    await preferences.remove(_lastMessageKey);
    await preferences.remove(_logEntriesKey);
    await preferences.setString(_permissionSummaryKey, permissionSummary);
    return refreshState(statusMessage: 'Stored heartbeat data has been reset.');
  }

  Future<String> _buildPermissionSummary() async {
    if (!isSupported) {
      return 'Notifications are not used on this platform in the demo.';
    }

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      final bool? enabled = await androidPlugin?.areNotificationsEnabled();
      return 'Android notifications enabled: ${enabled ?? 'unknown'}.';
    }

    final IOSFlutterLocalNotificationsPlugin? iosPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final NotificationsEnabledOptions? options = await iosPlugin
        ?.checkPermissions();
    return 'iOS permissions - alert: ${options?.isAlertEnabled ?? false}, '
        'badge: ${options?.isBadgeEnabled ?? false}, sound: ${options?.isSoundEnabled ?? false}.';
  }

  Future<void> _pushUiLog(String message) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final List<String> currentEntries =
        preferences.getStringList(_logEntriesKey) ?? const <String>[];
    final DateTime now = DateTime.now();
    final List<String> nextEntries = <String>[
      '${now.toIso8601String()}  $message',
      ...currentEntries,
    ].take(20).toList();
    await preferences.setStringList(_logEntriesKey, nextEntries);
    await preferences.setString(_lastMessageKey, message);
  }

  Future<void> _persistPermissionSummary(String summary) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(_permissionSummaryKey, summary);
  }
}

/// Entry point used by Android foreground service and iOS foreground callback.
///
/// The function must stay top-level so the plugin can look it up by callback
/// handle when it spins up a dedicated background isolate.
@pragma('vm:entry-point')
void backgroundServiceDemoOnStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  Timer? timer;

  Future<void> syncState({
    required String message,
    required bool incrementTick,
    bool? isForegroundMode,
  }) async {
    final _PersistedBackgroundUpdate update = await _persistBackgroundUpdate(
      message: message,
      incrementTick: incrementTick,
      isForegroundMode: isForegroundMode,
    );
    service.invoke(_serviceStateEvent, <String, dynamic>{
      'tickCount': update.tickCount,
      'lastTickAt': update.lastTickAt.toIso8601String(),
      'isForegroundMode': update.isForegroundMode,
      'message': update.lastMessage,
    });
  }

  if (service is AndroidServiceInstance) {
    final bool initialForegroundMode = await service.isForegroundService();
    await syncState(
      message: 'Background isolate started on Android.',
      incrementTick: false,
      isForegroundMode: initialForegroundMode,
    );

    service.on(_setForegroundCommand).listen((_) async {
      await service.setAsForegroundService();
      await service.setForegroundNotificationInfo(
        title: 'flutter_background_service Demo',
        content: 'Foreground mode enabled from the demo page.',
      );
      await syncState(
        message: 'Service switched to foreground mode.',
        incrementTick: false,
        isForegroundMode: true,
      );
    });

    service.on(_setBackgroundCommand).listen((_) async {
      await service.setAsBackgroundService();
      await syncState(
        message: 'Service switched to background mode.',
        incrementTick: false,
        isForegroundMode: false,
      );
    });
  } else {
    await syncState(
      message: 'Foreground callback started on iOS.',
      incrementTick: false,
      isForegroundMode: false,
    );
  }

  service.on(_stopServiceCommand).listen((_) async {
    timer?.cancel();
    await syncState(
      message: 'Background isolate stopped by the UI isolate.',
      incrementTick: false,
      isForegroundMode: false,
    );
    await service.stopSelf();
  });

  timer = Timer.periodic(const Duration(seconds: 5), (Timer activeTimer) async {
    bool isForegroundMode = false;
    if (service is AndroidServiceInstance) {
      isForegroundMode = await service.isForegroundService();
      if (isForegroundMode) {
        await service.setForegroundNotificationInfo(
          title: 'flutter_background_service Demo',
          content: 'Heartbeat ${DateTime.now().toLocal()}',
        );
      }
    }

    await syncState(
      message: 'Heartbeat emitted from the background isolate.',
      incrementTick: true,
      isForegroundMode: isForegroundMode,
    );
  });
}

/// iOS cannot keep a Dart isolate alive like Android foreground services.
///
/// Instead, this callback runs during background fetch and records a single
/// heartbeat so the demo can show the different execution model.
@pragma('vm:entry-point')
Future<bool> backgroundServiceDemoOnIosBackground(
  ServiceInstance service,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final _PersistedBackgroundUpdate update = await _persistBackgroundUpdate(
    message: 'iOS background fetch delivered a single heartbeat.',
    incrementTick: true,
    isForegroundMode: false,
  );

  service.invoke(_serviceStateEvent, <String, dynamic>{
    'tickCount': update.tickCount,
    'lastTickAt': update.lastTickAt.toIso8601String(),
    'isForegroundMode': update.isForegroundMode,
    'message': update.lastMessage,
  });

  return true;
}

class _PersistedBackgroundUpdate {
  const _PersistedBackgroundUpdate({
    required this.tickCount,
    required this.lastTickAt,
    required this.isForegroundMode,
    required this.lastMessage,
  });

  final int tickCount;
  final DateTime lastTickAt;
  final bool isForegroundMode;
  final String lastMessage;
}

Future<_PersistedBackgroundUpdate> _persistBackgroundUpdate({
  required String message,
  required bool incrementTick,
  bool? isForegroundMode,
}) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();

  final int previousTickCount = preferences.getInt(_tickCountKey) ?? 0;
  final int nextTickCount = incrementTick
      ? previousTickCount + 1
      : previousTickCount;
  final bool nextForegroundMode =
      isForegroundMode ?? preferences.getBool(_isForegroundModeKey) ?? false;
  final DateTime now = DateTime.now();

  final List<String> currentEntries =
      preferences.getStringList(_logEntriesKey) ?? const <String>[];
  final List<String> nextEntries = <String>[
    '${now.toIso8601String()}  $message',
    ...currentEntries,
  ].take(20).toList();

  await preferences.setInt(_tickCountKey, nextTickCount);
  await preferences.setString(_lastTickAtKey, now.toIso8601String());
  await preferences.setBool(_isForegroundModeKey, nextForegroundMode);
  await preferences.setString(_lastMessageKey, message);
  await preferences.setStringList(_logEntriesKey, nextEntries);

  return _PersistedBackgroundUpdate(
    tickCount: nextTickCount,
    lastTickAt: now,
    isForegroundMode: nextForegroundMode,
    lastMessage: message,
  );
}
