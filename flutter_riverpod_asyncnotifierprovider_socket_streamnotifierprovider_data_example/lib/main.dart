import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider.dart';
import 'counter_number.pb.dart';
import 'package:binarize/binarize.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  final TextEditingController _dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('TCP Buffer Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Consumer(
                builder: (context, ref, child) {
                  final asyncValue = ref.watch(tcpClientProvider);

                  if (asyncValue is AsyncValue<TcpClient>) {
                    final isConnected =
                        ref.read(tcpClientProvider.notifier).connected;
                    if (!isConnected) {
                      return ElevatedButton(
                        onPressed: () {
                          ref.read(tcpClientProvider.notifier).connectToServer(
                              ref.watch(serverAddressProvider),
                              ref.watch(serverPortProvider));
                        },
                        child: Text('Connect to Server'),
                      );
                    } else {
                      return Column(children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(tcpClientProvider.notifier)
                                .disconnectFromServer();
                          },
                          child: Text('Disconnect from Server'),
                        ),
                        RecvPage(),
                        SizedBox.shrink(),
                        TextField(
                          controller: _dataController,
                          decoration: InputDecoration(labelText: 'Enter Data'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final String data = _dataController.text;
                            if (data.isNotEmpty) {
                              final readRequest = ReadRequest(
                                letter: data,
                                beforeNumber: 1,
                                dummyOne: 1,
                                dummyTwo: SampleSchema(
                                  sampleFieldOne: true,
                                  sampleFieldTwo: false,
                                ),
                                dummyThree: [3, 4, 5],
                              );
                              List<int> sendData = readRequest.writeToBuffer();
                              final writer = Payload.write()
                                ..set(uint32, sendData.length)
                                ..set(Bytes(sendData.length), sendData);
                              final bytes = binarize(writer);
                              ref
                                  .read(tcpClientProvider.notifier)
                                  .sendByteData(bytes.toList());
                              _dataController.clear();
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Please enter data to send.'),
                              ));
                            }
                          },
                          child: Text('Send Data'),
                        ),
                      ]);
                    }
                  } else {
                    return Text("not AsyncValue<TcpClient>");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class RecvPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataBytes = ref.watch(dataProvider).value;
    if (dataBytes == null) {
      return  Padding(
        padding: EdgeInsets.all(16),
        child: Text('Buffered Data:'),
      );
    } else {
      final reader = Payload.read(dataBytes);
      final aUint32 = reader.get(uint32);
      final aList = reader.get(Bytes(aUint32));
      return Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Buffered Data: ${ReadRequest.fromBuffer(aList)}'),
      );
    }

  }
}