import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../counter/counter_bloc.dart';
import '../counter/counter_event.dart';

class BlocConsumerExample extends StatelessWidget {
  const BlocConsumerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'BlocConsumer Example',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text('Counter value:'),
          BlocConsumer<CounterBloc, int>(
            listener: (context, state) {
              if (state == 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Counter reached 10!')),
                );
              } else if (state == -5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Counter reached -5!')),
                );
              }
            },
            builder: (context, state) {
              return Text(
                '$state',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: state > 5
                      ? Colors.green
                      : state < 0
                      ? Colors.red
                      : null,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () => context.read<CounterBloc>().add(Decrement()),
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              ),
              FloatingActionButton(
                onPressed: () => context.read<CounterBloc>().add(Increment()),
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
