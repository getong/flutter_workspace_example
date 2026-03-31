import 'package:flutter/material.dart';

class ConstrainedBoxPage extends StatelessWidget {
  const ConstrainedBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Constrained Box Module')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 50.0,
            maxWidth: 150.0,
            minHeight: 50.0,
            maxHeight: 150.0,
          ),
          child: Container(color: Colors.green),
        ),
      ),
    );
  }
}
