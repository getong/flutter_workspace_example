import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Radio Example',
      home: RadioExample(),
    );
  }
}

class RadioExample extends StatefulWidget {
  @override
  _RadioExampleState createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  // Variable to hold the selected radio value
  String _radioValue = 'Option 1';

  // List of radio options
  List<String> _options = ['Option 1', 'Option 2', 'Option 3'];

  // Radio onChanged callback
  void _handleRadioValueChange(String? value) {
    setState(() {
      _radioValue = value ?? ''; // Use the empty string if value is null
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Radio Example'),
      ),
      body: Column(
        children: _options
            .map(
              (option) => RadioListTile(
                title: Text(option),
                groupValue: _radioValue,
                value: option,
                onChanged: _handleRadioValueChange,
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Selected option: $_radioValue',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
