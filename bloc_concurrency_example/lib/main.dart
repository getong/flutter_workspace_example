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
        useMaterial3: true,
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
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bloc Event Transformers'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Concurrent'),
              Tab(text: 'Sequential'),
              Tab(text: 'Droppable'),
              Tab(text: 'Restartable'),
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
            BlocProvider(
              create: (context) => RestartableCounterBloc(),
              child: const RestartableCounterView(),
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
          'Events are processed concurrently. Multiple events can run at the same time.',
          Colors.green,
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
          Colors.blue,
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
          'New events are ignored while processing. Try rapid tapping during loading.',
          Colors.orange,
          (event) => context.read<DroppableCounterBloc>().add(event),
        );
      },
    );
  }
}

class RestartableCounterView extends StatelessWidget {
  const RestartableCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestartableCounterBloc, CounterState>(
      builder: (context, state) {
        return _buildCounterView(
          context,
          state,
          'Restartable',
          'New events cancel and restart the current operation. Latest event wins.',
          Colors.red,
          (event) => context.read<RestartableCounterBloc>().add(event),
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
  Color accentColor,
  Function(CounterEvent) onAddEvent,
) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Card
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$title Transformer',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Counter Display
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.isLoading) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      'Count: ${state.count}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: state.isLoading ? Colors.grey : accentColor,
                          ),
                    ),
                  ],
                ),
                if (state.pendingOperations > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Pending Operations: ${state.pendingOperations}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Action Buttons
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: state.isLoading && title != 'Concurrent'
                          ? null
                          : () {
                              onAddEvent(CounterIncremented());
                            },
                      icon: const Icon(Icons.add),
                      label: const Text('+1'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor.withOpacity(0.1),
                        foregroundColor: accentColor,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: state.isLoading && title != 'Concurrent'
                          ? null
                          : () {
                              onAddEvent(CounterDecremented());
                            },
                      icon: const Icon(Icons.remove),
                      label: const Text('-1'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor.withOpacity(0.1),
                        foregroundColor: accentColor,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: state.isLoading && title != 'Concurrent'
                          ? null
                          : () {
                              onAddEvent(CounterMultiplied(2));
                            },
                      icon: const Icon(Icons.close),
                      label: const Text('×2'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor.withOpacity(0.1),
                        foregroundColor: accentColor,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: state.isLoading && title != 'Concurrent'
                          ? null
                          : () {
                              onAddEvent(CounterBatchIncrement(5));
                            },
                      icon: const Icon(Icons.playlist_add),
                      label: const Text('Batch +5'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor.withOpacity(0.1),
                        foregroundColor: accentColor,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        onAddEvent(CounterReset());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.1),
                        foregroundColor: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Operations Log
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Operations Log',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (state.operations.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          onAddEvent(CounterReset());
                        },
                        child: const Text('Clear'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: state.operations.isEmpty
                      ? Center(
                          child: Text(
                            'No operations yet.\nTap buttons above to see transformer behavior.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: state.operations.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            final operation = state.operations[
                                state.operations.length - 1 - index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                operation,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Info Card
        Card(
          color: accentColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: accentColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tips',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getTips(title),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

String _getTips(String title) {
  switch (title) {
    case 'Concurrent':
      return '• Try rapid tapping +1 and -1 buttons\n• Notice multiple operations running simultaneously\n• Pending operations counter shows concurrent executions';
    case 'Sequential':
      return '• Try rapid tapping - events will queue up\n• Each operation waits for the previous to complete\n• Perfect for operations that must be ordered';
    case 'Droppable':
      return '• Try rapid tapping during loading\n• Only the first event is processed\n• Subsequent events are ignored until completion';
    case 'Restartable':
      return '• Try rapid tapping during loading\n• New events cancel and restart current operation\n• Only the latest event completes';
    default:
      return '';
  }
}
