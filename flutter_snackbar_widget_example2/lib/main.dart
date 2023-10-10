import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Snackbar Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snackbar Example'),
      ),
      body: Center(
        child: Text(
          'Press the button below to show Snackbar!',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a snackbar with a custom style
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'This is a Snackbar with Custom Style',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              backgroundColor:
                  Colors.blueAccent, // Background color of the Snackbar
              duration: Duration(
                  seconds: 2), // Duration for which the Snackbar is visible
              action: SnackBarAction(
                label: 'Close', // Text label for the action button
                textColor: Colors.white, // Text color of the action button
                onPressed: () {
                  // Code to execute when the user taps the "Close" button
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
