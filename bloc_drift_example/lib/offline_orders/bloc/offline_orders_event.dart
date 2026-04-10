import 'package:bloc_drift_example/offline_orders/data/offline_order_item.dart';
import 'package:bloc_drift_example/offline_orders/data/sync_queue_item.dart';
import 'package:equatable/equatable.dart';

sealed class OfflineOrdersEvent extends Equatable {
  const OfflineOrdersEvent();

  @override
  List<Object?> get props => [];
}

final class OfflineOrdersStarted extends OfflineOrdersEvent {
  const OfflineOrdersStarted();
}

final class OfflineOrdersConnectivityChanged extends OfflineOrdersEvent {
  const OfflineOrdersConnectivityChanged(this.isOnline);

  final bool isOnline;

  @override
  List<Object> get props => [isOnline];
}

final class OfflineOrderSubmitted extends OfflineOrdersEvent {
  const OfflineOrderSubmitted({
    required this.customerName,
    required this.total,
  });

  final String customerName;
  final double total;

  @override
  List<Object> get props => [customerName, total];
}

final class OfflineOrdersSyncRequested extends OfflineOrdersEvent {
  const OfflineOrdersSyncRequested();
}

/// Internal: emitted when Drift orders stream pushes new data.
final class OfflineOrdersDataUpdated extends OfflineOrdersEvent {
  const OfflineOrdersDataUpdated(this.orders);

  final List<OfflineOrderItem> orders;

  @override
  List<Object> get props => [orders];
}

/// Internal: emitted when Drift sync queue stream pushes new data.
final class OfflineOrdersSyncQueueUpdated extends OfflineOrdersEvent {
  const OfflineOrdersSyncQueueUpdated(this.queue);

  final List<SyncQueueItem> queue;

  @override
  List<Object> get props => [queue];
}
