import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final apiProvider = FutureProvider.autoDispose<List<String>>((ref) async {
    final dio = ref.watch(dioProvider);
    final response = await dio.get('https://www.baidu.com');
    print('reponse: $response');
    print("reponse end");
    final data = response.data['data'];
    print('data : $data');
    return List<String>.from(data);
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
      title: 'Riverpod Dio Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Riverpod Dio Example'),
        ),
        body: Center(
          child: Consumer(
            builder: (context, ref, child) {
              final asyncValue = ref.watch(apiProvider);
              return asyncValue.when(
                data: (data) => ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(data[index]),
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
