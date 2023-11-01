import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamBuilder Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final StreamController<int> _streamController = StreamController<int>();
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('StreamBuilder Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            StreamBuilder<int>(
              stream: _streamController.stream,
              initialData: 0, // Initial data to display
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                // If we have an error display it
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                // Otherwise, display the number from the stream
                return Text('${snapshot.data}',
                    style: Theme.of(context).textTheme.headline4);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _counter++;
          _streamController.sink.add(_counter); // Adding data to stream
        },
      ),
    );
  }

  @override
  void dispose() {
    _streamController.close(); // Always close streams to free resources
    super.dispose();
  }
}
