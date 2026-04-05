import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ncat -l 12345 --keep-open --exec "/bin/cat"

final serverAddressProvider =
    Provider<String>((ProviderRef<String> ref) => '127.0.0.1');

final serverPortProvider = Provider<int>((ProviderRef<int> ref) => 12345);

final tcpClientProvider = AsyncNotifierProvider<TcpClientNotifier, TcpClient>(
    () => TcpClientNotifier());

final dataProvider = StreamProvider<List<int>>((ref) {
  final socket = ref.watch(tcpClientProvider);
  final controller = StreamController<List<int>>();

  socket.when(
    data: (tcpClient) {
      tcpClient.socket.listen(
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

class TcpClientNotifier extends AsyncNotifier<TcpClient> {
  late TcpClient _tcpClient;
  bool connected = false;

  Future<void> _initializeTcpClient() async {
    _tcpClient = await TcpClient.connect(
        host: ref.watch(serverAddressProvider),
        port: ref.watch(serverPortProvider));
    state = AsyncData(_tcpClient);
    connected = true;
  }

  @override
  FutureOr<TcpClient> build() async {
    await _initializeTcpClient();
    return _tcpClient;
  }

  Future<void> connectToServer(String host, int port) async {
    if (!connected) {
      state = AsyncLoading();
      try {
        _tcpClient = await TcpClient.connect(
            host: ref.watch(serverAddressProvider),
            port: ref.watch(serverPortProvider));
        state = AsyncData(_tcpClient);
        connected = true; // Update the connected status
      } catch (error, stackTrace) {
        state = AsyncError(error, stackTrace);
      }
    }
  }

  Future<void> disconnectFromServer() async {
    if (connected) {
      await _tcpClient.disconnectFromServer();
      state = AsyncData(_tcpClient);
      connected = false;
    }
  }

  Future<void> sendData(String data) async {
    if (connected) {
      await _tcpClient.sendData(data);
    } else {
      print('Error: TcpClient is not properly initialized.');
    }
  }
}

class TcpClient {
  late Socket socket;

  TcpClient(this.socket) {}

  static Future<TcpClient> connect(
      {required String host, required int port}) async {
    try {
      var socket =
          await Socket.connect(host, port, timeout: Duration(seconds: 3));
      var client = TcpClient(socket);
      return client;
    } catch (e) {
      throw ('Connection failed: $e');
    }
  }

  Future<void> disconnectFromServer() async {
    await socket.close();
  }

  Future<void> sendData(String data) async {
    socket.write(data);
  }
}
