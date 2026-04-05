import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_service_bloc.dart';
import '../bloc/page_counter_bloc.dart';
import '../services/di_service.dart';
import '../widgets/counter_display.dart';
import '../widgets/counter_buttons.dart';
import '../enums/router_enum.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CounterBloc>()),
        BlocProvider.value(value: getIt<CounterServiceBloc>()),
        BlocProvider(create: (context) => PageCounterBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Counter with BLoC'),
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
              _buildGlobalCounter(),
              const SizedBox(height: 30),
              _buildPageCounter(),
              const SizedBox(height: 30),
              _buildHydratedCounter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalCounter() {
    return BlocListener<CounterServiceBloc, CounterServiceState>(
      listener: (context, state) {
        if (state.count == 3) {
          context.go('${RouterEnum.helloWorldView.routeName}?reset=service');
        }
      },
      child: BlocBuilder<CounterServiceBloc, CounterServiceState>(
        builder: (context, state) => CounterDisplay(
          title: 'Global Counter',
          count: state.count,
          subtitle: 'Redirects at count 3',
          titleColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildPageCounter() {
    return BlocBuilder<PageCounterBloc, PageCounterState>(
      builder: (context, state) => Column(
        children: [
          CounterDisplay(
            title: 'Page Counter',
            count: state.count,
            subtitle: 'Only exists on this page',
            titleColor: Colors.purple,
          ),
          const SizedBox(height: 20),
          CounterButtons(
            onIncrement: () =>
                context.read<PageCounterBloc>().add(PageCounterIncrement()),
            onDecrement: () =>
                context.read<PageCounterBloc>().add(PageCounterDecrement()),
            onReset: () =>
                context.read<PageCounterBloc>().add(PageCounterReset()),
          ),
        ],
      ),
    );
  }

  Widget _buildHydratedCounter() {
    return BlocListener<CounterBloc, CounterState>(
      listener: (context, state) {
        if (state.count == 3) {
          context.go('${RouterEnum.helloWorldView.routeName}?reset=bloc');
        }
      },
      child: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) => Column(
          children: [
            CounterDisplay(
              title: 'HydratedBloc Counter',
              count: state.count,
              subtitle: '💾 Persists across restarts! Redirects at count 3',
            ),
            const SizedBox(height: 40),
            CounterButtons(
              onIncrement: () =>
                  context.read<CounterBloc>().add(CounterIncrement()),
              onDecrement: () =>
                  context.read<CounterBloc>().add(CounterDecrement()),
              showReset: false,
            ),
          ],
        ),
      ),
    );
  }
}
