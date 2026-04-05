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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Example 1: Basic BlocBuilder
              SizedBox(
                height: 200,
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

              const SizedBox(height: 16),

              // Example 2: BlocConsumer - combines builder and listener
              SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('BlocConsumer (Builder + Listener):'),
                      const SizedBox(height: 8),
                      BlocConsumer<CounterBloc, int>(
                        listener: (context, count) {
                          // Listen for specific values and show alerts
                          if (count == 5) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('BlocConsumer Alert!'),
                                content: const Text('Counter reached 5!'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        builder: (context, count) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: count > 0
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: count > 0 ? Colors.green : Colors.red,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Count: $count',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: count > 0
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                ),
                                Text(
                                  count > 0
                                      ? 'Positive'
                                      : count < 0
                                          ? 'Negative'
                                          : 'Zero',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Example 3: BlocConsumer with conditions
              SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('BlocConsumer with buildWhen/listenWhen:'),
                      const SizedBox(height: 8),
                      BlocConsumer<CounterBloc, int>(
                        listenWhen: (previous, current) =>
                            current % 3 == 0 && current != 0,
                        listener: (context, count) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Multiple of 3: $count'),
                              backgroundColor: Colors.purple,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        buildWhen: (previous, current) =>
                            (current - previous).abs() >= 1,
                        builder: (context, count) {
                          final radius = (40 + (count.abs() * 2).toDouble())
                              .clamp(0.0, 60.0);
                          return CircleAvatar(
                            radius: radius,
                            backgroundColor:
                                count.isEven ? Colors.blue : Colors.orange,
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Example 4: BlocConsumer with theme integration
              SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('BlocConsumer with Theme Integration:'),
                      const SizedBox(height: 8),
                      BlocConsumer<CounterBloc, int>(
                        listener: (context, count) {
                          // Auto-toggle theme at certain counts
                          if (count == 8 || count == -8) {
                            context.read<ThemeCubit>().toggleTheme();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Auto-toggled theme at count $count!'),
                                backgroundColor: Colors.cyan,
                              ),
                            );
                          }
                        },
                        builder: (context, count) {
                          return BlocConsumer<ThemeCubit, ThemeState>(
                            listener: (context, themeState) {
                              // React to theme changes from counter
                              if (themeState.toggleCount > 0) {
                                debugPrint(
                                    'Theme toggled by counter interaction');
                              }
                            },
                            builder: (context, themeState) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: themeState.isDark
                                        ? [Colors.grey[800]!, Colors.grey[600]!]
                                        : [
                                            Colors.blue[100]!,
                                            Colors.blue[300]!
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Counter: $count',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: themeState.isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Theme: ${themeState.isDark ? 'Dark' : 'Light'}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: themeState.isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Example 5: BlocBuilder with buildWhen condition (from original)
              SizedBox(
                height: 150,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'BlocBuilder with buildWhen (only even numbers):'),
                      const SizedBox(height: 8),
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

              // Example: Sink usage demonstration
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sink Usage Examples:'),
                      const SizedBox(height: 8),
                      BlocBuilder<CounterBloc, int>(
                        builder: (context, count) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.purple),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Sink Demo: $count',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.purple),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Using sink directly
                                        final bloc =
                                            context.read<CounterBloc>();
                                        bloc.eventSink.add(CounterSetValue(10));
                                      },
                                      child: const Text('Set 10'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Batch events using sink
                                        final bloc =
                                            context.read<CounterBloc>();
                                        bloc.addEventsBatch([
                                          CounterIncrementPressed(),
                                          CounterIncrementPressed(),
                                          CounterIncrementPressed(),
                                        ]);
                                      },
                                      child: const Text('+3 Batch'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<CounterBloc>()
                                            .startAutoIncrement();
                                      },
                                      child: const Text('Auto +'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<CounterBloc>()
                                            .stopAutoIncrement();
                                      },
                                      child: const Text('Stop'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                  height: 100), // Extra space for floating action buttons
            ],
          ),
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
