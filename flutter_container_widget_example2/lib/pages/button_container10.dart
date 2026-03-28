import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonContainer10 extends StatelessWidget {
  const ButtonContainer10({super.key});

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
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            gradient: LinearGradient(
                begin: Alignment(0, -1),
                end: Alignment(0, -0.4),
                tileMode: TileMode.mirror,
                colors: [Colors.blue, Colors.orange]),
            shape: BoxShape.rectangle,
          ),
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
