import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonContainer8 extends StatelessWidget {
  const ButtonContainer8({super.key});

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
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topRight: Radius.elliptical(50, 50),
              topLeft: Radius.circular(20),
              bottomRight: Radius.elliptical(25, 25),
            ),
          ),
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
