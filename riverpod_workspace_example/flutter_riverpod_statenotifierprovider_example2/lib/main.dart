import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() {
    state = state + 1;
  }
}

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

void main() {
  // Wrap the app with the ProviderScope widget
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Riverpod Counter Example'),
        ),
        body: Center(
          child: Consumer(
            builder: (context2, ref2, child) {
              final count = ref2.watch(counterProvider);
              return Text('Count: $count', style: TextStyle(fontSize: 24));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Access the CounterNotifier and call its increment method
            ref.read(counterProvider.notifier).increment();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
