import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../services/di_service.dart';
import '../bloc/counter_service_bloc.dart';
import '../widgets/counter_display.dart';
import '../widgets/counter_buttons.dart';
import '../enums/router_enum.dart';

class DIPage extends StatelessWidget {
  const DIPage({super.key});

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
                context.go(
                  '${RouterEnum.helloWorldView.routeName}?reset=service',
                );
              }
            },
            builder: (context, state) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CounterDisplay(
                  title: 'Global Counter (HydratedBloc)',
                  count: state.count,
                  subtitle:
                      '💾 Persists across restarts!\nRedirects at count 3',
                ),
                const SizedBox(height: 40),
                CounterButtons(
                  onIncrement: () => context.read<CounterServiceBloc>().add(
                    CounterServiceIncrement(),
                  ),
                  onDecrement: () => context.read<CounterServiceBloc>().add(
                    CounterServiceDecrement(),
                  ),
                  onReset: () => context.read<CounterServiceBloc>().add(
                    CounterServiceReset(),
                  ),
                ),
                const SizedBox(height: 40),
                _buildNavigationButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => context.go(RouterEnum.counterView.routeName),
          child: const Text('Counter BLoC'),
        ),
        ElevatedButton(
          onPressed: () => context.go(RouterEnum.helloWorldView.routeName),
          child: const Text('Hello World'),
        ),
      ],
    );
  }
}
