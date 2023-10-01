import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Slider Example',
      home: SliderExample(),
    );
  }
}

class SliderExample extends StatefulWidget {
  @override
  _SliderExampleState createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slider Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Value: $_sliderValue'),
            Slider(
              value: _sliderValue,
              onChanged: (newValue) {
                setState(() {
                    _sliderValue = newValue;
                });
              },
              min: 0,
              max: 100,
              divisions: 100, // Optional: Number of divisions between min and max
              label: '$_sliderValue', // Optional: Display the value as a label
            ),
          ],
        ),
      ),
    );
  }
}
