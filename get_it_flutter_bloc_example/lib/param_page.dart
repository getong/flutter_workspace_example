import 'package:flutter/material.dart';

class ParamPage extends StatelessWidget {
  final String value;
  const ParamPage({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Param Page')),
      body: Center(
        child: Text(
          'Parameter value: $value',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
