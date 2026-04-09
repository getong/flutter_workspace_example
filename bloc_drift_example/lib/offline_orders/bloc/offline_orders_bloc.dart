import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_drift_example/offline_orders/bloc/offline_orders_event.dart';
import 'package:bloc_drift_example/offline_orders/bloc/offline_orders_state.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_order_item.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_repository.dart';
import 'package:bloc_drift_example/offline_orders/data/sync_queue_item.dart';

class OfflineOrdersBloc extends Bloc<OfflineOrdersEvent, OfflineOrdersState> {
  OfflineOrdersBloc({required OfflineOrdersRepository repository})
    : _repository = repository,
      super(const OfflineOrdersState()) {
    on<OfflineOrdersStarted>(_onStarted);
    on<OfflineOrdersChanged>(_onOrdersChanged);
    on<OfflineOrdersQueueChanged>(_onQueueChanged);
    on<OfflineOrdersConnectivityChanged>(_onConnectivityChanged);
    on<OfflineOrderSubmitted>(_onOrderSubmitted);
    on<OfflineOrdersSyncRequested>(_onSyncRequested);
  }

  final OfflineOrdersRepository _repository;
  StreamSubscription<List<OfflineOrderItem>>? _ordersSubscription;
  StreamSubscription<List<SyncQueueItem>>? _queueSubscription;
  StreamSubscription<bool>? _connectivitySubscription;

  Future<void> _onStarted(
    OfflineOrdersStarted event,
    Emitter<OfflineOrdersState> emit,
  ) async {
    emit(state.copyWith(status: OfflineOrdersStatus.loading, clearError: true));

    await _ordersSubscription?.cancel();
    await _queueSubscription?.cancel();
    await _connectivitySubscription?.cancel();

    final cachedSnapshot = await _repository.loadCachedSnapshot();
    if (cachedSnapshot.hasData) {
      emit(
        state.copyWith(
          status: OfflineOrdersStatus.ready,
          orders: cachedSnapshot.orders,
          queue: cachedSnapshot.queue,
          clearError: true,
          clearMessage: true,
        ),
      );
    }

    _ordersSubscription = _repository.watchOrders().listen(
      (orders) => add(OfflineOrdersChanged(orders)),
    );
    _queueSubscription = _repository.watchSyncQueue().listen(
      (queue) => add(OfflineOrdersQueueChanged(queue)),
    );
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

  void _onOrdersChanged(
    OfflineOrdersChanged event,
    Emitter<OfflineOrdersState> emit,
  ) {
    emit(
      state.copyWith(
        status: OfflineOrdersStatus.ready,
        orders: event.orders.cast<OfflineOrderItem>(),
      ),
    );
  }

  void _onQueueChanged(
    OfflineOrdersQueueChanged event,
    Emitter<OfflineOrdersState> emit,
  ) {
    emit(
      state.copyWith(
        status: OfflineOrdersStatus.ready,
        queue: event.queue.cast<SyncQueueItem>(),
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

    if (event.isOnline && wasOffline && state.pendingCount > 0) {
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
    await _ordersSubscription?.cancel();
    await _queueSubscription?.cancel();
    await _connectivitySubscription?.cancel();
    return super.close();
  }
}
