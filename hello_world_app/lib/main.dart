import 'package:flutter/material.dart';

void main() {
  runApp(const HelloWorldApp());
}
class HelloWorldApp extends StatelessWidget {
  const HelloWorldApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), // end of ThemeData
      home: Scaffold(
        appBar : AppBar(
          title: const Text('Hello World title'),
        ), // end of AppBar
        body : const Center(
            child: Text('Hello, World!!!'),
          ), // end of Center
        ) // end of Scaffold
      ); // end of MaterialApp
  }
}
