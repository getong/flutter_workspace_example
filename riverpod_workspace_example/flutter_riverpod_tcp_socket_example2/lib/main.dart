import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// nc -l 64123
void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter-TCP/IP Client'),
    );
  }
}

final serverAddressProvider =
    Provider<String>((ProviderRef<String> ref) => '127.0.0.1');
final serverPortProvider = Provider<int>((ProviderRef<int> ref) => 64123);
final tcpClientProvider = ChangeNotifierProvider<TCPClient>(
  (ChangeNotifierProviderRef<TCPClient> ref) => TCPClient(
    serverAddress: ref.read(serverAddressProvider),
    serverPort: ref.read(serverPortProvider),
  ),
);

final streamProvider = StreamProvider.autoDispose(
  (AutoDisposeStreamProviderRef<Object?> ref) async* {
    await for (final value
        in ref.watch(tcpClientProvider).streamController.stream) {
      yield value;
    }
  },
);

class MyHomePage extends ConsumerWidget {
  final String title;
  MyHomePage({required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DataSendButton(),
          SizedBox(height: 10),
          // ReceivedDataWithProvider(),
          ReceivedData(),
          SizedBox(height: 20),
          DataSendIndicator(),
          DataReceiveIndicator(),
          ConnectionIndicator(),
        ],
      ),
      floatingActionButton: ConnectButton(),
    );
  }
}

class ReceivedData extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receivedData = ref.watch(tcpClientProvider).receivedData;
    return Text('Received data: $receivedData');
  }
}

class ReceivedDataWithProvider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue receivedData = ref.watch(streamProvider);

    return receivedData.when(
      data: (data) => Text('Received data: $data'),
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('error'),
    );
  }
}

class ConnectButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(tcpClientProvider).connectionState;
    return FloatingActionButton(
      onPressed: isConnected
          ? null
          : () async => await ref.read(tcpClientProvider).createConnection(),
      tooltip: isConnected ? 'Connected' : 'Connect',
      child: isConnected
          ? Icon(Icons.connect_without_contact_outlined)
          : Icon(Icons.touch_app_sharp),
    );
  }
}

class ConnectionIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(tcpClientProvider).connectionState;
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isConnected ? Colors.green : Colors.red,
        ),
      ),
      title: Text('Connection Status '),
      subtitle: isConnected ? Text('Connected') : Text('Disconnected'),
    );
  }
}

class DataSendButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(tcpClientProvider).connectionState;
    return ElevatedButton(
      onPressed: !isConnected
          ? null
          : () {
              ref
                  .read(tcpClientProvider)
                  .writeToStream('DateTime: ${DateTime.now()}');
            },
      child: Text('Send DateTime.now()'),
    );
  }
}

class DataSendIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDataSent = ref.watch(tcpClientProvider).dataSentState;
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDataSent ? Colors.green : Colors.red,
        ),
      ),
      title: Text('Data'),
      subtitle: isDataSent ? Text('Sent') : Text('Not sent'),
    );
  }
}

class DataReceiveIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDataReceived = ref.watch(tcpClientProvider).dataReceivedState;
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDataReceived ? Colors.green : Colors.red,
        ),
      ),
      title: Text('Data'),
      subtitle: isDataReceived ? Text('Received') : Text('Not received'),
    );
  }
}

class TCPClient with ChangeNotifier {
  final String serverAddress;
  final int serverPort;
  String receivedData;
  bool _isConnected, _dataReceived, _dataSent;
  late Socket _socket;
  final streamController;

  TCPClient({
    required this.serverAddress,
    required this.serverPort,
  })  : _isConnected = false,
        _dataReceived = false,
        _dataSent = false,
        receivedData = 'empty',
        streamController = StreamController();

  get connectionState => _isConnected;
  get dataReceivedState => _dataReceived;
  get dataSentState => _dataSent;

  void _changeConnectionState() {
    if (!_isConnected)
      _isConnected = true;
    else
      _isConnected = false;

    notifyListeners();
  }

  void _changeDataReceivedState() {
    _dataReceived = true;
    notifyListeners();
  }

  void _changeDataSentState() {
    _dataSent = true;
    notifyListeners();
  }

  void _streamDone() async {
    _dataReceived = false;
    _dataSent = false;
    receivedData = 'empty';
    await _socket.flush();
    await _socket.close();
    notifyListeners();
  }

  void _getData(var data) {
    receivedData = data;
    notifyListeners();
  }

  void writeToStream(String data) {
    _socket.write('$data\r\n');
    if (!dataSentState) {
      _changeDataSentState();
    }
  }

  // for the StreamProvider version
  //   Future<void> createConnection() async {
  //   try {
  //     _socket = await Socket.connect(serverAddress, serverPort);
  //     streamController.sink.add(_socket.listen((event) => String.fromCharCodes(event)));
  //     _changeConnectionState();
  //   } catch (e) {
  //     print('connection has an error and socket is null.');
  //     print(e);
  //     return;
  //   }

  // }

  Future<void> createConnection() async {
    try {
      _socket = await Socket.connect(serverAddress, serverPort);
      _changeConnectionState();
    } catch (e) {
      print('connection has an error and socket is null.');
      print(e);
      return;
    }

    listenSocket();
  }

  void listenSocket() {
    _socket.listen(
      (event) {
        _getData(String.fromCharCodes(event));
        print('received: $receivedData');

        if (!_dataReceived) {
          _changeDataReceivedState();
        }
      },
    )
      ..onDone(
        () {
          _changeConnectionState();
          _streamDone();
          print('socket is closed');
        },
      )
      ..onError(
        (error, stackTrace) {
          print('$error');
        },
      );
  }
}

// modify from https://gist.github.com/sphinxlikee/3cbfa47817a5187c7b67905028674041
// also see https://stackoverflow.com/questions/67229798/streamprovider-and-tcp-socket
