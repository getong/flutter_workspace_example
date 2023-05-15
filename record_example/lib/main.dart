import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final random = Random();

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = false;
  String _message = '';
  Todo? _todo;

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
      _message = '';
      _todo = null;
    });

    final (todo, message) = await _getTodoOrError();

    setState(() {
      _isLoading = false;
      if (todo != null) {
        _todo = todo;
        _message = 'Data fetched successfully!';
      } else {
        _message = 'Failed to fetch data. Error: $message';
      }
    });
  }

  Future<(Todo?, String)> _getTodoOrError() async {
    try {
      //Attempt to fetch the data from JSONPlaceholder
      final response = await http.get(
        Uri.parse(
          random.nextBool()
              ? 'https://jsonplaceholder.typicode.com/incorrect'
              : 'https://jsonplaceholder.typicode.com/todos/1${random.nextInt(100)}',
        ),
      );

      //We have a response, but we don't know if it was successful or not
      return switch (response) {
        (final r) when r.statusCode == 200 =>
          //We have a successful response, so we can return the data
          (
            Todo.fromJson(jsonDecode(response.body) as Map<String, dynamic>),
            'Data fetched successfully!'
          ),
        //We have an unsuccessful response, so we can return the error message
        _ => (null, 'Failed to fetch data. Error: ${response.statusCode}'),
      };
    } catch (e) {
      //We have an exception, so we can return the error message
      return (null, 'Failed to fetch data. Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('JSONPlaceholder TODOs'),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _mainContent(),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _refresh,
            child: const Icon(Icons.refresh),
          ),
        ),
      );

  Column _mainContent() => Column(
        children: <Widget>[
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: CircularProgressIndicator(),
            ),
          if (_message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(_message),
            ),
          if (_todo != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('ID: ${_todo!.id}'),
                    Text('Title: ${_todo!.title}'),
                    Text('Completed: ${_todo!.completed}'),
                  ],
                ),
              ),
            ),
        ],
      );
}

class Todo {
  Todo(this.id, this.title, this.completed);

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        json['id'] as int,
        json['title'] as String,
        json['completed'] as bool,
      );

  final int id;
  final String title;
  final bool completed;
}

// copy from https://www.christianfindlay.com/blog/dart-records-and-futures
