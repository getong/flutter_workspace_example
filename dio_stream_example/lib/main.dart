import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio();
    _dio.options.headers['Connection'] = 'keep-alive';
  }

  Future<dynamic> fetchData(String url) async {
    try {
      Response response = await _dio.get(url);
      return response.data;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}

class DataStreamWidget extends StatelessWidget {
  final String url =
      'http://localhost:8080/protobuf-stream'; // Replace with your URL
  final Duration interval = Duration(seconds: 1); // Fetch data every 5 seconds

  Stream<dynamic> fetchDataAsStream(String url, Duration interval) async* {
    var apiService = ApiService();

    // Emit data at regular intervals
    await for (var _ in Stream.periodic(interval)) {
      try {
        var data = await apiService.fetchData(url);
        yield data;
      } catch (e) {
        yield e; // Handle or emit errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dio Keep-Alive Data Stream')),
      body: StreamBuilder<dynamic>(
        stream: fetchDataAsStream(url, interval),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No Data Available'));
          } else {
            var data = snapshot.data;
            return Center(
              child: Text('Data: $data'),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: DataStreamWidget());
  }
}
