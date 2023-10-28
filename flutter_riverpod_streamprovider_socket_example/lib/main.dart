import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:io';

final chatProvider = StreamProvider<List<String>>((ref) async* {
  // Connect to an API using sockets, and decode the output
  final socket = await Socket.connect('localhost', 12345);
  ref.onDispose(socket.close);
  socket.write("hello world");

  var allMessages = const <String>[];
  await for (final message in socket.map(utf8.decode)) {
    // A new message has been received. Let's add it to the list of all messages.
    allMessages = [...allMessages, message];
    yield allMessages;
  }
});

class SocketPage extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final liveChats = ref.watch(chatProvider);

    // Like FutureProvider, it is possible to handle loading/error states using AsyncValue.when
    return switch (liveChats) {
      // Display all the messages in a scrollable list view.
      AsyncData(:final value) => Expanded(
          child: ListView.builder(
            // Show messages from bottom to top
            reverse: true,
            itemCount: value.length,
            itemBuilder: (context, index) {
              final message = value[index];
              return Text(message);
            },
          ),
        ),
      AsyncError(:final error) => Text(error.toString()),
      _ => const CircularProgressIndicator(),
    };
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SocketPage(),
          ],
        ),
      ),
    );
  }
}
