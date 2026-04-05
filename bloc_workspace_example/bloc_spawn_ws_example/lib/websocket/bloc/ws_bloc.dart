import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bloc_spawn_ws_example/websocket/data/ws_repository.dart';

import 'ws_event.dart';
import 'ws_state.dart';

class WsBloc extends Bloc<WsEvent, WsState> {
  WsBloc({required WsRepository repository})
    : _repository = repository,
      super(const WsState()) {
    on<WsConnectRequested>(_onConnectRequested);
    on<WsDisconnectRequested>(_onDisconnectRequested);
    on<WsSendTextPressed>(_onSendTextPressed);
    on<WsSendBinaryPressed>(_onSendBinaryPressed);
    on<WsConnected>(_onConnected);
    on<WsBinaryDataArrived>(_onBinaryDataArrived);
    on<WsSocketError>(_onSocketError);

    _subscription = _repository.events.listen(_onRepositoryEvent);
  }

  final WsRepository _repository;
  late final StreamSubscription<WsRepositoryEvent> _subscription;

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

    emit(
      state.copyWith(
        status: WsStatus.connecting,
        connectedUrl: url,
        clearErrorMessage: true,
      ),
    );

    await _repository.connect(url);
  }

  Future<void> _onDisconnectRequested(
    WsDisconnectRequested event,
    Emitter<WsState> emit,
  ) async {
    if (!event.fromServer) {
      await _repository.disconnect();
    }

    final nextLog = event.fromServer
        ? '[system] Server closed the connection.'
        : '[system] Disconnected manually.';

    if (state.status == WsStatus.disconnected &&
        state.logs.isNotEmpty &&
        state.logs.last == nextLog) {
      return;
    }

    emit(
      state.copyWith(
        status: WsStatus.disconnected,
        clearConnectedUrl: true,
        logs: [...state.logs, nextLog],
      ),
    );
  }

  Future<void> _onSendTextPressed(
    WsSendTextPressed event,
    Emitter<WsState> emit,
  ) async {
    final message = event.message.trim();
    if (state.status != WsStatus.connected || message.isEmpty) {
      return;
    }

    await _repository.sendText(message);
    emit(state.copyWith(logs: [...state.logs, '[me][text] $message']));
  }

  Future<void> _onSendBinaryPressed(
    WsSendBinaryPressed event,
    Emitter<WsState> emit,
  ) async {
    if (state.status != WsStatus.connected || event.bytes.isEmpty) {
      return;
    }

    await _repository.sendBinary(event.bytes);
    emit(
      state.copyWith(
        logs: [...state.logs, '[me][binary] ${_formatBytes(event.bytes)}'],
      ),
    );
  }

  void _onConnected(WsConnected event, Emitter<WsState> emit) {
    emit(
      state.copyWith(
        status: WsStatus.connected,
        connectedUrl: event.url,
        clearErrorMessage: true,
        logs: [...state.logs, '[system] Connected: ${event.url}'],
      ),
    );
  }

  void _onBinaryDataArrived(WsBinaryDataArrived event, Emitter<WsState> emit) {
    final record = WsBinaryRecord(
      bytes: event.bytes,
      receivedAt: event.receivedAt,
      sourceType: event.sourceType,
    );

    emit(
      state.copyWith(
        latestRecord: record,
        history: [...state.history, record],
        logs: [
          ...state.logs,
          '[recv][${event.sourceType}] ${_formatBytes(event.bytes)}',
        ],
      ),
    );
  }

  void _onSocketError(WsSocketError event, Emitter<WsState> emit) {
    emit(
      state.copyWith(
        status: WsStatus.error,
        errorMessage: event.errorMessage,
        logs: [...state.logs, '[error] ${event.errorMessage}'],
      ),
    );
  }

  void _onRepositoryEvent(WsRepositoryEvent event) {
    if (event is WsRepositoryConnected) {
      add(WsConnected(event.url));
      return;
    }

    if (event is WsRepositoryBinaryMessage) {
      add(
        WsBinaryDataArrived(
          bytes: event.bytes,
          receivedAt: event.receivedAt,
          sourceType: event.sourceType,
        ),
      );
      return;
    }

    if (event is WsRepositoryDisconnected) {
      add(
        WsDisconnectRequested(
          fromServer: event.fromServer,
          reason: event.reason,
        ),
      );
      return;
    }

    if (event is WsRepositoryError) {
      add(WsSocketError(event.message));
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await _repository.dispose();
    return super.close();
  }

  String _formatBytes(Uint8List bytes) {
    final hex = bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join(' ');
    final utf8Text = utf8.decode(bytes, allowMalformed: true);
    return 'hex=$hex text=${jsonEncode(utf8Text)}';
  }
}
