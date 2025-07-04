import 'package:flutter/material.dart';
import 'isolate_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Isolate Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Isolate Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _result = 0;
  bool _isCalculating = false;
  late IsolateManager _isolateManager;

  @override
  void initState() {
    super.initState();
    _isolateManager = IsolateManager();
    _initializeIsolate();
  }

  Future<void> _initializeIsolate() async {
    await _isolateManager.initialize((result) {
      setState(() {
        _result = result;
        _isCalculating = false;
      });
    });
  }

  void _calculateFibonacci() {
    if (!_isCalculating) {
      setState(() {
        _isCalculating = true;
      });
      _isolateManager.calculateFibonacci(35);
    }
  }

  @override
  void dispose() {
    _isolateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Fibonacci calculation in isolate:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            if (_isCalculating)
              const CircularProgressIndicator()
            else
              Text(
                'Result: $_result',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isCalculating ? null : _calculateFibonacci,
              child: Text(
                _isCalculating ? 'Calculating...' : 'Calculate Fibonacci(35)',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'UI remains responsive during calculation!',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('UI is still responsive!')),
          );
        },
        tooltip: 'Test UI Responsiveness',
        child: const Icon(Icons.touch_app),
      ),
    );
  }
}
