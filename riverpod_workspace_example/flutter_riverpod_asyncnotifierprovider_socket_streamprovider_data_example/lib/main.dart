import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider.dart';

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
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                              'Buffered Data: ${utf8.decode(ref.watch(dataProvider).value ?? [])}'),
                        ),
                        SizedBox.shrink(),
                        TextField(
                          controller: _dataController,
                          decoration: InputDecoration(labelText: 'Enter Data'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final String data = _dataController.text;
                            if (data.isNotEmpty) {
                              ref
                                  .read(tcpClientProvider.notifier)
                                  .sendData(data);
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
