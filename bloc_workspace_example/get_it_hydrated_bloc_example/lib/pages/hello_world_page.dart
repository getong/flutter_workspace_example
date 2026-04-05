import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../enums/router_enum.dart';
import '../services/di_service.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_service_bloc.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _resetCounter());
  }

  void _resetCounter() {
    if (widget.resetCounter == 'service') {
      getIt<CounterServiceBloc>().add(CounterServiceReset());
    } else if (widget.resetCounter == 'bloc') {
      getIt<CounterBloc>().add(CounterReset());
    }
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
            onPressed: () => context.go(RouterEnum.homePage.routeName),
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
              const SizedBox(height: 40),
              _buildResetInfo(),
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

  Widget _buildResetInfo() {
    const style = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

    return switch (widget.resetCounter) {
      'service' => BlocBuilder<CounterServiceBloc, CounterServiceState>(
        builder: (context, state) => Text(
          'Service Counter reset to: ${state.count}',
          style: style.copyWith(color: Colors.green),
        ),
      ),
      'bloc' => BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) => Text(
          'BLoC Counter reset to: ${state.count}',
          style: style.copyWith(color: Colors.green),
        ),
      ),
      _ => Text(
        'No counter was reset',
        style: style.copyWith(color: Colors.blue),
      ),
    };
  }
}
