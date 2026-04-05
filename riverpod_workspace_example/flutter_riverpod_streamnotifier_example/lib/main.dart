import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class StreamNotifier {
  final _controller = StreamController<int>();
  Stream<int> get stream => _controller.stream;

  void updateData(int data) {
    _controller.sink.add(data);
  }

  void dispose() {
    _controller.close();
  }
}

final streamNotifierProvider = Provider<StreamNotifier>((ref) {
    return StreamNotifier();
});

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final streamNotifier = ref.watch(streamNotifierProvider);
    final stream = streamNotifier.stream;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('StreamNotifier Example'),
        ),
        body: Center(
          child: StreamBuilder<int>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Stream Data: ${snapshot.data}');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final randomData = DateTime.now().millisecond;
            streamNotifier.updateData(randomData);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
