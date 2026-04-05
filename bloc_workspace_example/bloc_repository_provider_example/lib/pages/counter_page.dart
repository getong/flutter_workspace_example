import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/counter_bloc.dart';
import '../repositories/counter_repository.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(
        repository: RepositoryProvider.of<CounterRepository>(context),
      )..add(CounterLoadRequested()),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('BLoC Repository Provider Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                if (state is CounterLoading) {
                  return const CircularProgressIndicator();
                } else if (state is CounterLoaded) {
                  return Text(
                    '${state.counter.value}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                } else if (state is CounterError) {
                  return Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const Text('Initial State');
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: "decrement_fab",
                  onPressed: () => context.read<CounterBloc>().add(
                        CounterDecrementRequested(),
                      ),
                  tooltip: 'Decrement',
                  child: const Icon(Icons.remove),
                ),
                FloatingActionButton(
                  heroTag: "reset_fab",
                  onPressed: () =>
                      context.read<CounterBloc>().add(CounterResetRequested()),
                  tooltip: 'Reset',
                  child: const Icon(Icons.refresh),
                ),
                FloatingActionButton(
                  heroTag: "increment_fab",
                  onPressed: () => context.read<CounterBloc>().add(
                        CounterIncrementRequested(),
                      ),
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
