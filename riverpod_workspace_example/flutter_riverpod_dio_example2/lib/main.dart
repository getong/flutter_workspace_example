import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final apiProvider = FutureProvider.autoDispose<String>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('http://localhost:3000/hello?hello=world');
  final data = response.data;
  // print(data.runtimeType);
  return data;
});

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Dio Example by accessing serpapi.com',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Riverpod Dio Example by accessing serpapi.com'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Consumer(
              builder: (context, ref, child) {
                final asyncValue = ref.watch(apiProvider);
                return asyncValue.when(
                  data: (data) => Text(data),
                  loading: () => CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
