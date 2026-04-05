import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider =
AsyncNotifierProvider<CounterNotifier, int>(() => CounterNotifier());

class CounterNotifier extends AsyncNotifier<int> {
  late int num;

  // do make this, make it inside build() method
  // CounterNotifier() {
  //   _initializeCounter();
  // }

  @override
  FutureOr<int> build() async {
    await _initializeCounter();
    return num;
  }

  Future<void> _initializeCounter() async {
    num = 0;
    state = AsyncData(num);
  }

  Future<void> refreshCounter() async {
    state = AsyncValue.data(num++);

    // not work neither
    // ref.refresh(counterProvider);
    // ref.invalidate(counterProvider);
  }
}

void main() {
  runApp(ProviderScope(
      child: MaterialApp(
        home: MyApp(),
  )));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Async Counter Example'),
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final asyncValue = ref.watch(counterProvider);
            return asyncValue.when(
              loading: () => CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
              data: (counter) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Counter Value: $counter'),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(counterProvider.notifier).refreshCounter();
                      },
                      child: Text('Refresh Counter'),
                    ),
                  ],
                );
            });
          },
        ),
      ),
    );
  }
}
