import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../services/notification_service.dart';
import '../services/isolate_manager.dart';

class NotificationHomePage extends StatefulWidget {
  const NotificationHomePage({super.key});

  @override
  State<NotificationHomePage> createState() => _NotificationHomePageState();
}

class _NotificationHomePageState extends State<NotificationHomePage> {
  final NotificationService _notificationService = NotificationService();
  final IsolateManager _isolateManager = IsolateManager();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _setupPortListener();
  }

  void _setupPortListener() {
    _isolateManager.mainReceivePort.listen((dynamic data) {
      setState(() {
        final message = data['message'] ?? 'Unknown message';
        final timestamp = data['timestamp'] ?? DateTime.now().toIso8601String();
        _messages.add('[$timestamp] $message');
      });

      // If it's a background work message, show a notification
      if (data['type'] == 'background_work') {
        _showNotificationFromIsolate(data['message']);
      }
    });
  }

  Future<void> _showNotificationFromIsolate(String message) async {
    await _notificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Background Isolate',
      body: message,
      channelId: 'isolate_channel',
      channelName: 'Isolate Notifications',
      channelDescription: 'Notifications sent from background isolate',
      payload: 'isolate_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<void> _startBackgroundIsolate() async {
    if (_isolateManager.isRunning) return;

    try {
      await _isolateManager.startBackgroundIsolate();
      setState(() {
        _messages.add(
          '[${DateTime.now().toIso8601String()}] Background isolate started',
        );
      });
    } catch (e) {
      setState(() {
        _messages.add(
          '[${DateTime.now().toIso8601String()}] Error starting isolate: $e',
        );
      });
    }
  }

  void _stopBackgroundIsolate() {
    if (!_isolateManager.isRunning) return;

    _isolateManager.stopBackgroundIsolate();
    setState(() {
      _messages.add(
        '[${DateTime.now().toIso8601String()}] Background isolate stopped',
      );
    });
  }

  Future<void> _showInstantNotification() async {
    await _notificationService.showNotification(
      id: 0,
      title: 'Instant Notification',
      body: 'This is an instant notification from the main isolate',
      channelId: 'instant_channel',
      channelName: 'Instant Notifications',
      channelDescription: 'Instant notifications from main isolate',
      payload: 'instant_${DateTime.now().millisecondsSinceEpoch}',
      actions: [
        AndroidNotificationAction('reply', 'Reply'),
        AndroidNotificationAction('dismiss', 'Dismiss'),
      ],
    );
  }

  Future<void> _scheduleNotification() async {
    await _notificationService.scheduleNotification(
      id: 1,
      title: 'Scheduled Notification',
      body: 'This notification was scheduled for 10 seconds from now',
      channelId: 'scheduled_channel',
      channelName: 'Scheduled Notifications',
      channelDescription: 'Scheduled notifications',
      scheduledDate: tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      payload: 'scheduled_${DateTime.now().millisecondsSinceEpoch}',
    );

    setState(() {
      _messages.add(
        '[${DateTime.now().toIso8601String()}] Scheduled notification for 10 seconds from now',
      );
    });
  }

  Future<void> _showPeriodicNotification() async {
    await _notificationService.showPeriodicNotification(
      id: 2,
      title: 'Periodic Notification',
      body: 'This notification repeats every minute',
      channelId: 'periodic_channel',
      channelName: 'Periodic Notifications',
      channelDescription: 'Periodic notifications',
      repeatInterval: RepeatInterval.everyMinute,
      payload: 'periodic_${DateTime.now().millisecondsSinceEpoch}',
    );

    setState(() {
      _messages.add(
        '[${DateTime.now().toIso8601String()}] Started periodic notifications (every minute)',
      );
    });
  }

  Future<void> _cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
    setState(() {
      _messages.add(
        '[${DateTime.now().toIso8601String()}] Cancelled all notifications',
      );
    });
  }

  void _clearMessages() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  void dispose() {
    _isolateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Local Notifications + Isolates'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Isolate Controls
            _buildIsolateControls(),
            const SizedBox(height: 16),
            // Notification Controls
            _buildNotificationControls(),
            const SizedBox(height: 16),
            // Messages
            Expanded(child: _buildMessagesWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildIsolateControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Background Isolate Controls',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isolateManager.isRunning ? null : _startBackgroundIsolate,
                  child: const Text('Start Background Isolate'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isolateManager.isRunning ? _stopBackgroundIsolate : null,
                  child: const Text('Stop Background Isolate'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${_isolateManager.isRunning ? 'Running' : 'Stopped'}',
              style: TextStyle(
                color: _isolateManager.isRunning ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Controls',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _showInstantNotification,
                  child: const Text('Show Instant'),
                ),
                ElevatedButton(
                  onPressed: _scheduleNotification,
                  child: const Text('Schedule (10s)'),
                ),
                ElevatedButton(
                  onPressed: _showPeriodicNotification,
                  child: const Text('Periodic (1min)'),
                ),
                ElevatedButton(
                  onPressed: _cancelAllNotifications,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Cancel All'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _clearMessages,
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet. Start the background isolate or send notifications.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _messages[index],
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
