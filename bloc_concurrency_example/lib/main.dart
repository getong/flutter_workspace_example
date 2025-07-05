import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Concurrency Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ConcurrencyExamplePage(),
    );
  }
}

class ConcurrencyExamplePage extends StatelessWidget {
  const ConcurrencyExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bloc Concurrency Examples'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Concurrent'),
              Tab(text: 'Sequential'),
              Tab(text: 'Droppable'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (context) => CounterBloc(),
              child: const ConcurrentCounterView(),
            ),
            BlocProvider(
              create: (context) => SequentialCounterBloc(),
              child: const SequentialCounterView(),
            ),
            BlocProvider(
              create: (context) => DroppableCounterBloc(),
              child: const DroppableCounterView(),
            ),
          ],
        ),
      ),
    );
  }
}

class ConcurrentCounterView extends StatelessWidget {
  const ConcurrentCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        return _buildCounterView(
          context,
          state,
          'Concurrent',
          'Events are processed concurrently. Try tapping + or - multiple times quickly.',
          (event) => context.read<CounterBloc>().add(event),
        );
      },
    );
  }
}

class SequentialCounterView extends StatelessWidget {
  const SequentialCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SequentialCounterBloc, CounterState>(
      builder: (context, state) {
        return _buildCounterView(
          context,
          state,
          'Sequential',
          'Events are processed one at a time in order. Each event waits for the previous to complete.',
          (event) => context.read<SequentialCounterBloc>().add(event),
        );
      },
    );
  }
}

class DroppableCounterView extends StatelessWidget {
  const DroppableCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DroppableCounterBloc, CounterState>(
      builder: (context, state) {
        return _buildCounterView(
          context,
          state,
          'Droppable',
          'New events are ignored while processing. Try tapping multiple times during loading.',
          (event) => context.read<DroppableCounterBloc>().add(event),
        );
      },
    );
  }
}

Widget _buildCounterView(
  BuildContext context,
  CounterState state,
  String title,
  String description,
  Function(CounterEvent) onAddEvent,
) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$title Transformer',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        if (state.isLoading)
          const CircularProgressIndicator()
        else
          Text(
            'Count: ${state.count}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      onAddEvent(CounterDecremented());
                    },
              child: const Text('-'),
            ),
            ElevatedButton(
              onPressed: () {
                onAddEvent(CounterReset());
              },
              child: const Text('Reset'),
            ),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      onAddEvent(CounterIncremented());
                    },
              child: const Text('+'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
