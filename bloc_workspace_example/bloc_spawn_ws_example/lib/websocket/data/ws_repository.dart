import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';

sealed class WsRepositoryEvent {
  const WsRepositoryEvent();
}

class WsRepositoryConnected extends WsRepositoryEvent {
  const WsRepositoryConnected(this.url);

  final String url;
}

class WsRepositoryBinaryMessage extends WsRepositoryEvent {
  const WsRepositoryBinaryMessage({
    required this.bytes,
    required this.receivedAt,
    required this.sourceType,
  });

  final Uint8List bytes;
  final DateTime receivedAt;
  final String sourceType;
}

class WsRepositoryDisconnected extends WsRepositoryEvent {
  const WsRepositoryDisconnected({required this.fromServer, this.reason});

  final bool fromServer;
  final String? reason;
}

class WsRepositoryError extends WsRepositoryEvent {
  const WsRepositoryError(this.message);

  final String message;
}

class WsRepository {
  final StreamController<WsRepositoryEvent> _eventsController =
      StreamController<WsRepositoryEvent>.broadcast();

  Stream<WsRepositoryEvent> get events => _eventsController.stream;

  Isolate? _isolate;
  ReceivePort? _receivePort;
  StreamSubscription<dynamic>? _receiveSubscription;
  SendPort? _workerSendPort;
  Future<void>? _bootstrapFuture;
  Completer<void>? _readyCompleter;

  Future<void> connect(String url) async {
    await _ensureWorker();
    _workerSendPort?.send(<String, Object?>{'type': 'connect', 'url': url});
  }

  Future<void> disconnect() async {
    if (_workerSendPort == null && _bootstrapFuture == null) {
      return;
    }
    await _ensureWorker();
    _workerSendPort?.send(const <String, Object?>{'type': 'disconnect'});
  }

  Future<void> sendText(String message) async {
    if (_workerSendPort == null && _bootstrapFuture == null) {
      return;
    }
    await _ensureWorker();
    _workerSendPort?.send(<String, Object?>{
      'type': 'sendText',
      'message': message,
    });
  }

  Future<void> sendBinary(Uint8List bytes) async {
    if (_workerSendPort == null && _bootstrapFuture == null) {
      return;
    }
    await _ensureWorker();
    _workerSendPort?.send(<String, Object?>{
      'type': 'sendBinary',
      'bytes': bytes,
    });
  }

  Future<void> dispose() async {
    _workerSendPort?.send(const <String, Object?>{'type': 'shutdown'});
    await _receiveSubscription?.cancel();
    _receivePort?.close();
    await _eventsController.close();
    _isolate?.kill(priority: Isolate.immediate);
    _receiveSubscription = null;
    _receivePort = null;
    _workerSendPort = null;
    _isolate = null;
    _bootstrapFuture = null;
    _readyCompleter = null;
  }

  Future<void> _ensureWorker() async {
    final existing = _bootstrapFuture;
    if (existing != null) {
      await existing;
      return;
    }

    final completer = Completer<void>();
    _bootstrapFuture = completer.future;
    _readyCompleter = completer;

    final receivePort = ReceivePort();
    _receivePort = receivePort;
    _receiveSubscription = receivePort.listen(_onWorkerMessage);

    _isolate = await Isolate.spawn<_WorkerBootstrapMessage>(
      _wsWorkerMain,
      _WorkerBootstrapMessage(receivePort.sendPort),
    );

    await completer.future;
  }

  void _onWorkerMessage(dynamic message) {
    if (message is! Map<Object?, Object?>) {
      return;
    }

    final type = message['type'];
    switch (type) {
      case 'ready':
        final port = message['port'];
        if (port is SendPort) {
          _workerSendPort = port;
          final completer = _readyCompleter;
          if (completer != null && !completer.isCompleted) {
            completer.complete();
          }
        }
        break;
      case 'connected':
        final url = message['url'];
        if (url is String) {
          _eventsController.add(WsRepositoryConnected(url));
        }
        break;
      case 'binaryData':
        final bytes = message['bytes'];
        final sourceType = message['sourceType'];
        if (bytes is Uint8List && sourceType is String) {
          final millis = message['receivedAtMillis'];
          final receivedAt = millis is int
              ? DateTime.fromMillisecondsSinceEpoch(millis)
              : DateTime.now();
          _eventsController.add(
            WsRepositoryBinaryMessage(
              bytes: bytes,
              receivedAt: receivedAt,
              sourceType: sourceType,
            ),
          );
        }
        break;
      case 'disconnected':
        final fromServer = message['fromServer'] == true;
        final reason = message['reason'] as String?;
        _eventsController.add(
          WsRepositoryDisconnected(fromServer: fromServer, reason: reason),
        );
        break;
      case 'error':
        final error = message['message'];
        if (error is String) {
          _eventsController.add(WsRepositoryError(error));
        }
        break;
    }
  }
}

