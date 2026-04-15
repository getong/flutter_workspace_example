import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/news_repository.dart';
import '../models/news_connection_status.dart';
import '../models/news_socket_message.dart';
import '../models/news_socket_update.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc({required NewsRepository repository, required String initialUrl})
    : _repository = repository,
      super(NewsState.initial(initialUrl: initialUrl)) {
    on<NewsConnectRequested>(_onConnectRequested);
    on<NewsDisconnectRequested>(_onDisconnectRequested);
    on<NewsMessageSubmitted>(_onMessageSubmitted);
    on<_NewsSocketStatusReceived>(_onSocketStatusReceived);
    on<_NewsSocketMessageReceived>(_onSocketMessageReceived);
    on<_NewsSocketErrorReceived>(_onSocketErrorReceived);

    _updatesSubscription = _repository.updates.listen((update) {
      switch (update.type) {
        case NewsSocketUpdateType.status:
          add(_NewsSocketStatusReceived(update.status!));
          break;
        case NewsSocketUpdateType.message:
          add(_NewsSocketMessageReceived(update.message!));
          break;
        case NewsSocketUpdateType.error:
          add(_NewsSocketErrorReceived(update.errorMessage!));
          break;
      }
    });
  }

  final NewsRepository _repository;
  late final StreamSubscription<NewsSocketUpdate> _updatesSubscription;

  Future<void> _onConnectRequested(
    NewsConnectRequested event,
    Emitter<NewsState> emit,
  ) async {
    final url = event.url.trim();
    if (url.isEmpty) {
      emit(
        state.copyWith(
          connectionStatus: NewsConnectionStatus.error,
          errorMessage: 'WebSocket URL is required.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        currentUrl: url,
        connectionStatus: NewsConnectionStatus.connecting,
        clearError: true,
      ),
    );

    try {
      await _repository.connect(url);
    } catch (error) {
      emit(
        state.copyWith(
          connectionStatus: NewsConnectionStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onDisconnectRequested(
    NewsDisconnectRequested event,
    Emitter<NewsState> emit,
  ) async {
    try {
      await _repository.disconnect();
    } catch (error) {
      emit(
        state.copyWith(
          connectionStatus: NewsConnectionStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onMessageSubmitted(
    NewsMessageSubmitted event,
    Emitter<NewsState> emit,
  ) async {
    final message = event.message.trim();
    if (message.isEmpty) {
      emit(state.copyWith(errorMessage: 'Message cannot be empty.'));
      return;
    }

    try {
      await _repository.sendMessage(message);
      emit(state.copyWith(clearError: true));
    } catch (error) {
      emit(
        state.copyWith(
          connectionStatus: NewsConnectionStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onSocketStatusReceived(
    _NewsSocketStatusReceived event,
    Emitter<NewsState> emit,
  ) {
    emit(
      state.copyWith(
        connectionStatus: event.status,
        clearError: event.status != NewsConnectionStatus.error,
      ),
    );
  }

  void _onSocketMessageReceived(
    _NewsSocketMessageReceived event,
    Emitter<NewsState> emit,
  ) {
    emit(
      state.copyWith(
        messages: [...state.messages, event.message],
        clearError: true,
      ),
    );
  }

  void _onSocketErrorReceived(
    _NewsSocketErrorReceived event,
    Emitter<NewsState> emit,
  ) {
    emit(
      state.copyWith(
        connectionStatus: NewsConnectionStatus.error,
        errorMessage: event.error,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _updatesSubscription.cancel();
    await _repository.dispose();
    return super.close();
  }
}
