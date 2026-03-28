import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonContainer4 extends StatelessWidget {
  const ButtonContainer4({super.key});

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
          actions: <Widget>[
            IconButton(
              tooltip: 'Go Home',
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home),
            ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(100),
          padding: EdgeInsets.all(50),
          color: Colors.lightBlue,
          child: Text('Container'),
        ),
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
