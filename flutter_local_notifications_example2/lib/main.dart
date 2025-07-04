import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Create a global instance of FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Ensure Flutter bindings are initialized before using plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Android initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS (Darwin) initialization settings
  const DarwinInitializationSettings
  initializationSettingsDarwin = DarwinInitializationSettings(
    // Optionally, add a callback to handle notifications while the app is in foreground
    // onDidReceiveLocalNotification: (id, title, body, payload) async {
    //   // Handle iOS foreground notification
    // },
  );

  // macOS initialization settings
  const DarwinInitializationSettings initializationSettingsMacOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

  // Combine all platform settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsMacOS,
  );

  // Initialize the plugin with a callback for when a notification is tapped
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tapped logic here
      print('Notification payload: ${response.payload}');
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(title: 'Notification Demo'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Method to request notification permissions
  Future<void> _requestPermissions() async {
    if (Theme.of(context).platform == TargetPlatform.macOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  // Method to show a local notification
  Future<void> _showNotification() async {
    // Request permissions first (especially for macOS)
    await _requestPermissions();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'your_channel_id', // Unique channel ID
          'your_channel_name', // Visible channel name
          channelDescription: 'Your channel description',
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
          categoryIdentifier: 'plainCategory',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const DarwinNotificationDetails macOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          categoryIdentifier: 'plainCategory',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
      macOS: macOSPlatformChannelSpecifics,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        'Hello!', // Notification title
        'Button pressed notification from Flutter!', // Notification body
        platformChannelSpecifics,
        payload: 'Default_Sound', // Optional payload
      );

      // Show a snackbar to confirm notification was sent
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Notification sent!')));
      }
    } catch (e) {
      print('Error showing notification: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: _showNotification,
          child: const Text('Send Notification'),
        ),
      ),
    );
  }
}
