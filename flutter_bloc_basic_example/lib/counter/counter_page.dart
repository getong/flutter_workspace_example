import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_bloc.dart';
import '../theme/theme_cubit.dart';

/// {@template counter_page}
/// A [StatelessWidget] that:
/// * provides a [CounterBloc] to the [CounterView].
/// {@endtemplate}
class CounterPage extends StatelessWidget {
  /// {@macro counter_page}
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: const CounterView(),
    );
  }
}

/// {@template counter_view}
/// A [StatelessWidget] that:
/// * demonstrates how to consume and interact with a [CounterBloc].
/// * shows multiple BlocBuilder examples and patterns.
/// {@endtemplate}
class CounterView extends StatelessWidget {
  /// {@macro counter_view}
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CounterBloc, int>(
      // BlocListener example: Show snackbar on specific conditions
      listener: (context, count) {
        if (count == 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Congratulations! You reached 10!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (count == -5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Warning! Count is getting very low!'),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (count > 15) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('High count detected: $count'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Counter')),
        body: Column(
          children: [
            // Example 1: Basic BlocBuilder
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Basic BlocBuilder:'),
                    BlocBuilder<CounterBloc, int>(
                      builder: (context, count) {
                        return Text(
                          '$count',
                          style: Theme.of(context).textTheme.displayLarge,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Example 2: BlocBuilder with buildWhen condition
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        'BlocBuilder with buildWhen (only even numbers):'),
                    BlocBuilder<CounterBloc, int>(
                      buildWhen: (previous, current) => current % 2 == 0,
                      builder: (context, count) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Even: $count',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Example 3: BlocBuilder with conditional rendering and nested BlocListener
            Expanded(
              child: BlocListener<CounterBloc, int>(
                // Additional BlocListener with listenWhen condition
                listenWhen: (previous, current) =>
                    current % 5 == 0 && current != 0,
                listener: (context, count) {
                  // Show dialog for multiples of 5
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Multiple of 5!'),
                      content: Text('Current count: $count'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Conditional BlocBuilder:'),
                      BlocBuilder<CounterBloc, int>(
                        builder: (context, count) {
                          if (count > 10) {
                            return const Icon(
                              Icons.star,
                              size: 64,
                              color: Colors.amber,
                            );
                          } else if (count < 0) {
                            return const Icon(
                              Icons.warning,
                              size: 64,
                              color: Colors.red,
                            );
                          } else {
                            return CircularProgressIndicator(
                              value: count / 10,
                              backgroundColor: Colors.grey[300],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "increment",
              child: const Icon(Icons.add),
              onPressed: () {
                context.read<CounterBloc>().add(CounterIncrementPressed());
              },
            ),
            const SizedBox(height: 4),
            FloatingActionButton(
              heroTag: "decrement",
              child: const Icon(Icons.remove),
              onPressed: () {
                context.read<CounterBloc>().add(CounterDecrementPressed());
              },
            ),
            const SizedBox(height: 4),
            FloatingActionButton(
              heroTag: "theme",
              child: const Icon(Icons.brightness_6),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
