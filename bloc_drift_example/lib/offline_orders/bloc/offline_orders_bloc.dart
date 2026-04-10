import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_drift_example/offline_orders/bloc/offline_orders_event.dart';
import 'package:bloc_drift_example/offline_orders/bloc/offline_orders_state.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_repository.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_snapshot_cache.dart';

class OfflineOrdersBloc extends Bloc<OfflineOrdersEvent, OfflineOrdersState> {
  OfflineOrdersBloc({
    required OfflineOrdersRepository repository,
    required OfflineOrdersSnapshotCache snapshotCache,
  }) : _repository = repository,
       _snapshotCache = snapshotCache,
       super(const OfflineOrdersState()) {
    on<OfflineOrdersStarted>(_onStarted);
    on<OfflineOrdersConnectivityChanged>(_onConnectivityChanged);
    on<OfflineOrderSubmitted>(_onOrderSubmitted);
    on<OfflineOrdersSyncRequested>(_onSyncRequested);
    on<OfflineOrdersDataUpdated>(_onOrdersUpdated);
    on<OfflineOrdersSyncQueueUpdated>(_onSyncQueueUpdated);
  }

  final OfflineOrdersRepository _repository;
  final OfflineOrdersSnapshotCache _snapshotCache;
  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<dynamic>? _ordersSubscription;
  StreamSubscription<dynamic>? _queueSubscription;

  Future<void> _onStarted(
    OfflineOrdersStarted event,
    Emitter<OfflineOrdersState> emit,
  ) async {
    emit(state.copyWith(status: OfflineOrdersStatus.loading, clearError: true));

    // Load cached snapshot for instant UI while Drift warms up.
    final snapshot = await _snapshotCache.loadSnapshot();
    if (snapshot.hasData) {
      emit(state.copyWith(orders: snapshot.orders, syncQueue: snapshot.queue));
    }

    // Subscribe to connectivity.
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = _repository.connectivityChanges.listen(
      (isOnline) => add(OfflineOrdersConnectivityChanged(isOnline)),
    );

    // Subscribe to Drift streams — data flows into BLoC state.
    await _ordersSubscription?.cancel();
    _ordersSubscription = _repository.watchOrders().listen(
      (orders) => add(OfflineOrdersDataUpdated(orders)),
    );

    await _queueSubscription?.cancel();
    _queueSubscription = _repository.watchSyncQueue().listen(
      (queue) => add(OfflineOrdersSyncQueueUpdated(queue)),
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

  void _onOrdersUpdated(
    OfflineOrdersDataUpdated event,
    Emitter<OfflineOrdersState> emit,
  ) {
    emit(state.copyWith(orders: event.orders));
    _snapshotCache.saveOrdersDebounced(event.orders);
  }

  void _onSyncQueueUpdated(
    OfflineOrdersSyncQueueUpdated event,
    Emitter<OfflineOrdersState> emit,
  ) {
    emit(state.copyWith(syncQueue: event.queue));
    _snapshotCache.saveQueueDebounced(event.queue);
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
      emit(state.copyWith(isSaving: false, errorMessage: error.toString()));
    }
  }

  Future<void> _onSyncRequested(
    OfflineOrdersSyncRequested event,
    Emitter<OfflineOrdersState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true, clearError: true, clearMessage: true));

    try {
      final result = await _repository.syncPendingOrders();
      emit(state.copyWith(isSyncing: false, message: result.message));
    } on Exception catch (error) {
      emit(state.copyWith(isSyncing: false, errorMessage: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    await _ordersSubscription?.cancel();
    await _queueSubscription?.cancel();
    // Flush snapshot cache with latest state before closing.
    await _snapshotCache.flush(state.orders, state.syncQueue);
    _snapshotCache.dispose();
    return super.close();
  }
}
