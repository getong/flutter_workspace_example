import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final socketProvider = FutureProvider<Socket>((ref) async {
  final socket = await Socket.connect('localhost', 12345);
  // socket.write("hello world");
  return socket;
});

final dataProvider = StreamProvider<Uint8List>((ref) {
  final socket = ref.watch(socketProvider);
  final controller = StreamController<Uint8List>();

  socket.when(
    data: (socket) {
      socket.listen(
        (List<int> data) {
          // print("data: ${data}");
          // Handle the received data and add it to the stream
          controller.add(Uint8List.fromList(data));
        },
        onDone: () {
          // Handle when the socket is closed
          controller.add(Uint8List(0));
        },
        onError: (error) {
          // Handle socket errors if necessary
          controller.add(Uint8List(0));
        },
        cancelOnError: true,
      );
    },
    loading: () {
      controller.add(Uint8List(0));
    },
    error: (error, stackTrace) {
      controller.add(Uint8List(0));
    },
  );

  // Return the stream from the StreamController
  return controller.stream;
});

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
