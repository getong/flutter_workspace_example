import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_ws_example/websocket/data/ws_repository.dart';

import 'ws_event.dart';
import 'ws_state.dart';

class WsBloc extends Bloc<WsEvent, WsState> {
  WsBloc({required WsRepository repository})
    : _repository = repository,
      super(const WsState()) {
    on<WsConnectRequested>(_onConnectRequested);
    on<WsDisconnectRequested>(_onDisconnectRequested);
    on<WsSendPressed>(_onSendPressed);
    on<WsMessageArrived>(_onMessageArrived);
    on<WsSocketError>(_onSocketError);
    on<WsSocketDone>(_onSocketDone);
  }

  final WsRepository _repository;
  StreamSubscription<dynamic>? _subscription;

  Future<void> _onConnectRequested(
    WsConnectRequested event,
    Emitter<WsState> emit,
  ) async {
    final url = event.url.trim();
    if (url.isEmpty) {
      emit(
        state.copyWith(
          status: WsStatus.error,
          errorMessage: 'WebSocket URL is empty.',
        ),
      );
      return;
    }

    await _subscription?.cancel();
    _subscription = null;
    await _repository.disconnect();

    emit(
      state.copyWith(
        status: WsStatus.connecting,
        clearErrorMessage: true,
        connectedUrl: url,
      ),
    );

    try {
      final stream = await _repository.connect(url);
      _subscription = stream.listen(
        (dynamic data) {
          add(WsMessageArrived(_formatIncomingData(data)));
        },
        onError: (Object error, StackTrace stackTrace) {
          add(WsSocketError(error.toString()));
        },
        onDone: () {
          add(const WsSocketDone());
        },
        cancelOnError: false,
      );

      emit(
        state.copyWith(
          status: WsStatus.connected,
          messages: [...state.messages, '[system] Connected: ${url.trim()}'],
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: WsStatus.error,
          errorMessage: 'Connect failed: $error',
          messages: [...state.messages, '[system] Connect failed: $url'],
          clearConnectedUrl: true,
        ),
      );
    }
  }

  Future<void> _onDisconnectRequested(
    WsDisconnectRequested event,
    Emitter<WsState> emit,
  ) async {
    await _subscription?.cancel();
    _subscription = null;
    await _repository.disconnect();

    final reason = event.fromServer
        ? '[system] Disconnected by server.'
        : '[system] Disconnected manually.';

    emit(
      state.copyWith(
        status: WsStatus.disconnected,
        messages: [...state.messages, reason],
        clearConnectedUrl: true,
      ),
    );
  }

  void _onSendPressed(WsSendPressed event, Emitter<WsState> emit) {
    final message = event.message.trim();
    if (state.status != WsStatus.connected || message.isEmpty) {
      return;
    }

    final jsonValue = _tryDecodeJson(message);
    if (jsonValue != null) {
      final encoded = jsonEncode(jsonValue);
      _repository.send(encoded);
      emit(
        state.copyWith(
          messages: [
            ...state.messages,
            '[me][json]\n${_prettyJson(jsonValue)}',
          ],
        ),
      );
      return;
    }

    _repository.send(message);
    emit(state.copyWith(messages: [...state.messages, '[me] $message']));
  }

  void _onMessageArrived(WsMessageArrived event, Emitter<WsState> emit) {
    emit(state.copyWith(messages: [...state.messages, event.message]));
  }

  void _onSocketError(WsSocketError event, Emitter<WsState> emit) {
    emit(
      state.copyWith(status: WsStatus.error, errorMessage: event.errorMessage),
    );
  }

  void _onSocketDone(WsSocketDone event, Emitter<WsState> emit) {
    if (state.status == WsStatus.disconnected) {
      return;
    }
    add(const WsDisconnectRequested(fromServer: true));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _repository.disconnect();
    return super.close();
  }

  String _formatIncomingData(dynamic data) {
    if (data is String) {
      return _formatIncomingText(data);
    }
    if (data is List<int>) {
      final decodedText = utf8.decode(data, allowMalformed: true);
      return _formatIncomingText(decodedText);
    }
    return '[recv] $data';
  }

  String _formatIncomingText(String text) {
    final jsonValue = _tryDecodeJson(text);
    if (jsonValue == null) {
      return '[recv] $text';
    }
    return '[recv][json]\n${_prettyJson(jsonValue)}';
  }

  Object? _tryDecodeJson(String input) {
    try {
      return jsonDecode(input);
    } catch (_) {
      return null;
    }
  }

  String _prettyJson(Object value) {
    return const JsonEncoder.withIndent('  ').convert(value);
  }
}
