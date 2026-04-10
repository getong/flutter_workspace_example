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
