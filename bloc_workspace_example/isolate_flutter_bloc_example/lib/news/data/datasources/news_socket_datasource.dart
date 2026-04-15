import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/news_connection_status.dart';
import '../../models/news_socket_message.dart';
import '../../models/news_socket_update.dart';
import 'websocket_channel_factory.dart'
    if (dart.library.io) 'websocket_channel_factory_io.dart'
    as websocket_channel_factory;

class NewsSocketDataSource {
  final StreamController<NewsSocketUpdate> _updatesController =
      StreamController<NewsSocketUpdate>.broadcast();

  ReceivePort? _receivePort;
  StreamSubscription<dynamic>? _receiveSubscription;
  Isolate? _isolate;
  Completer<SendPort>? _commandPortCompleter;
  bool _disposed = false;

  Stream<NewsSocketUpdate> get updates => _updatesController.stream;

  Future<void> connect(String url) async {
    final commandPort = await _ensureCommandPort();
    commandPort.send({'type': 'connect', 'url': url});
  }

  Future<void> disconnect() async {
    if (_commandPortCompleter == null) {
      return;
    }

    final commandPort = await _ensureCommandPort();
    commandPort.send({'type': 'disconnect'});
  }

  Future<void> sendMessage(String message) async {
    final commandPort = await _ensureCommandPort();
    commandPort.send({'type': 'sendMessage', 'message': message});
  }

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }

    _disposed = true;

    if (_commandPortCompleter != null && _commandPortCompleter!.isCompleted) {
      final commandPort = await _commandPortCompleter!.future;
      commandPort.send({'type': 'dispose'});
    }

    await _receiveSubscription?.cancel();
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    await _updatesController.close();
  }

  Future<SendPort> _ensureCommandPort() async {
    if (_disposed) {
      throw StateError('NewsSocketDataSource has already been disposed.');
    }

    if (_commandPortCompleter != null && _commandPortCompleter!.isCompleted) {
      return _commandPortCompleter!.future;
    }

    _commandPortCompleter ??= Completer<SendPort>();
    _receivePort ??= ReceivePort();
    _receiveSubscription ??= _receivePort!.listen(_handleIsolateMessage);
    _isolate ??= await Isolate.spawn(
      _socketIsolateMain,
      _receivePort!.sendPort,
    );

    return _commandPortCompleter!.future;
  }

  void _handleIsolateMessage(dynamic rawMessage) {
    if (rawMessage is SendPort) {
      if (_commandPortCompleter != null &&
          !_commandPortCompleter!.isCompleted) {
        _commandPortCompleter!.complete(rawMessage);
      }
      return;
    }

    if (rawMessage is! Map) {
      return;
    }

    final type = rawMessage['type'] as String?;
    switch (type) {
      case 'status':
        _updatesController.add(
          NewsSocketUpdate.status(
            _statusFromValue(rawMessage['status'] as String?),
          ),
        );
        break;
      case 'message':
        _updatesController.add(
          NewsSocketUpdate.message(
            NewsSocketMessage.fromMap(Map<String, dynamic>.from(rawMessage)),
          ),
        );
        break;
      case 'error':
        final errorMessage =
            rawMessage['error'] as String? ?? 'Unknown WebSocket error';
        _updatesController.add(NewsSocketUpdate.error(errorMessage));
        _updatesController.add(
          NewsSocketUpdate.status(NewsConnectionStatus.error),
        );
        break;
      default:
        break;
    }
  }

  NewsConnectionStatus _statusFromValue(String? value) {
    return switch (value) {
      'connecting' => NewsConnectionStatus.connecting,
      'connected' => NewsConnectionStatus.connected,
      'error' => NewsConnectionStatus.error,
      _ => NewsConnectionStatus.disconnected,
    };
  }

  static Future<void> _socketIsolateMain(SendPort mainSendPort) async {
    final commandPort = ReceivePort();
    mainSendPort.send(commandPort.sendPort);

    WebSocketChannel? channel;
    StreamSubscription<dynamic>? channelSubscription;

    Future<void> closeChannel() async {
      await channelSubscription?.cancel();
      channelSubscription = null;

      if (channel != null) {
        await channel!.sink.close(status.normalClosure);
        channel = null;
      }
    }

    commandPort.listen((dynamic rawCommand) async {
      if (rawCommand is! Map) {
        return;
      }

      final command = rawCommand['type'] as String?;

      switch (command) {
        case 'connect':
          final url = rawCommand['url'] as String? ?? '';
          mainSendPort.send({'type': 'status', 'status': 'connecting'});

          try {
            await closeChannel();

            final uri = Uri.parse(url);
            final nextChannel = websocket_channel_factory
                .connectWebSocketChannel(uri);
            await nextChannel.ready;

            channel = nextChannel;
            mainSendPort.send({'type': 'status', 'status': 'connected'});
            mainSendPort.send(
              _buildMessage(text: 'Connected to $url', messageType: 'system'),
            );

            channelSubscription = channel!.stream.listen(
              (dynamic message) {
                mainSendPort.send(
                  _buildMessage(
                    text: _normalizeMessage(message),
                    messageType: 'received',
                  ),
                );
              },
              onError: (Object error, StackTrace stackTrace) {
                mainSendPort.send({'type': 'error', 'error': error.toString()});
              },
              onDone: () {
                mainSendPort.send({'type': 'status', 'status': 'disconnected'});
                mainSendPort.send(
                  _buildMessage(
                    text: 'Socket connection closed',
                    messageType: 'system',
                  ),
                );
              },
              cancelOnError: true,
            );
          } catch (error) {
            mainSendPort.send({
              'type': 'error',
              'error': 'Connection failed: $error',
            });
          }
          break;
        case 'sendMessage':
          final message = rawCommand['message'] as String? ?? '';

          if (channel == null) {
            mainSendPort.send(const {
              'type': 'error',
              'error': 'Connect before sending data.',
            });
            return;
          }

          try {
            channel!.sink.add(message);
            mainSendPort.send(
              _buildMessage(text: message, messageType: 'sent'),
            );
          } catch (error) {
            mainSendPort.send({
              'type': 'error',
              'error': 'Send failed: $error',
            });
          }
          break;
        case 'disconnect':
          await closeChannel();
          mainSendPort.send({'type': 'status', 'status': 'disconnected'});
          mainSendPort.send(
            _buildMessage(
              text: 'Disconnected from socket',
              messageType: 'system',
            ),
          );
          break;
        case 'dispose':
          await closeChannel();
          commandPort.close();
          Isolate.exit();
        default:
          break;
      }
    });
  }

  static Map<String, Object?> _buildMessage({
    required String text,
    required String messageType,
  }) {
    return {
      'type': 'message',
      'text': text,
      'messageType': messageType,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  static String _normalizeMessage(dynamic message) {
    if (message is String) {
      try {
        final decoded = jsonDecode(message);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      } catch (_) {
        return message;
      }
    }

    return message.toString();
  }
}
