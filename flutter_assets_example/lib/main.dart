import 'package:flutter/material.dart';

void main() {
  runApp(const MonaLisaApp());
}

class MonaLisaApp extends StatelessWidget {
  const MonaLisaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Mona Lisa'),
          ),
          backgroundColor: Colors.brown[700],
        ),
        body: const SafeArea(
          child: Image(
            image: AssetImage('images/Mona_Lisa.jpg'),
            // fit: BoxFit.cover,
            // fit: BoxFit.fill,
            // fit: BoxFit.fitHeight,
            fit: BoxFit.contain,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