class _WorkerBootstrapMessage {
  const _WorkerBootstrapMessage(this.mainSendPort);

  final SendPort mainSendPort;
}

void _wsWorkerMain(_WorkerBootstrapMessage bootstrap) {
  final commandPort = ReceivePort();
  bootstrap.mainSendPort.send(<String, Object?>{
    'type': 'ready',
    'port': commandPort.sendPort,
  });

  WebSocketChannel? channel;
  StreamSubscription<dynamic>? subscription;
  var connectedUrl = '';
  var manualDisconnectInProgress = false;

  Future<void> closeSocket({
    required bool fromServer,
    String? reason,
    bool notify = true,
  }) async {
    manualDisconnectInProgress = !fromServer;
    await subscription?.cancel();
    subscription = null;
    final channelToClose = channel;
    channel = null;
    connectedUrl = '';
    await channelToClose?.sink.close();
    if (notify) {
      bootstrap.mainSendPort.send(<String, Object?>{
        'type': 'disconnected',
        'fromServer': fromServer,
        'reason': reason,
      });
    }
  }

  commandPort.listen((dynamic message) async {
    if (message is! Map<Object?, Object?>) {
      return;
    }

    final type = message['type'];
    switch (type) {
      case 'connect':
        final rawUrl = message['url'];
        if (rawUrl is! String) {
          return;
        }

        try {
          final uri = _normalizeWebSocketUri(rawUrl);
          await closeSocket(
            fromServer: false,
            reason: 'Replaced by a new connection.',
            notify: false,
          );

          final nextChannel = WebSocketChannel.connect(uri);
          await nextChannel.ready;
          manualDisconnectInProgress = false;
          channel = nextChannel;
          connectedUrl = uri.toString();
          bootstrap.mainSendPort.send(<String, Object?>{
            'type': 'connected',
            'url': connectedUrl,
          });

          subscription = nextChannel.stream.listen(
            (dynamic data) {
              final bytes = switch (data) {
                Uint8List value => value,
                List<int> value => Uint8List.fromList(value),
                String value => Uint8List.fromList(utf8.encode(value)),
                _ => Uint8List.fromList(utf8.encode(data.toString())),
              };

              bootstrap.mainSendPort.send(<String, Object?>{
                'type': 'binaryData',
                'bytes': bytes,
                'sourceType': data.runtimeType.toString(),
                'receivedAtMillis': DateTime.now().millisecondsSinceEpoch,
              });
            },
            onError: (Object error, StackTrace stackTrace) {
              bootstrap.mainSendPort.send(<String, Object?>{
                'type': 'error',
                'message': error.toString(),
              });
            },
            onDone: () {
              final fromServer = !manualDisconnectInProgress;
              bootstrap.mainSendPort.send(<String, Object?>{
                'type': 'disconnected',
                'fromServer': fromServer,
                'reason': fromServer ? 'Socket closed by server.' : null,
              });
              channel = null;
              subscription = null;
              connectedUrl = '';
            },
            cancelOnError: false,
          );
        } catch (error) {
          bootstrap.mainSendPort.send(<String, Object?>{
            'type': 'error',
            'message': 'Connect failed: $error',
          });
        }
        break;
      case 'disconnect':
        await closeSocket(fromServer: false, notify: false);
        break;
      case 'sendText':
        final socket = channel;
        final text = message['message'];
        if (socket != null && text is String) {
          socket.sink.add(text);
        }
        break;
      case 'sendBinary':
        final socket = channel;
        final bytes = message['bytes'];
        if (socket != null && bytes is Uint8List) {
          socket.sink.add(bytes);
        }
        break;
      case 'shutdown':
        await closeSocket(fromServer: false, notify: false);
        commandPort.close();
        break;
    }
  });
}

Uri _normalizeWebSocketUri(String rawUrl) {
  final trimmedUrl = rawUrl.trim();
  if (trimmedUrl.isEmpty) {
    throw const FormatException('WebSocket URL is empty.');
  }

  final urlWithScheme = trimmedUrl.contains('://')
      ? trimmedUrl
      : 'ws://$trimmedUrl';

  final uri = Uri.parse(urlWithScheme);
  final scheme = uri.scheme.toLowerCase();
  if (scheme != 'ws' && scheme != 'wss') {
    throw const FormatException('Only ws:// and wss:// URLs are supported.');
  }
  if (uri.host.isEmpty) {
    throw const FormatException('WebSocket URL must include a host.');
  }
  return uri;
}
