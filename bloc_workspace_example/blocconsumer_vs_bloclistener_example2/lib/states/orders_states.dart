abstract class OrdersState {}

class OrderInitial extends OrdersState {}

class OrderRequestedState extends OrdersState {}

class OrderInProgressState extends OrdersState {}

class OrderCompletedState extends OrdersState {}

class OrderRefundedState extends OrdersState {
  final String orderId;
  OrderRefundedState(this.orderId);
}
