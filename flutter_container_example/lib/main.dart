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
        body: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(
                  'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png'),
              fit: BoxFit.cover,
            ),
            border: Border.all(width: 8, color: Colors.lightBlueAccent),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
