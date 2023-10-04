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

final FutureProvider<String> helloProvider = FutureProvider((ref) {
  return Future.delayed(Duration(seconds: 1), () => 'Hello');
});

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final AsyncValue<String> asyncHello = ref.watch(helloProvider);
    // return Scaffold(
    //   body: Center(
    //       child: asyncHello.when(
    //     data: (String value) => Text(value),
    //     loading: () => CircularProgressIndicator(),
    //     error: (e, stackTrace) => Text(e.toString()),
    //   )),
    // );

    // or like this:
    final AsyncValue<String> asyncHello = ref.watch(helloProvider);
    final String? value = asyncHello.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_riverpod futreprovider example'),
      ),
      body: Center(
        child: Text(value ?? 'Loading'),
      ),
    );
  }
}
