import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../enums/router_enum.dart';
import '../services/di_service.dart';

class HelloWorldPage extends StatefulWidget {
  const HelloWorldPage({super.key});

  @override
  State<HelloWorldPage> createState() => _HelloWorldPageState();
}

class _HelloWorldPageState extends State<HelloWorldPage> {
  @override
  void initState() {
    super.initState();
    // Reset the counter when entering this page to prevent auto-redirect loop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<CounterServiceBloc>().add(CounterServiceReset());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CounterServiceBloc>(),
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
              BlocBuilder<CounterServiceBloc, CounterServiceState>(
                builder: (context, state) {
                  return Text(
                    'Counter was reset to: ${state.count}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
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
}
