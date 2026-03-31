import 'package:flutter/material.dart';

class CenterBoxPage extends StatelessWidget {
  const CenterBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Center Box Module')),
      body: Center(
        child: Container(width: 100.0, height: 100.0, color: Colors.blue),
      ),
    );
  }
}
