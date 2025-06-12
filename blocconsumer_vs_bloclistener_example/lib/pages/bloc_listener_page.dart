import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/counter_bloc.dart';

class BlocListenerPage extends StatelessWidget {
  const BlocListenerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlocListener Example'),
        backgroundColor: Colors.orange.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              color: Colors.orange,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'BlocListener + BlocBuilder',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'BlocListener ONLY listens (no UI rebuild).\n'
                      'BlocBuilder ONLY builds UI.\n'
                      'They work separately but achieve the same result.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: BlocListener<CounterBloc, CounterState>(
                // Listener: ONLY handles side effects, does NOT rebuild UI
                listener: (context, state) {
                  if (state.message.isNotEmpty) {
                    // Show snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: state.count < 0
                            ? Colors.red
                            : Colors.orange,
                        duration: const Duration(seconds: 2),
                      ),
                    );

                    // Show dialog for special cases
                    if (state.count == 10) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Milestone Reached!'),
                          content: const Text('You reached 10! Great job!'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                // The child is built independently of the listener
                child: BlocBuilder<CounterBloc, CounterState>(
                  // Builder: ONLY rebuilds UI when state changes
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Current Count:',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: state.count < 0
                                ? Colors.red.shade100
                                : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: state.count < 0
                                  ? Colors.red
                                  : Colors.orange,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            '${state.count}',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: state.count < 0
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.count == 10
                              ? '🎉 You reached 10! 🎉'
                              : state.count > 10
                              ? '🚀 Beyond 10! 🚀'
                              : 'Keep going!',
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context.read<CounterBloc>().add(
                                  DecrementCounter(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Decrement'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<CounterBloc>().add(ResetCounter());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Reset'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<CounterBloc>().add(
                                  IncrementCounter(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Increment'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
