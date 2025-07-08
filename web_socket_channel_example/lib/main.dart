import 'package:flutter/material.dart';
import 'services/websocket_service.dart';
import 'models/websocket_message.dart';
import 'models/connection_state.dart';
import 'widgets/connection_widget.dart';
import 'widgets/message_input_widget.dart';
import 'widgets/message_list_widget.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Channel Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WebSocketExample(),
    );
  }
}

class WebSocketExample extends StatefulWidget {
  const WebSocketExample({super.key});

  @override
  State<WebSocketExample> createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketExample> {
  late final WebSocketService _webSocketService;
  final TextEditingController _urlController = TextEditingController(
    text: 'wss://echo.websocket.org', // Free WebSocket testing service
  );
  final TextEditingController _messageController = TextEditingController();
  final List<WebSocketMessage> _messages = [];
  WebSocketConnectionState _connectionState =
      WebSocketConnectionState.disconnected;

  late StreamSubscription _messageSubscription;
  late StreamSubscription _connectionStateSubscription;
  late StreamSubscription _errorSubscription;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    _setupSubscriptions();
  }

  void _setupSubscriptions() {
    // Listen to messages
    _messageSubscription = _webSocketService.messageStream.listen((message) {
      setState(() {
        _messages.add(message);
      });
    });

    // Listen to connection state changes
    _connectionStateSubscription = _webSocketService.connectionStateStream
        .listen((state) {
          setState(() {
            _connectionState = state;
          });
        });

    // Listen to errors
    _errorSubscription = _webSocketService.errorStream.listen((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('WebSocket Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    _connectionStateSubscription.cancel();
    _errorSubscription.cancel();
    _webSocketService.dispose();
    _urlController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _connect() async {
    try {
      await _webSocketService.connect(_urlController.text.trim());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _disconnect() {
    _webSocketService.disconnect();
  }

  void _sendMessage() {
    try {
      final message = _messageController.text.trim();
      if (message.isNotEmpty) {
        _webSocketService.sendMessage(message);
        _messageController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearMessages() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Channel Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _clearMessages,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear messages',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection section
            ConnectionWidget(
              urlController: _urlController,
              connectionState: _connectionState,
              onConnect: _connect,
              onDisconnect: _disconnect,
            ),
            const SizedBox(height: 16),

            // Message sending section
            MessageInputWidget(
              messageController: _messageController,
              isConnected:
                  _connectionState == WebSocketConnectionState.connected,
              onSendMessage: _sendMessage,
            ),
            const SizedBox(height: 16),

            // Messages section
            Flexible(
              child: MessageListWidget(
                messages: _messages,
                onClearMessages: _clearMessages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
