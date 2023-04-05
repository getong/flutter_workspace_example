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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Container(
                color: Colors.redAccent,
                height: 50,
                width: 50,
                child: const Text(
                  'Dart',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                color: Colors.greenAccent,
                height: 75,
                width: 50,
                child: const Text('is'),
              ),
              Container(
                color: Colors.blueAccent,
                height: 100,
                width: 50,
                child: const Text(
                  'cool',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
