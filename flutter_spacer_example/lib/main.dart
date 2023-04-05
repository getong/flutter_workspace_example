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
            children: [
              Container(
                color: Colors.redAccent,
                height: 50,
                width: 50,
              ),
              const Spacer(flex: 2),
              Container(
                color: Colors.greenAccent,
                height: 50,
                width: 50,
              ),
              const Spacer(),
              Container(
                color: Colors.blueAccent,
                height: 50,
                width: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
