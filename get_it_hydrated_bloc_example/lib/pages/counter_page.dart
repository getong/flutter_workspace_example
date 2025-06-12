import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/counter_bloc.dart';
import '../services/di_service.dart';
import '../enums/router_enum.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CounterBloc>()),
        BlocProvider.value(value: getIt<CounterServiceBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Counter with BLoC'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go(RouterEnum.initialLocation.routeName),
          ),
        ),
        body: Center(
          child: BlocConsumer<CounterServiceBloc, CounterServiceState>(
            listener: (context, state) {
              if (state.count == 3) {
                context.go(
                  '${RouterEnum.helloWorldView.routeName}?reset=service',
                );
              }
            },
            builder: (context, serviceState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Global Counter: ${serviceState.count}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'When global counter reaches 3, you\'ll be redirected!',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  BlocConsumer<CounterBloc, CounterState>(
                    listener: (context, state) {
                      if (state.count == 3) {
                        context.go(
                          '${RouterEnum.helloWorldView.routeName}?reset=bloc',
                        );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          const Text(
                            'HydratedBloc Counter Value:',
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${state.count}',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '💾 This counter persists across app restarts!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'When HydratedBloc counter reaches 3, you\'ll be redirected!',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  context.read<CounterBloc>().add(
                                    CounterDecrement(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                ),
                                child: const Text('- Minus One'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<CounterBloc>().add(
                                    CounterIncrement(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                ),
                                child: const Text('+ Add One'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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
