import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

// nc -l 12345

final tcpProvider = Provider<TcpConnection>((ref) {
  return TcpConnection();
});

class TcpConnection {
  Socket? _socket;

  Future<void> connect() async {
    try {
      _socket = await Socket.connect('127.0.0.1', 12345);
      print('Connected to server\n');
    } catch (e) {
      print('Error connecting: $e');
    }
  }

  void send(String message) {
    _socket?.write(message);
  }

  void close() {
    _socket?.close();
  }
}

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCP Riverpod Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TcpExampleWidget(),
    );
  }
}

class TcpExampleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tcp = ref.watch(tcpProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('TCP Riverpod Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await tcp.connect();
              },
              child: Text('Connect'),
            ),
            ElevatedButton(
              onPressed: () {
                tcp.send('Hello from Flutter!\n');
              },
              child: Text('Send Message'),
            ),
            ElevatedButton(
              onPressed: () {
                tcp.close();
              },
              child: Text('Close Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
