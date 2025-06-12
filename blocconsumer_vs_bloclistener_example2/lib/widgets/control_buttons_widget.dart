import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/orders_bloc.dart';
import '../events/orders_events.dart';

class ControlButtonsWidget extends StatelessWidget {
  const ControlButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () =>
                  context.read<OrdersBloc>().add(OrderRequested()),
              child: const Text('Request Order'),
            ),
            ElevatedButton(
              onPressed: () =>
                  context.read<OrdersBloc>().add(OrderInProgress()),
              child: const Text('In Progress'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () =>
                  context.read<OrdersBloc>().add(OrderCompleted()),
              child: const Text('Complete Order'),
            ),
            ElevatedButton(
              onPressed: () =>
                  context.read<OrdersBloc>().add(OrderRefunded('12345')),
              child: const Text('Refund Order'),
            ),
          ],
        ),
      ],
    );
  }
}
