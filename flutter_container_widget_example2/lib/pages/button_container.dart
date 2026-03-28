import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({super.key});

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
          color: Colors.lightBlue,
          alignment: Alignment.center,
          child: Text(
            'Press the snow icon for a message.',
            style: pageTheme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
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
