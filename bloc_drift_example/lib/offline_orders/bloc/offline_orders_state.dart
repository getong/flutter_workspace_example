import 'package:bloc_drift_example/offline_orders/data/offline_order_item.dart';
import 'package:bloc_drift_example/offline_orders/data/sync_queue_item.dart';
import 'package:equatable/equatable.dart';

enum OfflineOrdersStatus { initial, loading, ready, failure }

class OfflineOrdersState extends Equatable {
  const OfflineOrdersState({
    this.status = OfflineOrdersStatus.initial,
    this.orders = const [],
    this.queue = const [],
    this.isOnline = false,
    this.isSaving = false,
    this.isSyncing = false,
    this.message,
    this.errorMessage,
  });

  final OfflineOrdersStatus status;
  final List<OfflineOrderItem> orders;
  final List<SyncQueueItem> queue;
  final bool isOnline;
  final bool isSaving;
  final bool isSyncing;
  final String? message;
  final String? errorMessage;

  int get pendingCount => queue.length;
  bool get isBusy =>
      status == OfflineOrdersStatus.loading || isSaving || isSyncing;

  OfflineOrdersState copyWith({
    OfflineOrdersStatus? status,
    List<OfflineOrderItem>? orders,
    List<SyncQueueItem>? queue,
    bool? isOnline,
    bool? isSaving,
    bool? isSyncing,
    String? message,
    String? errorMessage,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return OfflineOrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      queue: queue ?? this.queue,
      isOnline: isOnline ?? this.isOnline,
      isSaving: isSaving ?? this.isSaving,
      isSyncing: isSyncing ?? this.isSyncing,
      message: clearMessage ? null : (message ?? this.message),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    orders,
    queue,
    isOnline,
    isSaving,
    isSyncing,
    message,
    errorMessage,
  ];
}
