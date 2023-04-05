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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.redAccent,
                  height: 50,
                  width: 50,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.greenAccent,
                  height: 50,
                  width: 50,
                ),
              ),
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
