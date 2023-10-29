import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';

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
