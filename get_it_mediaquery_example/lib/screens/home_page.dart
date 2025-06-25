import 'package:flutter/material.dart';
import '../service_locator.dart';
import '../widgets/info_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _showInfoDialog() {
    final contextService = getIt<ContextService>();
    if (!contextService.hasData) return;

    showDialog(context: context, builder: (context) => const InfoDialog());
  }

  @override
  Widget build(BuildContext context) {
    final contextService = getIt<ContextService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: contextService.hasData
            ? contextService.themeData.colorScheme.inversePrimary
            : Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Counter from regular state:'),
            Text(
              '$_counter',
              style: contextService.hasData
                  ? contextService.themeData.textTheme.headlineMedium
                  : Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            if (contextService.hasData) ...[
              const Text('Screen info from GetIt:'),
              Text(
                'Width: ${contextService.mediaQueryData.size.width.toStringAsFixed(1)}',
              ),
              Text(
                'Height: ${contextService.mediaQueryData.size.height.toStringAsFixed(1)}',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showInfoDialog,
                child: const Text('Show More Info'),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
