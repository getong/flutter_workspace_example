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
          child: SafeArea(
            child: Container(
              color: Colors.amberAccent,
              height: 300,
              width: 200,
              margin: const EdgeInsets.all(20),
              child: const Align(
                alignment: Alignment(1.0, 0.5),
                child: Text('Flutter'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
