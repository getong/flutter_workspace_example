import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamBuilder Dynamic List Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('StreamBuilder Dynamic List'),
        ),
        body: DynamicList(),
      ),
    );
  }
}

class DynamicList extends StatefulWidget {
  @override
  _DynamicListState createState() => _DynamicListState();
}

class _DynamicListState extends State<DynamicList> {
  final StreamController<String> _streamController = StreamController<String>();
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _items = [];

  @override
  void dispose() {
    _streamController.close();
    _textEditingController.dispose();
    super.dispose();
  }

  void _addItem(String item) {
    // Add the new item to the stream
    _streamController.add(item);
    // Clear the text field after item is added
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<List<String>>(
            stream: _streamController.stream.map((String value) {
              // Insert new item at the start of the list
              _items.insert(0, value);
              // Return the updated list
              return _items;
            }),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                // Build the ListView with the data from the snapshot
                return ListView.builder(
                  // Start from the bottom of the list
                  reverse: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data![index]),
                    );
                  },
                );
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            // Set the TextEditingController
            controller: _textEditingController,
            onSubmitted: (String value) {
              if (value.isNotEmpty) {
                // Add the new item to the stream
                _addItem(value);
              }
            },
            decoration: InputDecoration(
              labelText: 'Enter text',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
