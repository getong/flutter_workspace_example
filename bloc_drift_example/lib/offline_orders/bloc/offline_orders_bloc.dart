import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_drift_example/offline_orders/bloc/offline_orders_event.dart';
import 'package:bloc_drift_example/offline_orders/bloc/offline_orders_state.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_repository.dart';

class OfflineOrdersBloc extends Bloc<OfflineOrdersEvent, OfflineOrdersState> {
  OfflineOrdersBloc({required OfflineOrdersRepository repository})
    : _repository = repository,
      super(const OfflineOrdersState()) {
    on<OfflineOrdersStarted>(_onStarted);
    on<OfflineOrdersConnectivityChanged>(_onConnectivityChanged);
    on<OfflineOrderSubmitted>(_onOrderSubmitted);
    on<OfflineOrdersSyncRequested>(_onSyncRequested);
  }

  final OfflineOrdersRepository _repository;
  StreamSubscription<bool>? _connectivitySubscription;

  Future<void> _onStarted(
    OfflineOrdersStarted event,
    Emitter<OfflineOrdersState> emit,
  ) async {
    emit(state.copyWith(status: OfflineOrdersStatus.loading, clearError: true));

    await _connectivitySubscription?.cancel();
    _connectivitySubscription = _repository.connectivityChanges.listen(
      (isOnline) => add(OfflineOrdersConnectivityChanged(isOnline)),
    );

    final isOnline = await _repository.isOnline;

    emit(
      state.copyWith(
        status: OfflineOrdersStatus.ready,
        isOnline: isOnline,
        clearMessage: true,
        clearError: true,
      ),
    );
  }

  Future<void> _onConnectivityChanged(
    OfflineOrdersConnectivityChanged event,
    Emitter<OfflineOrdersState> emit,
  ) async {
    final wasOffline = !state.isOnline;

    emit(
      state.copyWith(
        isOnline: event.isOnline,
        message: event.isOnline ? 'Connection restored.' : 'You are offline.',
        clearError: true,
      ),
    );

    if (event.isOnline &&
        wasOffline &&
        await _repository.hasPendingSyncOperations()) {
      add(const OfflineOrdersSyncRequested());
    }
  }

  Future<void> _onOrderSubmitted(
    OfflineOrderSubmitted event,
    Emitter<OfflineOrdersState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, clearError: true, clearMessage: true));

    try {
      final result = await _repository.createOrder(
        customerName: event.customerName,
        total: event.total,
      );
      emit(state.copyWith(isSaving: false, message: result.message));
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: OfflineOrdersStatus.failure,
          isSaving: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onSyncRequested(
    OfflineOrdersSyncRequested event,
    Emitter<OfflineOrdersState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true, clearError: true, clearMessage: true));

    try {
      final result = await _repository.syncPendingOrders();
      emit(
        state.copyWith(
          status: OfflineOrdersStatus.ready,
          isSyncing: false,
          message: result.message,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: OfflineOrdersStatus.failure,
          isSyncing: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    return super.close();
  }
}
