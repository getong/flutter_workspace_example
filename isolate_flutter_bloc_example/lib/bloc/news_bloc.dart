import 'dart:isolate';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsState.initial()) {
    on<GetNews>((event, emit) async {
      // Show a loading state or progress indicator here if needed
      emit(state.copyWith(myData: "Loading..."));

      // Running the heavy computation in a separate isolate
      final result = await _computeInIsolate(int.parse(event.data));

      // Emit the result from the isolate
      emit(state.copyWith(myData: result.toString()));
    });
  }

  // Function to run heavy computation in isolate
  Future<int> _computeInIsolate(int data) async {
    final receivePort = ReceivePort();

    // Spawn the isolate
    await Isolate.spawn(_isolateEntryPoint, receivePort.sendPort);

    // Get the SendPort from the isolate
    final sendPort = await receivePort.first as SendPort;

    // Create a new ReceivePort to get the result
    final responsePort = ReceivePort();

    // Send the data to the isolate
    sendPort.send([data, responsePort.sendPort]);

    // Wait for the result
    final result = await responsePort.first as int;

    return result;
  }

  // Isolate entry point
  static void _isolateEntryPoint(SendPort sendPort) {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    port.listen((message) {
      final data = message[0] as int;
      final replyPort = message[1] as SendPort;

      // Perform heavy computation
      final result = heavyComputation(data);

      // Send result back
      replyPort.send(result);
    });
  }

  // Heavy computation function
  static int heavyComputation(int data) {
    var total = 0;
    for (var i = 0; i < data; i++) {
      total += i;
    }
    return total;
  }
}
