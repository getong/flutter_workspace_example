import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../enums/router_enum.dart';
import '../services/di_service.dart';
import '../bloc/counter_bloc.dart';

class HelloWorldPage extends StatefulWidget {
  final String resetCounter;

  const HelloWorldPage({super.key, this.resetCounter = 'none'});

  @override
  State<HelloWorldPage> createState() => _HelloWorldPageState();
}

class _HelloWorldPageState extends State<HelloWorldPage> {
  @override
  void initState() {
    super.initState();
    // Reset only the counter that triggered the navigation
    // Use getIt directly since BlocProvider context isn't available in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.resetCounter == 'service') {
        getIt<CounterServiceBloc>().add(CounterServiceReset());
      } else if (widget.resetCounter == 'bloc') {
        getIt<CounterBloc>().add(CounterReset());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CounterServiceBloc>()),
        BlocProvider.value(value: getIt<CounterBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hello World'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go(RouterEnum.initialLocation.routeName),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hello World!',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Flutter with BLoC!',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              _buildCounterResetInfo(),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.go(RouterEnum.counterView.routeName),
                child: const Text('Go to Counter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounterResetInfo() {
    if (widget.resetCounter == 'service') {
      return BlocBuilder<CounterServiceBloc, CounterServiceState>(
        builder: (context, state) {
          return Text(
            'Service Counter was reset to: ${state.count}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      );
    } else if (widget.resetCounter == 'bloc') {
      return BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          return Text(
            'BLoC Counter was reset to: ${state.count}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      );
    } else {
      return const Text(
        'No counter was reset',
        style: TextStyle(
          fontSize: 16,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
