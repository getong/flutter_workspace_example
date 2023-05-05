import 'package:flutter/material.dart';
import 'package:tcp_protobuf_example/mymessage.pb.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Socket? _socket;

  MyMessage _message = MyMessage();

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  Future<void> _connectToServer() async {
    _socket = await Socket.connect('192.168.1.103', 1234);
  }

  Future<void> _sendMessage() async {
    _message.text = 'Hello, world!';
    _message.number = 43;

    final bytes = _message.writeToBuffer();
    _socket!.add(bytes);
  }

  Future<void> _receiveMessage() async {
    final data = await _socket!.first;
    setState(() {
      _message = MyMessage.fromBuffer(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hello World App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text('TCP + Protobuf Example')),
          body: Center(
            child: ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _receiveMessage,
            child: Icon(Icons.refresh),
          ),
        ));
  }
}
