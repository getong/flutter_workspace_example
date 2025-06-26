import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bot Toast Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Bot Toast Demo'),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showTextToast() {
    BotToast.showText(text: "This is a simple text toast!");
  }

  void _showLoadingToast() {
    BotToast.showLoading();
    // Auto dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      BotToast.closeAllLoading();
    });
  }

  void _showNotificationToast() {
    BotToast.showNotification(
      title: (_) => const Text('Notification Title'),
      subtitle: (_) =>
          const Text('This is a notification toast with title and subtitle'),
      trailing: (_) => const Icon(Icons.notifications),
      duration: const Duration(seconds: 4),
    );
  }

  void _showCustomToast() {
    BotToast.showCustomText(
      toastBuilder: (_) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Custom Success Toast!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
    );
  }

  void _showAttachToast() {
    BotToast.showAttachedWidget(
      attachedBuilder: (_) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Attached Widget',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('This toast is attached to a specific widget'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => BotToast.closeAllLoading(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
      duration: const Duration(seconds: 5),
      target: Offset(MediaQuery.of(context).size.width / 2, 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bot Toast Examples:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _showTextToast,
              child: const Text('Show Text Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showLoadingToast,
              child: const Text('Show Loading Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showNotificationToast,
              child: const Text('Show Notification Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showCustomToast,
              child: const Text('Show Custom Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showAttachToast,
              child: const Text('Show Attached Toast'),
            ),
          ],
        ),
      ),
    );
  }
}
