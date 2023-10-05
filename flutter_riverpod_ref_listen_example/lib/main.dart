import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter_riverpod ref.listen Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyWidget(),
    );
  }
}

final counterProvider = StateProvider<int>((ref) => 0);

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var out_prev;
    // var out_next;
    ref.listen(counterProvider, (prev, next) {
        // Text('The counter changed is now: $next');
        print("prev is $prev, next $next");
        // out_prev = prev;
        // out_next = next;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Riverpod Example'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('The counter is now: ${ref.watch(counterProvider)}'),
            // the out_prev, out_next is null
            // Text('The counter before is now: $out_prev, $out_next }'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterProvider.notifier).state++;
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
