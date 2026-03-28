import 'package:flutter/material.dart';

class ButtonContainer2 extends StatelessWidget {
  const ButtonContainer2({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData baseTheme = Theme.of(context);
    final ThemeData pageTheme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.copyWith(
        bodyMedium: const TextStyle(
          fontSize: 26,
          fontStyle: FontStyle.italic,
        ),
      ),
    );

    return Theme(
      data: pageTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter UI Container'),
        ),
        body: Container(
            width: 300,
            height: 300,
            color: Colors.lightBlue,
            child: const OverflowBar()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Oh, it is cold outside...')),
            );
          },
          child: const Icon(Icons.ac_unit),
        ),
      ),
    );
  }
}
