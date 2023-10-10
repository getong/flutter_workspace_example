import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('MyApp')),
        body: Center(
          child: TextButton(
            child: Text('Exit App'),
            onPressed: () async {
              // Show a confirmation dialog.
              bool shouldExit = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Exit App?'),
                    content: Text('Are you sure you want to exit the app?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: Text('Exit'),
                        onPressed: () => SystemNavigator.pop(),
                      ),
                    ],
                  );
                },
              );

              // Exit the app if the user confirms.
              if (shouldExit) {
                await SystemNavigator.pop();
              }
            },
          ),
        ),
      ),
    );
  }
}

