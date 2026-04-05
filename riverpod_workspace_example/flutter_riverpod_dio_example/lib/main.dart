import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final apiProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response =
      await dio.get('https://serpapi.com/search.json?engine=baidu&q=Coffee');
  final data = response.data['organic_results'];
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
          child: Consumer(
            builder: (context, ref, child) {
              final asyncValue = ref.watch(apiProvider);
              return asyncValue.when(
                data: (data) => ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    // print("data[index]: ${data[index]}");
                    return ListTile(
                      title: Text(data[index]['position'].toString()),
                      subtitle: Text(data[index]['title']),
                      // trailing: Text(data[index]['title']),
                    );
                  },
                ),
                loading: () => CircularProgressIndicator(),
                error: (error, stackTrace) => Text('Error: $error'),
              );
            },
          ),
        ),
      ),
    );
  }
}
