import 'package:flutter_bloc/flutter_bloc.dart';
import '../events/orders_events.dart';
import '../states/orders_states.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrderInitial()) {
    on<OrderRequested>((event, emit) => emit(OrderRequestedState()));
    on<OrderInProgress>((event, emit) => emit(OrderInProgressState()));
    on<OrderCompleted>((event, emit) => emit(OrderCompletedState()));
    on<OrderRefunded>((event, emit) => emit(OrderRefundedState(event.orderId)));
  }
}
