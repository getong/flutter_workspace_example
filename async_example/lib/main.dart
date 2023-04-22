// main.dart
import 'package:flutter/material.dart';
import 'package:async/async.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'KindaCode.com',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // this future will return some text once it completes
  Future<String?> _myFuture() async {
    await Future.delayed(const Duration(seconds: 5));
    return 'Future completed';
  }

  // keep a reference to CancelableOperation
  CancelableOperation? _myCancelableFuture;

  // This is the result returned by the future
  String? _text;

  // Help you know whether the app is "loading" or not
  bool _isLoading = false;

  // This function is called when the "start" button is pressed
  void _getData() async {
    setState(() {
      _isLoading = true;
    });

    _myCancelableFuture = CancelableOperation.fromFuture(
      _myFuture(),
      onCancel: () => 'Future has been canceld',
    );
    final value = await _myCancelableFuture?.value;

    // update the UI
    setState(() {
      _text = value;
      _isLoading = false;
    });
  }

  // this function is called when the "cancel" button is tapped
  void _cancelFuture() async {
    final result = await _myCancelableFuture?.cancel();
    setState(() {
      _text = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KindaCode.com')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                _text ?? 'Press Start Button',
                style: const TextStyle(fontSize: 28),
              ),
      ),
      // This button is used to trigger _getDate() and _cancelFuture() functions
      // the function is called depends on the _isLoading variable
      floatingActionButton: ElevatedButton(
        onPressed: () => _isLoading ? _cancelFuture() : _getData(),
        child: Text(_isLoading ? 'Cancel' : 'Start'),
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            primary: _isLoading ? Colors.red : Colors.indigo),
      ),
    );
  }
}
