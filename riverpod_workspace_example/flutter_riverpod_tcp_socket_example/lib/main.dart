import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// nc -l 8080

final socketProvider = FutureProvider<Socket>((ref) async {
  // Create a new TCP socket connection to 'localhost' at port 8080.
  final socket = await Socket.connect('localhost', 8080);

  // Return the connected socket.
  return socket;
});

final dataListenerProvider = Provider((ref) {
  // Get the async value of the socket from the provider.
  final asyncSocket = ref.watch(socketProvider);

  // Listen for the 'data' event when the socket is available.
  asyncSocket.maybeWhen(
    data: (socket) {
      socket.listen((List<int> data) {
        // Handle received data here.
        String message = String.fromCharCodes(data);
        ref.read(currentMessageProvider.notifier).state = message;
      }, onError: (error, stackTrace) {
        // Handle errors here.
        print('Socket error: $error');
      }, onDone: () {
        // Handle socket closure here.
        print('Socket closed');
      });
    },
    loading: () {
      // Handle loading state if needed.
    },
    orElse: () {
      // Handle other states if needed.
    },
  );

  // Return a dispose function to close the TCP socket connection when the provider is disposed.
  return () => asyncSocket.maybeWhen(
        data: (socket) {
          socket.close();
        },
        orElse: () {},
      );
});

// Create a state provider for the current message.
final currentMessageProvider = StateProvider<String?>((ref) => null);

// Create a widget to display the current message.
class CurrentMessageWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current message from the provider.
    final currentMessage = ref.watch(currentMessageProvider);

    // If the current message is null, display a placeholder message.
    if (currentMessage == null) {
      return Text('No messages yet.');
    }

    // Display the current message.
    return Text(currentMessage);
  }
}

// Create a widget to send a message.
class SendMessageWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the AsyncValue<Socket> from the provider.
    final asyncSocket = ref.watch(socketProvider);

    // Create a text controller to handle the message input.
    final messageController = TextEditingController();

    // Create a button to send the message.
    final sendButton = ElevatedButton(
      onPressed: () {
        // Use maybeWhen to handle different states of AsyncValue<Socket>.
        asyncSocket.maybeWhen(
          data: (socket) {
            // Send the message over the socket.
            socket.add(utf8.encode(messageController.text));
          },
          orElse: () {
            // Handle the case when the socket is not available.
            print('Socket not available');
          },
        );

        // Clear the text field.
        messageController.clear();
      },
      child: Text('Send'),
    );

    // Return a column containing the text field and the send button.
    return Column(
      children: [
        TextField(
          controller: messageController,
        ),
        sendButton,
      ],
    );
  }
}

// Create the main widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Provide the TCP socket to the app.
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Flutter Riverpod TCP Socket Example'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CurrentMessageWidget(),
                SendMessageWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
