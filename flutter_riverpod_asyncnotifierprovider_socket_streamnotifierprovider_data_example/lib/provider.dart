import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

// ncat -l 12345 --keep-open --exec "/bin/cat"

// final serverAddressProvider =
//     Provider<String>((ProviderRef<String> ref) => '127.0.0.1');
@riverpod
String serverAddress(ref) {
  return '127.0.0.1';
}

// final serverPortProvider = Provider<int>((ProviderRef<int> ref) => 12345);
@riverpod
int serverPort(ref) {
  return 12345;
}

// final tcpClientProvider = AsyncNotifierProvider<TcpClientNotifier, TcpClient>(
//     () => TcpClientNotifier());

// final dataProvider = StreamNotifierProvider<ListNotifier, List<int>>(() {
//   return ListNotifier();
// });

// class ListNotifier extends StreamNotifier<List<int>> {
//   final List<int> buffer = [];
//   final StreamController<List<int>> _dataController =
//       StreamController.broadcast();

//   ListNotifier() {
//     // Subscribe to _dataController's stream and push its values to the StreamNotifier's stream
//     _dataController.stream.listen((data) {
//       if (data.length > 3) {
//         buffer.addAll(data);
//         final buffer2 = [...buffer];
//         buffer.clear();
//         state = AsyncValue.data(buffer2);
//       } else {
//         buffer.addAll(data);
//         if (buffer.length > 3) {
//           final buffer2 = [...buffer];
//           buffer.clear();
//           state = AsyncValue.data(buffer2);
//         } else {
//           state = AsyncValue.data([]);
//         }
//       }
//     });
//   }

//   @override
//   Stream<List<int>> build() async* {
//     final socket = ref.watch(tcpClientProvider);
//     socket.when(
//       data: (tcpClient) {
//         tcpClient.socket.listen(
//           (List<int> data) {
//             // print("data: ${data}");
//             _dataController
//                 .add(data); // Add data to _dataController instead of yielding
//           },
//           onDone: () {},
//           onError: (error) {},
//           cancelOnError: true,
//         );
//       },
//       loading: () {},
//       error: (error, stackTrace) {},
//     );
//   }

//   @override
//   void dispose() {
//     _dataController.close();
//     // super.dispose();
//   }
// }

@riverpod
class ListNotifier extends _$ListNotifier {
  final List<int> buffer = [];

  @override
  Stream<List<int>> build() async* {
    // final socket = ref.read(tcpClientProvider.notifier)._tcpClient.socket;
    // final tcpClient = ref.watch(tcpClientNotifierProvider);
    final socket = ref.watch(
        tcpClientNotifierProvider.select((client) => client.value?.socket));

    try {
      if (socket != null) {
        await for (final data in socket) {
          // if (data.length > 3) {
          //   // Yield each incoming data from the socket.
          //   buffer.addAll(data);
          //   final buffer2 = [...buffer];
          //   buffer.clear();
          //   yield buffer2;
          // } else {
          //   buffer.addAll(data);
          //   if (buffer.length > 3) {
          //     final buffer2 = [...buffer];
          //     buffer.clear();
          //     yield buffer2;
          //   } else {
          //     yield [];
          //   }
          // }
          yield data;
        }
      } else {
        print("socket is null");
      }
    } catch (error) {
      // Handle any error that occurs during stream iteration
      print("An error occurred: $error");
    }
  }
}

@riverpod
class TcpClientNotifier extends _$TcpClientNotifier {
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

  Future<void> sendByteData(List<int> data) async {
    if (connected) {
      await _tcpClient.sendByteData(data);
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

  Future<void> sendByteData(List<int> data) async {
    socket.add(data);
  }
}
