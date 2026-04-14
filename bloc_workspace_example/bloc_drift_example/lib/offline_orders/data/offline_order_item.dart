import 'package:equatable/equatable.dart';

class OfflineOrderItem extends Equatable {
  const OfflineOrderItem({
    required this.id,
    required this.customerName,
    required this.total,
    required this.isSynced,
    required this.createdAt,
  });

  final String id;
  final String customerName;
  final double total;
  final bool isSynced;
  final DateTime createdAt;

  factory OfflineOrderItem.fromJson(Map<String, dynamic> json) {
    return OfflineOrderItem(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      total: (json['total'] as num).toDouble(),
      isSynced: json['isSynced'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'total': total,
      'isSynced': isSynced,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [id, customerName, total, isSynced, createdAt];
}
