import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String _demoChannelId = 'demo_updates_channel';
const String _demoChannelName = 'Demo Updates';
const String _demoChannelGroupId = 'demo_group';
const String _demoChannelGroupName = 'Demo Notifications';
const String _notificationIcon = '@mipmap/ic_launcher';

@RoutePage()
class FlutterLocalNotificationsPage extends StatefulWidget {
  const FlutterLocalNotificationsPage({super.key});

  @override
  State<FlutterLocalNotificationsPage> createState() =>
      _FlutterLocalNotificationsPageState();
}

class _FlutterLocalNotificationsPageState
    extends State<FlutterLocalNotificationsPage> {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  int _nextId = 1000;
  bool _initialized = false;
  String _status = 'Plugin not initialized yet.';
  String _permissionsSummary = 'Permissions have not been checked yet.';
  String _launchSummary = 'Launch details have not been queried yet.';
  String _pendingSummary = 'Pending notifications have not been queried yet.';
  String _activeSummary = 'Active notifications have not been queried yet.';
  String _selectedPayload = 'No notification response received yet.';
  List<String> _eventLog = <String>[];

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;
  bool get _isDarwin =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  InitializationSettings get _initializationSettings =>
      const InitializationSettings(
        android: AndroidInitializationSettings(_notificationIcon),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
          defaultPresentBanner: true,
          defaultPresentList: true,
        ),
        macOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
          defaultPresentBanner: true,
          defaultPresentList: true,
        ),
        linux: LinuxInitializationSettings(
          defaultActionName: 'Open notification',
        ),
        windows: WindowsInitializationSettings(
          appName: 'Widget Layout Example2',
          appUserModelId: 'com.example.widgetlayout.example2.notifications',
          guid: '43f7d733-ec57-4a20-8fb2-a4f3f00aa501',
        ),
      );

  NotificationDetails get _basicDetails => const NotificationDetails(
    android: AndroidNotificationDetails(
      _demoChannelId,
      _demoChannelName,
      channelDescription: 'General local notification examples for this app.',
      importance: Importance.high,
      priority: Priority.high,
      icon: _notificationIcon,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      presentBanner: true,
      presentList: true,
      subtitle: 'Immediate notification',
      threadIdentifier: 'demo-immediate',
    ),
    macOS: DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      presentBanner: true,
      presentList: true,
      subtitle: 'Immediate notification',
      threadIdentifier: 'demo-immediate',
    ),
    linux: LinuxNotificationDetails(
      defaultActionName: 'Open notification',
      urgency: LinuxNotificationUrgency.normal,
    ),
    windows: WindowsNotificationDetails(
      duration: WindowsNotificationDuration.short,
      subtitle: 'Immediate notification',
    ),
  );

  NotificationDetails get _bigTextDetails => const NotificationDetails(
    android: AndroidNotificationDetails(
      _demoChannelId,
      _demoChannelName,
      channelDescription: 'General local notification examples for this app.',
      importance: Importance.high,
      priority: Priority.high,
      icon: _notificationIcon,
      styleInformation: BigTextStyleInformation(
        'This notification uses BigTextStyleInformation so longer content can expand beyond a single collapsed line. It is useful for reminders, summaries, and preview-heavy alerts.',
        contentTitle: 'Expanded content preview',
        summaryText: 'Big text style',
      ),
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      presentBanner: true,
      presentList: true,
      subtitle: 'Expanded content preview',
      threadIdentifier: 'demo-big-text',
    ),
    macOS: DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      presentBanner: true,
      presentList: true,
      subtitle: 'Expanded content preview',
      threadIdentifier: 'demo-big-text',
    ),
    linux: LinuxNotificationDetails(
      defaultActionName: 'Open notification',
      urgency: LinuxNotificationUrgency.critical,
    ),
    windows: WindowsNotificationDetails(
      duration: WindowsNotificationDuration.long,
      subtitle: 'Expanded content preview',
    ),
  );

  NotificationDetails get _inboxDetails => const NotificationDetails(
    android: AndroidNotificationDetails(
      _demoChannelId,
      _demoChannelName,
      channelDescription: 'General local notification examples for this app.',
      importance: Importance.high,
      priority: Priority.high,
      icon: _notificationIcon,
      styleInformation: InboxStyleInformation(
        <String>[
          'Build completed successfully',
          'UI review scheduled for 3 PM',
          'Staging smoke test still pending',
        ],
        contentTitle: '3 new project updates',
        summaryText: 'Inbox style example',
      ),
      groupKey: 'project-updates',
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      presentBanner: true,
      presentList: true,
      subtitle: '3 new project updates',
      threadIdentifier: 'project-updates',
    ),
    macOS: DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      presentBanner: true,
      presentList: true,
      subtitle: '3 new project updates',
      threadIdentifier: 'project-updates',
    ),
    linux: LinuxNotificationDetails(
      defaultActionName: 'Open updates',
      urgency: LinuxNotificationUrgency.low,
    ),
    windows: WindowsNotificationDetails(
      subtitle: '3 new project updates',
      duration: WindowsNotificationDuration.short,
    ),
  );

  @override
  void initState() {
    super.initState();
    _initializePlugin();
  }

  void _log(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    if (!mounted) {
      return;
    }
    setState(() {
      _eventLog = <String>[
        '$timestamp  $message',
        ..._eventLog,
      ].take(12).toList();
    });
  }

  void _setStatus(String value) {
    if (!mounted) {
      return;
    }
    setState(() {
      _status = value;
    });
  }

  Future<void> _runGuarded({
    required String label,
    required Future<void> Function() action,
  }) async {
    try {
      await action();
      _log(label);
    } on PlatformException catch (error) {
      _setStatus(
        'PlatformException(${error.code}): ${error.message ?? 'No message'}',
      );
      _log('$label failed with ${error.code}');
    } on UnimplementedError catch (error) {
      _setStatus('UnimplementedError: $error');
      _log('$label unimplemented');
    } on UnsupportedError catch (error) {
      _setStatus('UnsupportedError: $error');
      _log('$label unsupported');
    } catch (error) {
      _setStatus('Unexpected error: $error');
      _log('$label failed');
    }
  }

  Future<void> _initializePlugin() async {
    await _runGuarded(
      label: 'initialize()',
      action: () async {
        final bool? initialized = await _plugin.initialize(
          settings: _initializationSettings,
          onDidReceiveNotificationResponse: (NotificationResponse response) {
            if (!mounted) {
              return;
            }
            setState(() {
              _selectedPayload =
                  'id=${response.id}, action=${response.actionId ?? 'tap'}, payload=${response.payload ?? '-'}';
            });
            _log('Notification response received for id=${response.id}');
          },
        );
        if (!mounted) {
          return;
        }
        setState(() {
          _initialized = initialized ?? true;
          _status =
              'Plugin initialized on ${defaultTargetPlatform.name}. Notifications can now be requested or shown from this page.';
        });
      },
    );
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      await _ensureDarwinPermission(
        requestIfNeeded: true,
        updateStatusWhenGranted: false,
      );
    }
    await _refreshLaunchDetails();
  }

  String _darwinPermissionSummary(NotificationsEnabledOptions? options) {
    return 'Darwin enabled=${options?.isEnabled ?? false}, alert=${options?.isAlertEnabled ?? false}, badge=${options?.isBadgeEnabled ?? false}, sound=${options?.isSoundEnabled ?? false}.';
  }

  Future<NotificationsEnabledOptions?> _checkDarwinPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.checkPermissions();
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.checkPermissions();
    }
    return null;
  }

  Future<bool?> _requestDarwinPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
    return null;
  }

  Future<bool> _ensureDarwinPermission({
    required bool requestIfNeeded,
    bool updateStatusWhenGranted = true,
  }) async {
    if (!_isDarwin) {
      return true;
    }

    final NotificationsEnabledOptions? currentOptions =
        await _checkDarwinPermissions();
    final bool alreadyEnabled = currentOptions?.isEnabled ?? false;
    final String currentSummary = _darwinPermissionSummary(currentOptions);

    if (mounted) {
      setState(() {
        _permissionsSummary = currentSummary;
        if (alreadyEnabled && updateStatusWhenGranted) {
          _status = currentSummary;
        }
      });
    }

    if (alreadyEnabled || !requestIfNeeded) {
      return alreadyEnabled;
    }

    final bool? granted = await _requestDarwinPermissions();
    final NotificationsEnabledOptions? refreshedOptions =
        await _checkDarwinPermissions();
    final bool isEnabled = refreshedOptions?.isEnabled ?? granted ?? false;
    final String summary = _darwinPermissionSummary(refreshedOptions);

    if (mounted) {
      setState(() {
        _permissionsSummary = summary;
        _status = isEnabled
            ? 'Notification permission is enabled on ${defaultTargetPlatform.name}.'
            : 'Notification permission is disabled on ${defaultTargetPlatform.name}. If you already denied it, enable this app in System Settings > Notifications.';
      });
    }

    _log(
      isEnabled
          ? 'Darwin notification permission enabled'
          : 'Darwin notification permission denied or unavailable',
    );
    return isEnabled;
  }

  Future<void> _refreshLaunchDetails() async {
    await _runGuarded(
      label: 'getNotificationAppLaunchDetails()',
      action: () async {
        final NotificationAppLaunchDetails? details = await _plugin
            .getNotificationAppLaunchDetails();
        if (!mounted) {
          return;
        }
        setState(() {
          _launchSummary =
              'didLaunch=${details?.didNotificationLaunchApp ?? false}, payload=${details?.notificationResponse?.payload ?? '-'}';
        });
      },
    );
  }

  Future<void> _requestPermissions() async {
    await _runGuarded(
      label: 'request permissions',
      action: () async {
        String summary;
        if (_isAndroid) {
          final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
          final bool? granted = await androidPlugin
              ?.requestNotificationsPermission();
          summary =
              'Android notifications permission: ${granted ?? 'not available'}.';
        } else if (_isDarwin) {
          final bool granted = await _ensureDarwinPermission(
            requestIfNeeded: true,
          );
          summary = granted
              ? 'Darwin notifications permission is enabled.'
              : 'Darwin notifications permission is disabled. Enable this app in System Settings > Notifications if needed.';
        } else {
          summary =
              'This platform does not expose an explicit permission request API through the plugin demo.';
        }

        if (!mounted) {
          return;
        }
        setState(() {
          _permissionsSummary = summary;
          _status = summary;
        });
      },
    );
  }

  Future<void> _checkPermissions() async {
    await _runGuarded(
      label: 'check permissions',
      action: () async {
        String summary;
        if (_isAndroid) {
          final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
          final bool? enabled = await androidPlugin?.areNotificationsEnabled();
          summary =
              'Android areNotificationsEnabled(): ${enabled ?? 'not available'}.';
        } else if (_isDarwin) {
          final NotificationsEnabledOptions? options =
              await _checkDarwinPermissions();
          summary = _darwinPermissionSummary(options);
        } else {
          summary =
              'Permission state inspection is platform-specific and not exposed for this target in the demo.';
        }

        if (!mounted) {
          return;
        }
        setState(() {
          _permissionsSummary = summary;
          _status = summary;
        });
      },
    );
  }

  Future<void> _createAndroidChannel() async {
    await _runGuarded(
      label: 'create Android channel',
      action: () async {
        final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        if (androidPlugin == null) {
          throw UnsupportedError(
            'Android notification channels are only available on Android.',
          );
        }
        await androidPlugin.createNotificationChannelGroup(
          const AndroidNotificationChannelGroup(
            _demoChannelGroupId,
            _demoChannelGroupName,
            description: 'Demo channel group created from the module page.',
          ),
        );
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            _demoChannelId,
            _demoChannelName,
            description: 'General local notification examples for this app.',
            groupId: _demoChannelGroupId,
            importance: Importance.high,
          ),
        );
        final List<AndroidNotificationChannel>? channels = await androidPlugin
            .getNotificationChannels();
        _setStatus(
          'Created/verified Android channel "$_demoChannelId". getNotificationChannels() returned ${channels?.length ?? 0} channels.',
        );
      },
    );
  }

  Future<void> _showBasicNotification() async {
    final int id = _nextId++;
    await _runGuarded(
      label: 'show basic notification',
      action: () async {
        if (!await _ensureDarwinPermission(requestIfNeeded: true)) {
          return;
        }
        await _plugin.show(
          id: id,
          title: 'Build finished',
          body: 'This is a basic local notification fired from the demo page.',
          notificationDetails: _basicDetails,
          payload: 'basic:$id',
        );
        _setStatus('Displayed immediate notification id=$id.');
      },
    );
  }

  Future<void> _showBigTextNotification() async {
    final int id = _nextId++;
    await _runGuarded(
      label: 'show big text notification',
      action: () async {
        if (!await _ensureDarwinPermission(requestIfNeeded: true)) {
          return;
        }
        await _plugin.show(
          id: id,
          title: 'Sprint summary ready',
          body: 'Tap to inspect the expanded content example.',
          notificationDetails: _bigTextDetails,
          payload: 'big-text:$id',
        );
        _setStatus(
          'Displayed BigTextStyle/information-rich notification id=$id.',
        );
      },
    );
  }

  Future<void> _showInboxNotification() async {
    final int id = _nextId++;
    await _runGuarded(
      label: 'show inbox notification',
      action: () async {
        if (!await _ensureDarwinPermission(requestIfNeeded: true)) {
          return;
        }
        await _plugin.show(
          id: id,
          title: 'Project updates',
          body: 'Three new updates were grouped into one example notification.',
          notificationDetails: _inboxDetails,
          payload: 'inbox:$id',
        );
        _setStatus('Displayed inbox-style/grouped notification id=$id.');
      },
    );
  }

  Future<void> _showRepeatingNotification() async {
    final int id = _nextId++;
    await _runGuarded(
      label: 'show repeating notification',
      action: () async {
        await _plugin.periodicallyShow(
          id: id,
          repeatInterval: RepeatInterval.hourly,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          title: 'Hourly stand-up reminder',
          body: 'This repeating notification was scheduled from the demo page.',
          notificationDetails: _basicDetails,
          payload: 'periodic:$id',
        );
        _setStatus(
          'Scheduled hourly repeating notification id=$id. Some platforms require extra manifest/permission setup for exact timing.',
        );
      },
    );
  }

  Future<void> _showRepeatingDurationNotification() async {
    final int id = _nextId++;
    await _runGuarded(
      label: 'show custom-duration repeating notification',
      action: () async {
        await _plugin.periodicallyShowWithDuration(
          id: id,
          repeatDurationInterval: const Duration(minutes: 15),
          title: 'Quarter-hour poll',
          body:
              'Custom repeat duration example from flutter_local_notifications.',
          notificationDetails: _basicDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'periodic-duration:$id',
        );
        _setStatus(
          'Scheduled 15-minute repeating notification id=$id. Platform capabilities vary for exact background delivery.',
        );
      },
    );
  }

  Future<void> _loadPendingNotifications() async {
    await _runGuarded(
      label: 'pendingNotificationRequests()',
      action: () async {
        final List<PendingNotificationRequest> pending = await _plugin
            .pendingNotificationRequests();
        if (!mounted) {
          return;
        }
        setState(() {
          _pendingSummary =
              'Pending notifications: ${pending.length}. ${pending.isEmpty ? '' : 'Latest id=${pending.last.id}, title=${pending.last.title ?? '-'}'}';
          _status = _pendingSummary;
        });
      },
    );
  }

  Future<void> _loadActiveNotifications() async {
    await _runGuarded(
      label: 'getActiveNotifications()',
      action: () async {
        final List<ActiveNotification> active = await _plugin
            .getActiveNotifications();
        if (!mounted) {
          return;
        }
        setState(() {
          _activeSummary =
              'Active notifications: ${active.length}. ${active.isEmpty ? '' : 'Latest id=${active.last.id}, title=${active.last.title ?? '-'}'}';
          _status = _activeSummary;
        });
      },
    );
  }

  Future<void> _cancelLastNotification() async {
    final int lastId = _nextId - 1;
    await _runGuarded(
      label: 'cancel(id)',
      action: () async {
        await _plugin.cancel(id: lastId);
        _setStatus('Requested cancellation for notification id=$lastId.');
      },
    );
  }

  Future<void> _cancelAllNotifications() async {
    await _runGuarded(
      label: 'cancelAll()',
      action: () async {
        await _plugin.cancelAll();
        _setStatus('Requested cancelAll() for active notifications.');
      },
    );
  }

  Future<void> _cancelAllPendingNotifications() async {
    await _runGuarded(
      label: 'cancelAllPendingNotifications()',
      action: () async {
        await _plugin.cancelAllPendingNotifications();
        _setStatus('Requested cancelAllPendingNotifications().');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_local_notifications Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'flutter_local_notifications lets Flutter apps initialize platform notification services, request permissions, create Android channels, show immediate or repeating notifications, inspect pending requests, and react to taps.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _NotificationsInfoCard(
              title: 'What this module covers',
              description:
                  'This page initializes the plugin locally, requests permissions when the platform supports it, creates an Android channel/group, shows multiple notification styles, schedules repeating notifications, inspects pending/active notifications, and logs notification responses.',
            ),
            const SizedBox(height: 16),
            const _NotificationsCodeCard(
              title: 'Initialization',
              code: '''
final FlutterLocalNotificationsPlugin plugin =
    FlutterLocalNotificationsPlugin();

const InitializationSettings settings = InitializationSettings(
  android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  iOS: DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  ),
  macOS: DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  ),
  linux: LinuxInitializationSettings(defaultActionName: 'Open notification'),
  windows: WindowsInitializationSettings(
    appName: 'Widget Layout Example2',
    appUserModelId: 'com.example.widgetlayout.example2.notifications',
    guid: '43f7d733-ec57-4a20-8fb2-a4f3f00aa501',
  ),
);

await plugin.initialize(
  settings: settings,
  onDidReceiveNotificationResponse: (response) {},
);
''',
            ),
            const SizedBox(height: 16),
            const _NotificationsCodeCard(
              title: 'Show, repeat, inspect, cancel',
              code: '''
await plugin.show(
  id: 1000,
  title: 'Build finished',
  body: 'This is a basic local notification.',
  notificationDetails: details,
  payload: 'basic:1000',
);

await plugin.periodicallyShow(
  id: 1001,
  repeatInterval: RepeatInterval.hourly,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  title: 'Hourly stand-up reminder',
  body: 'Repeating notification example',
  notificationDetails: details,
);

final pending = await plugin.pendingNotificationRequests();
final active = await plugin.getActiveNotifications();
await plugin.cancelAllPendingNotifications();
await plugin.cancelAll();
''',
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Plugin State',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _StatusPanel(
                      title: 'Initialized',
                      value: '$_initialized on ${defaultTargetPlatform.name}',
                    ),
                    const SizedBox(height: 12),
                    _StatusPanel(title: 'Status', value: _status),
                    const SizedBox(height: 12),
                    _StatusPanel(
                      title: 'Notification Response',
                      value: _selectedPayload,
                    ),
                    const SizedBox(height: 12),
                    _StatusPanel(
                      title: 'Launch Details',
                      value: _launchSummary,
                    ),
                    const SizedBox(height: 12),
                    _StatusPanel(
                      title: 'Permissions',
                      value: _permissionsSummary,
                    ),
                    const SizedBox(height: 12),
                    _StatusPanel(
                      title: 'Pending Requests',
                      value: _pendingSummary,
                    ),
                    const SizedBox(height: 12),
                    _StatusPanel(
                      title: 'Active Notifications',
                      value: _activeSummary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: 'Plugin Actions',
              subtitle:
                  'These buttons exercise the core FlutterLocalNotificationsPlugin APIs directly from this page.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: _initializePlugin,
                  icon: const Icon(Icons.power_settings_new_outlined),
                  label: const Text('Initialize'),
                ),
                OutlinedButton.icon(
                  onPressed: _requestPermissions,
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('Request Permission'),
                ),
                OutlinedButton.icon(
                  onPressed: _checkPermissions,
                  icon: const Icon(Icons.security_outlined),
                  label: const Text('Check Permission'),
                ),
                OutlinedButton.icon(
                  onPressed: _refreshLaunchDetails,
                  icon: const Icon(Icons.launch_outlined),
                  label: const Text('Launch Details'),
                ),
                OutlinedButton.icon(
                  onPressed: _createAndroidChannel,
                  icon: const Icon(Icons.tune_outlined),
                  label: const Text('Create Android Channel'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: 'Delivery Examples',
              subtitle:
                  'These examples demonstrate immediate, styled, and repeating notifications using NotificationDetails.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: _showBasicNotification,
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Show Basic'),
                ),
                OutlinedButton.icon(
                  onPressed: _showBigTextNotification,
                  icon: const Icon(Icons.article_outlined),
                  label: const Text('Show Big Text'),
                ),
                OutlinedButton.icon(
                  onPressed: _showInboxNotification,
                  icon: const Icon(Icons.inbox_outlined),
                  label: const Text('Show Inbox Style'),
                ),
                OutlinedButton.icon(
                  onPressed: _showRepeatingNotification,
                  icon: const Icon(Icons.repeat_outlined),
                  label: const Text('Repeat Hourly'),
                ),
                OutlinedButton.icon(
                  onPressed: _showRepeatingDurationNotification,
                  icon: const Icon(Icons.schedule_outlined),
                  label: const Text('Repeat 15 Min'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: 'Inspection And Cleanup',
              subtitle:
                  'Use these to inspect plugin state after scheduling or showing notifications and to clear them again.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: _loadPendingNotifications,
                  icon: const Icon(Icons.pending_actions_outlined),
                  label: const Text('Pending Requests'),
                ),
                OutlinedButton.icon(
                  onPressed: _loadActiveNotifications,
                  icon: const Icon(Icons.mark_email_unread_outlined),
                  label: const Text('Active Notifications'),
                ),
                OutlinedButton.icon(
                  onPressed: _cancelLastNotification,
                  icon: const Icon(Icons.remove_circle_outline),
                  label: const Text('Cancel Last ID'),
                ),
                OutlinedButton.icon(
                  onPressed: _cancelAllPendingNotifications,
                  icon: const Icon(Icons.event_busy_outlined),
                  label: const Text('Cancel Pending'),
                ),
                OutlinedButton.icon(
                  onPressed: _cancelAllNotifications,
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('Cancel All'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _NotificationsInfoCard(
              title: 'Platform notes',
              description:
                  'Android repeating and exact timing may require manifest permissions or alarm-specific setup. This demo now auto-requests notification permission on macOS before delivery so banners can appear without an extra manual step. If permission was previously denied, turn it back on in System Settings > Notifications for this app. Windows and Linux support a different subset of features, so some inspection APIs may return empty data or throw unsupported errors on certain targets.',
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Event Log',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_eventLog.isEmpty)
                      const Text('No actions triggered yet.')
                    else
                      ..._eventLog.map((String line) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            line,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontFamily: 'monospace'),
                          ),
                        );
                      }),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(subtitle),
      ],
    );
  }
}

class _NotificationsInfoCard extends StatelessWidget {
  const _NotificationsInfoCard({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class _NotificationsCodeCard extends StatelessWidget {
  const _NotificationsCodeCard({required this.title, required this.code});

  final String title;
  final String code;

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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                code.trim(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(value),
        ],
      ),
    );
  }
}
