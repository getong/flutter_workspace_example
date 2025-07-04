# Flutter Local Notifications with Isolates Example

This Flutter application demonstrates how to use local notifications with background isolates for handling tasks that need to run independently of the main UI thread.

## Features

- ✅ **Local Notifications**: Show instant, scheduled, and periodic notifications
- ✅ **Background Isolates**: Run background tasks independently from the main UI
- ✅ **Cross-Platform**: Works on Android, iOS, and macOS
- ✅ **Modular Architecture**: Clean separation of concerns with service classes
- ✅ **Notification Actions**: Handle notification tap events and actions
- ✅ **Timezone Support**: Proper timezone handling for scheduled notifications

## Project Structure

```
lib/
├── main.dart                           # App entry point and initialization
├── app.dart                           # Main app widget
├── pages/
│   └── notification_home_page.dart    # Main UI page
└── services/
    ├── notification_service.dart      # Notification handling service
    └── isolate_manager.dart          # Background isolate management
```

## Key Components

### 1. NotificationService (`lib/services/notification_service.dart`)
- Handles all notification-related operations
- Manages platform-specific initialization (Android, iOS, macOS)
- Provides methods for instant, scheduled, and periodic notifications
- Handles notification permissions

### 2. IsolateManager (`lib/services/isolate_manager.dart`)
- Manages background isolate lifecycle
- Handles communication between main isolate and background isolate
- Provides background notification tap handling
- Manages isolate port communication

### 3. NotificationHomePage (`lib/pages/notification_home_page.dart`)
- Main UI for the application
- Controls for starting/stopping background isolates
- Buttons for triggering different types of notifications
- Message display for isolate communication logs

## How It Works

### Background Isolate Communication
1. The main isolate creates a `ReceivePort` to listen for messages
2. A background isolate is spawned with a `SendPort` to communicate back
3. The background isolate runs a periodic timer (every 30 seconds)
4. Messages are sent from background to main isolate
5. Main isolate receives messages and can trigger notifications

### Notification Types
- **Instant**: Immediate notifications with action buttons
- **Scheduled**: Notifications scheduled for future delivery (10 seconds delay)
- **Periodic**: Recurring notifications (every minute)
- **Background**: Notifications triggered by background isolate work

## Setup Instructions

### Dependencies
The following packages are required in `pubspec.yaml`:
```yaml
dependencies:
  flutter_local_notifications: ^19.3.0
  timezone: ^0.9.4
  flutter_timezone: ^3.0.1
```

### Android Setup
1. Add notification permissions to `android/app/src/main/AndroidManifest.xml`
2. Configure notification channels and receivers
3. Set up exact alarm permissions for scheduled notifications

### iOS/macOS Setup
1. Request notification permissions in app initialization
2. Configure notification categories and actions
3. Set up background notification handling

## Usage

### Starting the Application
```dart
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
```

### Using the NotificationService
```dart
final notificationService = NotificationService();

// Show instant notification
await notificationService.showNotification(
  id: 1,
  title: 'Test Notification',
  body: 'This is a test notification',
  channelId: 'test_channel',
  channelName: 'Test Channel',
  channelDescription: 'Test notifications',
);

// Schedule notification
await notificationService.scheduleNotification(
  id: 2,
  title: 'Scheduled Notification',
  body: 'This was scheduled',
  channelId: 'scheduled_channel',
  channelName: 'Scheduled Channel',
  channelDescription: 'Scheduled notifications',
  scheduledDate: tz.TZDateTime.now(tz.local).add(Duration(seconds: 10)),
);
```

### Using the IsolateManager
```dart
final isolateManager = IsolateManager();

// Initialize
isolateManager.initialize();

// Start background isolate
await isolateManager.startBackgroundIsolate();

// Listen to messages
isolateManager.mainReceivePort.listen((data) {
  print('Received: ${data['message']}');
});

// Stop background isolate
isolateManager.stopBackgroundIsolate();
```

## Testing

### Manual Testing
1. Run the app on a device/simulator
2. Click "Start Background Isolate" to begin background work
3. Background isolate will send messages every 30 seconds
4. Test different notification types using the UI buttons
5. Observe notifications in the system notification tray

### Features to Test
- ✅ Background isolate communication
- ✅ Instant notifications with actions
- ✅ Scheduled notifications (10-second delay)
- ✅ Periodic notifications (every minute)
- ✅ Notification tap handling
- ✅ Cross-platform compatibility

## Troubleshooting

### Common Issues
1. **Permissions**: Ensure notification permissions are granted
2. **Timezone**: Make sure timezone is properly initialized
3. **Platform Settings**: Check platform-specific notification settings
4. **Background Limits**: Some devices may limit background processing

### Debug Tips
- Check console logs for initialization errors
- Verify notification permissions in device settings
- Test on different platforms (Android/iOS/macOS)
- Monitor the messages widget for isolate communication

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is for educational purposes and demonstrates Flutter local notifications with isolates.
