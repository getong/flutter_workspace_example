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
        child: ElevatedButton(
          onPressed: () {
            // Show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('This is a Snackbar'),
                duration: Duration(seconds: 3), // Specify the duration of the Snackbar
                action: SnackBarAction(
                  label: 'Undo', // Text label for the action button
                  onPressed: () {
                    // Code to undo the action caused by the Snackbar
                    // This function will be called when the user taps the "Undo" button
                    // You can perform any action here, for example, revert a delete operation.
                    print('Undo action triggered');
                  },
                ),
              ),
            );
          },
          child: Text('Show Snackbar'),
        ),
      ),
    );
  }
}
