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

  @override
  List<Object> get props => [id, customerName, total, isSynced, createdAt];
}
