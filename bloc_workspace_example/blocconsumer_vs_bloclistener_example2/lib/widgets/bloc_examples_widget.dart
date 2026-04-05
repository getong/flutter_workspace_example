import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/orders_bloc.dart';
import '../events/orders_events.dart';
import '../states/orders_states.dart';
import '../services/analytics.dart';

class BlocExamplesWidget extends StatelessWidget {
  const BlocExamplesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // BlocBuilder Example
        const Text(
          'BlocBuilder Example:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        BlocBuilder<OrdersBloc, OrdersState>(
          buildWhen: (previous, current) {
            return current is OrderCompletedState;
          },
          builder: (context, state) {
            if (state is OrderCompletedState) {
              return Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green[100],
                child: const Text('Order Completed!'),
              );
            } else if (state is OrderInProgressState) {
              return Container(
                padding: const EdgeInsets.all(8),
                color: Colors.yellow[100],
                child: const Text('In Progress'),
              );
            } else if (state is OrderRequestedState) {
              return Container(
                padding: const EdgeInsets.all(8),
                color: Colors.blue[100],
                child: const Text('A customer placed an order!'),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[100],
                child: const Text('Waiting for an order'),
              );
            }
          },
        ),

        const SizedBox(height: 20),

        // BlocListener Example
        const Text(
          'BlocListener Example:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        BlocListener<OrdersBloc, OrdersState>(
          listenWhen: (previous, current) {
            return current is OrderCompletedState;
          },
          listener: (context, state) {
            Navigator.of(context).pushNamed('OrderCompletedScreen');
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.purple[100],
            child: const Text('Always draw this text!'),
          ),
        ),

        const SizedBox(height: 20),

        // BlocConsumer Example
        const Text(
          'BlocConsumer Example:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        BlocConsumer<OrdersBloc, OrdersState>(
          listenWhen: (previous, current) {
            return current is OrderCompletedState ||
                current is OrderRefundedState;
          },
          listener: (context, state) {
            if (state is OrderCompletedState) {
              Navigator.of(context).pushNamed('OrderCompletedScreen');
            } else if (state is OrderRefundedState) {
              Analytics.reportRefunded(state.orderId);
            }
          },
          buildWhen: (previous, current) {
            return current is OrderCompletedState ||
                current is OrderInProgressState ||
                current is OrderRequestedState;
          },
          builder: (context, state) {
            if (state is OrderCompletedState) {
              return Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green[200],
                child: const Text('Order Served!'),
              );
            } else if (state is OrderInProgressState) {
              return Container(
                padding: const EdgeInsets.all(8),
                color: Colors.orange[200],
                child: const Text('In Progress'),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[200],
                child: const Text('No State'),
              );
            }
          },
        ),
      ],
    );
  }
}
