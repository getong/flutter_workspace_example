import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_bloc.dart';
import 'counter_state.dart';
import 'counter_event.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'BlocConsumer Example:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            BlocConsumer<CounterBloc, CounterState>(
              listener: (context, state) {
                // 状态监听部分，触发一次性动作
                if (state.count % 5 == 0 && state.count > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("达到${state.count}的倍数了！")),
                  );
                }
              },
              builder: (context, state) {
                // 根据状态变化重建UI
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "当前计数：${state.count}",
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(IncrementEvent());
                      },
                      child: const Text("增加"),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            const Text(
              'BlocListener Example:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            BlocListener<CounterBloc, CounterState>(
              listener: (context, state) {
                // 每当状态变化，就会触发此处代码。
                if (state.count % 3 == 0 && state.count > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("BlocListener: 计数达到${state.count}！"),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  context.read<CounterBloc>().add(IncrementEvent());
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("增加 (仅监听)"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
