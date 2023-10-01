import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TextEditingController Example',
      home: TextFieldExample(),
    );
  }
}

class TextFieldExample extends StatefulWidget {
  @override
  _TextFieldExampleState createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  // Create a TextEditingController
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TextEditingController Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Text field with the TextEditingController
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter text'),
            ),
            SizedBox(height: 20),
            // Display the text from the controller
            Text(
              'Text entered: ${_controller.text}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed from the widget tree
    _controller.dispose();
    super.dispose();
  }
}
