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
        title: 'flutter_riverpod futreprovider example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyWidget());
  }
}

final StreamProvider<int> countProvider = StreamProvider((ref) {
  return Stream.periodic(Duration(seconds: 1), (i) => i);
});

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<int> asyncCount = ref.watch(countProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_riverpod streamprovider example'),
      ),
      body: Center(
          child: asyncCount.when(
        data: (int value) => Text(value.toString()),
        loading: () => CircularProgressIndicator(),
        error: (e, stackTrace) => Text(e.toString()),
      )),
    );

    // // or like this:
    // final AsyncValue<String> asyncHello = ref.watch(helloProvider);
    // final String? value = asyncHello.value;

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('flutter_riverpod futreprovider example'),
    //   ),
    //   body: Center(
    //     child: Text(value ?? 'Loading'),
    //   ),
    // );
  }
}
