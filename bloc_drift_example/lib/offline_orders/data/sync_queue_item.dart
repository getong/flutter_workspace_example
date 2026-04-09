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

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) {
    return SyncQueueItem(
      operationId: json['operationId'] as String,
      orderId: json['orderId'] as String,
      customerName: json['customerName'] as String,
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      queuedAt: DateTime.parse(json['queuedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'operationId': operationId,
      'orderId': orderId,
      'customerName': customerName,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'queuedAt': queuedAt.toIso8601String(),
    };
  }

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
