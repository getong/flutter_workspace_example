import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button Examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Button Examples'),
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
  String _buttonPressed = 'No button pressed yet';

  void _onButtonPressed(String buttonType) {
    setState(() {
      _buttonPressed = '$buttonType pressed!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _buttonPressed,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // ElevatedButton Examples
            const Text('ElevatedButton:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _onButtonPressed('ElevatedButton'),
              child: const Text('Elevated Button'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _onButtonPressed('ElevatedButton with Icon'),
              icon: const Icon(Icons.star),
              label: const Text('With Icon'),
            ),
            const SizedBox(height: 20),

            // FilledButton Examples
            const Text('FilledButton:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Material 3 filled button with medium emphasis', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () => _onButtonPressed('FilledButton'),
              child: const Text('Filled Button'),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => _onButtonPressed('FilledButton with Icon'),
              icon: const Icon(Icons.check),
              label: const Text('Confirm'),
            ),
            const SizedBox(height: 20),

            // OutlinedButton Examples
            const Text('OutlinedButton:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => _onButtonPressed('OutlinedButton'),
              child: const Text('Outlined Button'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => _onButtonPressed('OutlinedButton with Icon'),
              icon: const Icon(Icons.send),
              label: const Text('Send Message'),
            ),
            const SizedBox(height: 20),

            // TextButton Examples
            const Text('TextButton:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => _onButtonPressed('TextButton'),
              child: const Text('Text Button'),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => _onButtonPressed('TextButton with Icon'),
              icon: const Icon(Icons.info),
              label: const Text('Learn More'),
            ),
            const SizedBox(height: 20),

            // IconButton Examples
            const Text('IconButton:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => _onButtonPressed('Heart IconButton'),
                  icon: const Icon(Icons.favorite),
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () => _onButtonPressed('Share IconButton'),
                  icon: const Icon(Icons.share),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () => _onButtonPressed('Delete IconButton'),
                  icon: const Icon(Icons.delete),
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Disabled Button Examples
            const Text('Disabled Buttons:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const ElevatedButton(
              onPressed: null,
              child: Text('Disabled Elevated'),
            ),
            const SizedBox(height: 10),
            const OutlinedButton(
              onPressed: null,
              child: Text('Disabled Outlined'),
            ),
            const SizedBox(height: 10),
            const TextButton(
              onPressed: null,
              child: Text('Disabled Text'),
            ),
            const SizedBox(height: 10),
            const FilledButton(
              onPressed: null,
              child: Text('Disabled Filled'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onButtonPressed('FloatingActionButton'),
        tooltip: 'FloatingActionButton',
        child: const Icon(Icons.add),
      ),
    );
  }
}
