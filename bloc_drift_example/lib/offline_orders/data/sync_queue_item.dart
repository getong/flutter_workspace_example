import 'package:equatable/equatable.dart';

class SyncQueueItem extends Equatable {
  const SyncQueueItem({
    required this.operationId,
    required this.orderId,
    required this.customerName,
    required this.total,
    required this.createdAt,
    required this.queuedAt,
  });

  final String operationId;
  final String orderId;
  final String customerName;
  final double total;
  final DateTime createdAt;
  final DateTime queuedAt;

  @override
  List<Object> get props => [
    operationId,
    orderId,
    customerName,
    total,
    createdAt,
    queuedAt,
  ];
}
