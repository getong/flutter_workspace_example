import 'package:bloc_drift_example/offline_orders/data/offline_order_item.dart';
import 'package:bloc_drift_example/offline_orders/data/sync_queue_item.dart';
import 'package:equatable/equatable.dart';

enum OfflineOrdersStatus { initial, loading, ready, failure }

class OfflineOrdersState extends Equatable {
  const OfflineOrdersState({
    this.status = OfflineOrdersStatus.initial,
    this.isOnline = false,
    this.isSaving = false,
    this.isSyncing = false,
    this.orders = const [],
    this.syncQueue = const [],
    this.message,
    this.errorMessage,
  });

  final OfflineOrdersStatus status;
  final bool isOnline;
  final bool isSaving;
  final bool isSyncing;
  final List<OfflineOrderItem> orders;
  final List<SyncQueueItem> syncQueue;
  final String? message;
  final String? errorMessage;

  bool get isBusy =>
      status == OfflineOrdersStatus.loading || isSaving || isSyncing;

  OfflineOrdersState copyWith({
    OfflineOrdersStatus? status,
    bool? isOnline,
    bool? isSaving,
    bool? isSyncing,
    List<OfflineOrderItem>? orders,
    List<SyncQueueItem>? syncQueue,
    String? message,
    String? errorMessage,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return OfflineOrdersState(
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      isSaving: isSaving ?? this.isSaving,
      isSyncing: isSyncing ?? this.isSyncing,
      orders: orders ?? this.orders,
      syncQueue: syncQueue ?? this.syncQueue,
      message: clearMessage ? null : (message ?? this.message),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    isOnline,
    isSaving,
    isSyncing,
    orders,
    syncQueue,
    message,
    errorMessage,
  ];
}
