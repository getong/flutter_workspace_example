import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Container(
                color: Colors.redAccent,
                height: 50,
                width: 50,
                child: const Text('Dart'),
              ),
              Container(
                color: Colors.greenAccent,
                height: 50,
                width: 100,
                // child: const Text('is'),
              ),
              Container(
                color: Colors.blueAccent,
                height: 50,
                width: 50,
                child: const Text('Cool'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
