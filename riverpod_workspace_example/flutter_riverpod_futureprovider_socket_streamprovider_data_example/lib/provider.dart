import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

final socketProvider = FutureProvider<Socket>((ref) async {
  final socket = await Socket.connect('localhost', 12345);
  // socket.write("hello world");
  return socket;
});

final dataProvider = StreamProvider<List<int>>((ref) {
  final socket = ref.watch(socketProvider);
  final controller = StreamController<List<int>>();

  socket.when(
    data: (socket) {
      socket.listen(
        (List<int> data) {
          // print("data: ${data}");
          // Handle the received data and add it to the stream
          controller.add(data);
        },
        onDone: () {
          // Handle when the socket is closed
          controller.add([]);
        },
        onError: (error) {
          // Handle socket errors if necessary
          controller.add([]);
        },
        cancelOnError: true,
      );
    },
    loading: () {
      controller.add([]);
    },
    error: (error, stackTrace) {
      controller.add([]);
    },
  );

  // Return the stream from the StreamController
  return controller.stream;
});
