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
            child: Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: <Widget>[
                Chip(
                  avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('EL')),
                  label: const Text('Elon Musk'),
                ),
                Chip(
                  avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('BG')),
                  label: const Text('Bill Gates'),
                ),
                Chip(
                  avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('MZ')),
                  label: const Text('Mark Zuckerberg'),
                ),
                Chip(
                  avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('JB')),
                  label: const Text('Jeff Bezos'),
                ),
              ],
            )
        ),
      ),
    );
  }
}
