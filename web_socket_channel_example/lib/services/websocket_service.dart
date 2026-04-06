import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../models/websocket_message.dart';
import '../models/connection_state.dart';

/// Service class to handle WebSocket connections and messaging
class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _streamSubscription;

  // Stream controllers for reactive programming
  final StreamController<WebSocketMessage> _messageController =
      StreamController<WebSocketMessage>.broadcast();
  final StreamController<WebSocketConnectionState> _connectionStateController =
      StreamController<WebSocketConnectionState>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  // Public streams
  Stream<WebSocketMessage> get messageStream => _messageController.stream;
  Stream<WebSocketConnectionState> get connectionStateStream =>
      _connectionStateController.stream;
  Stream<String> get errorStream => _errorController.stream;

  WebSocketConnectionState _currentState =
      WebSocketConnectionState.disconnected;
  String? _currentUrl;

  WebSocketConnectionState get currentState => _currentState;
  String? get currentUrl => _currentUrl;
  bool get isConnected => _currentState == WebSocketConnectionState.connected;

  /// Connect to a WebSocket server
  Future<void> connect(String url) async {
    if (_currentState == WebSocketConnectionState.connected) {
      throw Exception('Already connected. Disconnect first.');
    }

    try {
      _updateState(WebSocketConnectionState.connecting);

      final wsUrl = Uri.parse(url.trim());
      _channel = WebSocketChannel.connect(wsUrl);
      _currentUrl = url;

      // Wait for the connection to be ready
      await _channel!.ready;

      _updateState(WebSocketConnectionState.connected);
      _addMessage(
        WebSocketMessage.connection('Connected to ${wsUrl.toString()}'),
      );

      // Listen to incoming messages
      _streamSubscription = _channel!.stream.listen(
        _onMessageReceived,
        onError: _onError,
        onDone: _onConnectionClosed,
      );

      sendJsonMessage('hello', {
        'message': 'Hello from Flutter web_socket_channel example',
        'sentAt': DateTime.now().toIso8601String(),
        'client': 'flutter',
      });
    } catch (e) {
      _updateState(WebSocketConnectionState.error);
      _addMessage(WebSocketMessage.error('Connection failed: $e'));
      _errorController.add('Connection failed: $e');
      rethrow;
    }
  }

  /// Disconnect from the WebSocket server
  void disconnect() {
    if (_currentState == WebSocketConnectionState.disconnected) return;

    _streamSubscription?.cancel();
    _channel?.sink.close(status.normalClosure);
    _updateState(WebSocketConnectionState.disconnected);
    _addMessage(WebSocketMessage.info('Disconnected'));
    _currentUrl = null;
  }

  /// Send a message through the WebSocket
  void sendMessage(String message) {
    if (!isConnected) {
      throw Exception('Not connected to WebSocket server');
    }

    if (message.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }

    sendJsonMessage('manual_text', {
      'message': message,
      'sentAt': DateTime.now().toIso8601String(),
      'client': 'flutter',
    });
  }

  void sendJsonMessage(String event, Map<String, Object?> payload) {
    if (!isConnected) {
      throw Exception('Not connected to WebSocket server');
    }

    final encoded = const JsonEncoder.withIndent(
      '  ',
    ).convert({'event': event, 'payload': payload});

    _channel?.sink.add(encoded);
    _addMessage(WebSocketMessage.sent(encoded));
  }

  /// Handle incoming messages
  void _onMessageReceived(dynamic message) {
    if (message is String) {
      try {
        final decoded = jsonDecode(message);
        final formatted = const JsonEncoder.withIndent('  ').convert(decoded);
        _addMessage(WebSocketMessage.received(formatted));
        return;
      } catch (_) {
        // Fall back to raw text when the frame is not JSON.
      }
    }

    _addMessage(WebSocketMessage.received(message.toString()));
  }

  /// Handle connection errors
  void _onError(dynamic error) {
    _updateState(WebSocketConnectionState.error);
    _addMessage(WebSocketMessage.error(error.toString()));
    _errorController.add(error.toString());
  }

  /// Handle connection closure
  void _onConnectionClosed() {
    _updateState(WebSocketConnectionState.disconnected);
    _addMessage(WebSocketMessage.info('Connection closed'));
    _currentUrl = null;
  }

  /// Update connection state and notify listeners
  void _updateState(WebSocketConnectionState newState) {
    _currentState = newState;
    _connectionStateController.add(newState);
  }

  /// Add a message and notify listeners
  void _addMessage(WebSocketMessage message) {
    _messageController.add(message);
  }

  /// Dispose of resources
  void dispose() {
    disconnect();
    _messageController.close();
    _connectionStateController.close();
    _errorController.close();
  }
}
