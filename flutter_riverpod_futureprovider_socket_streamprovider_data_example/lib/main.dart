import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider.dart';

class SocketPage extends ConsumerWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child:
              Text(utf8.decode(ref.watch(dataProvider).value ?? Uint8List(0))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(labelText: 'Enter Message'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  final message = _textController.text;
                  if (message.isNotEmpty) {
                    final socketAsyncValue = ref.watch(socketProvider);
                    Socket? socket = socketAsyncValue?.value;
                    if (socket != null) {
                      socket.write(message);
                      _textController.clear();
                    }
                    _textController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: SocketPage(),
      ),
    );
  }
}
