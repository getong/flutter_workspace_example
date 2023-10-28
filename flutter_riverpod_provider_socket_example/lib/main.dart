import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final socketProvider = FutureProvider<Socket>((ref) async {
  final socket = await Socket.connect('localhost', 12345);
  // socket.write("hello world");
  return socket;
});

class SocketPage extends ConsumerWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socketAsyncValue = ref.watch(socketProvider);

    return socketAsyncValue.when(
      data: (socket) {
        if (socket != null && socket is Socket) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: StreamBuilder<List<int>>(
                  stream: socket,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    final data = snapshot.data ?? <int>[];
                    if (data.isEmpty) {
                      return Center(child: Text('No data received.'));
                    }
                    final messages = String.fromCharCodes(data);
                    return ListView(
                      reverse: true,
                      children: messages.split('\n').map((message) {
                        return ListTile(
                          title: Text(message),
                        );
                      }).toList(),
                    );
                  },
                ),
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
                          // final socket = socketAsyncValue.data?.value;
                          socket.write(message);
                          _textController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Center(child: Text('Invalid Socket'));
        }
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
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
