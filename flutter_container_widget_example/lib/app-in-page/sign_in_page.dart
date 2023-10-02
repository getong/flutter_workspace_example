import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
      ),
      body: _buildContent(),
    );
  }
}

Widget _buildContent() {
  return Padding(
    // color: Colors.yellow,
    padding: EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Sign in',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          child: Text('Sign in with Google'),
          onPressed: () {
            print('button pressed');
          },
        ),
      ],
    ),
  );
}
