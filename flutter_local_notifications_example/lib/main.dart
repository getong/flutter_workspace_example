import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'app.dart';
import 'services/notification_service.dart';
import 'services/isolate_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  // Initialize services
  await _initializeServices();

  runApp(const MyApp());
}

Future<void> _initializeServices() async {
  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize(
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      debugPrint('Notification tapped: ${response.payload}');
    },
    onDidReceiveBackgroundNotificationResponse: IsolateManager.notificationTapBackground,
  );

  // Initialize isolate manager
  final isolateManager = IsolateManager();
  isolateManager.initialize();
}
