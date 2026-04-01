import 'package:flutter/material.dart';

import 'offline_fonts.dart';

class ExampleSimple extends StatefulWidget {
  const ExampleSimple({Key? key}) : super(key: key);

  @override
  ExampleSimpleState createState() => ExampleSimpleState();
}

class ExampleSimpleState extends State<ExampleSimple> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    const DemoFontOption headlineFont = DemoFontOption(
      'Lato',
      fontFamily: 'Lato',
    );
    final TextStyle pushButtonTextStyle = demoFontStyle(
      headlineFont,
      textStyle: Theme.of(context).textTheme.headlineMedium,
    );
    final TextStyle counterTextStyle = demoFontStyle(
      headlineFont,
      fontStyle: FontStyle.italic,
      textStyle: Theme.of(context).textTheme.displayLarge,
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              style: pushButtonTextStyle,
            ),
            const SizedBox(height: 12),
            Text('$_counter', style: counterTextStyle),
            const SizedBox(height: 24),
            Text(
              'This screen now uses bundled and system fonts only.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
