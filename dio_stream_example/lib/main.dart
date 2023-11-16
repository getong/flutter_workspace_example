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

  Stream<List<dynamic>> fetchDataAsStream(
      String url, Duration interval) async* {
    var apiService = ApiService();
    List<dynamic> accumulatedData = []; // List to accumulate data over time

    await for (var _ in Stream.periodic(interval)) {
      try {
        var newData = await apiService.fetchData(url);
        if (newData is List) {
          accumulatedData
              .addAll(newData); // Append new data to the accumulated list
          yield List.from(accumulatedData); // Emit the updated list
        } else {
          print("Fetched data is not a List");
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dio Keep-Alive Data Stream')),
      body: StreamBuilder<List<dynamic>>(
        stream: fetchDataAsStream(url, interval),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Data Available'));
          } else {
            var data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].toString()),
                );
              },
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
