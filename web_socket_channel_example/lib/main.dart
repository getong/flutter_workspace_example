import 'dart:async';

import 'package:flutter/material.dart';

import 'models/connection_state.dart';
import 'models/websocket_message.dart';
import 'pages/auth_page.dart';
import 'service_locator.dart';
import 'services/session_store.dart';
import 'services/websocket_service.dart';
import 'widgets/connection_widget.dart';
import 'widgets/message_input_widget.dart';
import 'widgets/message_list_widget.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Axum Client Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const _titles = ['Auth', 'WebSocket'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Axum ${_titles[_currentIndex]}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [AuthPage(), WebSocketExample()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.login), label: 'Auth'),
          NavigationDestination(icon: Icon(Icons.wifi), label: 'WebSocket'),
        ],
      ),
    );
  }
}

class WebSocketExample extends StatefulWidget {
  const WebSocketExample({super.key});

  @override
  State<WebSocketExample> createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketExample> {
  static const _compactHeightThreshold = 560.0;
  static const _compactMessageListHeight = 220.0;

  late final WebSocketService _webSocketService;
  late final SessionStore _sessionStore;
  late final TextEditingController _urlController;
  late final TextEditingController _tokenController;
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
    _sessionStore = getIt<SessionStore>();
    _urlController = TextEditingController(text: _sessionStore.webSocketUrl);
    _tokenController = TextEditingController(
      text: _sessionStore.supabaseAccessToken ?? '',
    );
    _sessionStore.addListener(_syncFromSessionStore);
    _urlController.addListener(_handleUrlChanged);
    _tokenController.addListener(_handleTokenChanged);
    _webSocketService = WebSocketService();
    _setupSubscriptions();
  }

  void _syncFromSessionStore() {
    if (_urlController.text != _sessionStore.webSocketUrl) {
      _urlController.text = _sessionStore.webSocketUrl;
    }

    final token = _sessionStore.supabaseAccessToken ?? '';
    if (_tokenController.text != token) {
      _tokenController.text = token;
    }
  }

  void _handleUrlChanged() {
    _sessionStore.updateWebSocketUrl(_urlController.text);
  }

  void _handleTokenChanged() {
    _sessionStore.updateSupabaseAccessToken(_tokenController.text);
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
    _sessionStore.removeListener(_syncFromSessionStore);
    _urlController.removeListener(_handleUrlChanged);
    _tokenController.removeListener(_handleTokenChanged);
    _webSocketService.dispose();
    _urlController.dispose();
    _tokenController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _connect() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Supabase access token required. Sign in from the Auth tab first.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _webSocketService.connect(
        _urlController.text.trim(),
        accessToken: token,
      );
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final useCompactLayout =
            constraints.maxHeight < _compactHeightThreshold;

        final children = [
          ConnectionWidget(
            urlController: _urlController,
            tokenController: _tokenController,
            connectionState: _connectionState,
            onConnect: _connect,
            onDisconnect: _disconnect,
          ),
          const SizedBox(height: 16),
          MessageInputWidget(
            messageController: _messageController,
            isConnected: _connectionState == WebSocketConnectionState.connected,
            onSendMessage: _sendMessage,
          ),
          const SizedBox(height: 16),
        ];

        if (useCompactLayout) {
          children.add(
            SizedBox(
              height: _compactMessageListHeight,
              child: MessageListWidget(
                messages: _messages,
                onClearMessages: _clearMessages,
              ),
            ),
          );
        } else {
          children.add(
            Expanded(
              child: MessageListWidget(
                messages: _messages,
                onClearMessages: _clearMessages,
              ),
            ),
          );
        }

        children.addAll([
          const SizedBox(height: 8),
          const Text(
            'Browser builds still require you to trust the Rust server certificate in the browser first because web clients cannot bypass self-signed TLS validation.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ]);

        if (useCompactLayout) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        );
      },
    );
  }
}
