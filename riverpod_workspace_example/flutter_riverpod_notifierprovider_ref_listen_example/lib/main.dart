import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = NotifierProvider<CounterNotifier, int>(() {
  return CounterNotifier();
});

class CounterNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state = state + 1;
  }
}

class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(counterProvider, (previous, current) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('the previous value is ${previous}')),
      );
    });

    final counter = ref.watch(counterProvider);
    return ElevatedButton(
        // use the value
        child: Text('Value: $counter'),
        // change the state inside a button callback
        onPressed: () => ref.read(counterProvider.notifier).increment());
  }
}

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Riverpod Notifier Button Example'),
        ),
        body: Center(
          child: CounterWidget(),
        ),
      ),
    );
  }
}
