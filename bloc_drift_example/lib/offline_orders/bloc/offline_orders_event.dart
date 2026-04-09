import 'package:equatable/equatable.dart';

import '../data/offline_order_item.dart';
import '../data/sync_queue_item.dart';

sealed class OfflineOrdersEvent extends Equatable {
  const OfflineOrdersEvent();

  @override
  List<Object?> get props => [];
}

final class OfflineOrdersStarted extends OfflineOrdersEvent {
  const OfflineOrdersStarted();
}

final class OfflineOrdersChanged extends OfflineOrdersEvent {
  const OfflineOrdersChanged(this.orders);

  final List<OfflineOrderItem> orders;

  @override
  List<Object?> get props => [orders];
}

final class OfflineOrdersQueueChanged extends OfflineOrdersEvent {
  const OfflineOrdersQueueChanged(this.queue);

  final List<SyncQueueItem> queue;

  @override
  List<Object?> get props => [queue];
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
