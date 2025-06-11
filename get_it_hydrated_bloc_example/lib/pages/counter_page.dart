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
  late final CounterService _counterService;

  @override
  void initState() {
    super.initState();
    _counterService = getIt<CounterService>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CounterBloc>(),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<void>(
                stream: Stream.periodic(const Duration(milliseconds: 100)),
                builder: (context, snapshot) {
                  // Check global counter and navigate if it equals 3
                  if (_counterService.count == 3) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go(RouterEnum.helloWorldView.routeName);
                    });
                  }

                  return Column(
                    children: [
                      Text(
                        'Global Counter: ${_counterService.count}',
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
                  );
                },
              ),
              const SizedBox(height: 30),
              BlocConsumer<CounterBloc, CounterState>(
                listener: (context, state) {
                  // Listen for HydratedBloc counter reaching 3
                  if (state.count == 3) {
                    context.go(RouterEnum.helloWorldView.routeName);
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
          ),
        ),
      ),
    );
  }
}
