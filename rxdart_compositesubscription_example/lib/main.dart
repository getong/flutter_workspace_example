import 'package:flutter/material.dart';
import 'services/subscription_service.dart';
import 'widgets/status_indicator.dart';
import 'widgets/stream_data_card.dart';
import 'widgets/control_buttons.dart';
import 'widgets/event_log.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RxDart CompositeSubscription Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CompositeSubscriptionExample(),
    );
  }
}

class CompositeSubscriptionExample extends StatefulWidget {
  const CompositeSubscriptionExample({super.key});

  @override
  State<CompositeSubscriptionExample> createState() =>
      _CompositeSubscriptionExampleState();
}

class _CompositeSubscriptionExampleState
    extends State<CompositeSubscriptionExample> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  final TextEditingController _textController = TextEditingController();

  // State variables
  int _timerCount = 0;
  String _lastButtonClick = 'None';
  String _textInputValue = '';
  List<String> _combinedEvents = [];

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      _subscriptionService.addTextInput(_textController.text);
    });
    _startSubscriptions();
  }

  void _startSubscriptions() {
    setState(() {
      _combinedEvents.clear();
    });

    _subscriptionService.startSubscriptions(
      onTimerTick: (count) {
        setState(() {
          _timerCount = count;
        });
      },
      onButtonClick: (buttonName) {
        setState(() {
          _lastButtonClick = buttonName;
          _combinedEvents.add('Button: $buttonName');
        });
      },
      onTextInput: (text) {
        setState(() {
          _textInputValue = text;
          if (text.isNotEmpty) {
            _combinedEvents.add('Text: $text');
          }
        });
      },
      onCombinedEvent: (event) {
        setState(() {
          _combinedEvents.add('Combined: $event');
        });
      },
    );
  }

  void _stopAllSubscriptions() {
    _subscriptionService.stopAllSubscriptions();
    setState(() {});
  }

  void _restartSubscriptions() {
    _stopAllSubscriptions();
    _startSubscriptions();
  }

  void _toggleSubscriptions() {
    if (_subscriptionService.isActive) {
      _stopAllSubscriptions();
    } else {
      _startSubscriptions();
    }
  }

  @override
  void dispose() {
    _subscriptionService.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('RxDart CompositeSubscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusIndicator(isActive: _subscriptionService.isActive),
            const SizedBox(height: 20),

            StreamDataCard(
              timerCount: _timerCount,
              lastButtonClick: _lastButtonClick,
              textInputValue: _textInputValue,
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Type something...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      _subscriptionService.addButtonClick('Button A'),
                  child: const Text('Button A'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _subscriptionService.addButtonClick('Button B'),
                  child: const Text('Button B'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _subscriptionService.addButtonClick('Button C'),
                  child: const Text('Button C'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ControlButtons(
              subscriptionsActive: _subscriptionService.isActive,
              onToggleSubscriptions: _toggleSubscriptions,
              onRestart: _restartSubscriptions,
            ),

            const SizedBox(height: 20),

            Expanded(child: EventLog(events: _combinedEvents)),
          ],
        ),
      ),
    );
  }
}
