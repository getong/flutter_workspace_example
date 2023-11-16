import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio();
    _dio.options.headers['Accept'] = 'text/event-stream';
  }

  Stream<List<int>> connectToSse(String url) async* {
    try {
      Response response = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.stream,
          followRedirects: false,
          receiveTimeout: Duration(milliseconds: 150), // Corrected here
        ),
      );

      await for (var data in response.data.stream) {
        yield data;
      }
    } catch (e) {
      print(e.toString());
      // Handle errors or rethrow
      // yield e.toList();
      yield [];
    }
  }
}

class DataStreamWidget extends StatefulWidget {
  final String url =
      'http://localhost:8080/protobuf-stream'; // Replace with your SSE URL

  @override
  _DataStreamWidgetState createState() => _DataStreamWidgetState();
}

class _DataStreamWidgetState extends State<DataStreamWidget> {
  final List<String> _data = []; // List to accumulate string data
  late Stream<List<int>> _dataStream;

  @override
  void initState() {
    super.initState();
    var apiService = ApiService();
    _dataStream = apiService.connectToSse(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SSE Data Stream')),
      body: StreamBuilder<List<int>>(
        stream: _dataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var stringData = utf8.decode(snapshot.data!);
            _data.add(stringData);
            return ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_data[index]),
                );
              },
            );
          } else {
            return Center(child: Text('No Data Available'));
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
