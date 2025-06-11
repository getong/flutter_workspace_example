import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../services/di_service.dart';
import '../enums/router_enum.dart';

class DIPage extends StatefulWidget {
  const DIPage({super.key});

  @override
  State<DIPage> createState() => _DIPageState();
}

class _DIPageState extends State<DIPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CounterServiceBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dependency Injection Demo'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: BlocConsumer<CounterServiceBloc, CounterServiceState>(
            listener: (context, state) {
              if (state.count == 3) {
                context.go(RouterEnum.helloWorldView.routeName);
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Global Counter (using HydratedBloc):',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${state.count}',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'When counter reaches 3, you\'ll be redirected to Hello World!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '💾 State persists across app restarts!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<CounterServiceBloc>().add(
                            CounterServiceDecrement(),
                          );
                        },
                        child: const Icon(Icons.remove),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CounterServiceBloc>().add(
                            CounterServiceReset(),
                          );
                        },
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CounterServiceBloc>().add(
                            CounterServiceIncrement(),
                          );
                        },
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    'Navigate to other pages:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.go(RouterEnum.counterView.routeName);
                        },
                        child: const Text('Counter BLoC'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.go(RouterEnum.helloWorldView.routeName);
                        },
                        child: const Text('Hello World'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
