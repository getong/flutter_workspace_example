abstract class OrdersEvent {}

class OrderRequested extends OrdersEvent {}

class OrderInProgress extends OrdersEvent {}

class OrderCompleted extends OrdersEvent {}

class OrderRefunded extends OrdersEvent {
  final String orderId;
  OrderRefunded(this.orderId);
}
