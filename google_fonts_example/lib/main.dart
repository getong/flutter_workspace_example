import 'package:flutter/material.dart';
import 'example_font_selection.dart';
import 'example_simple.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Font Demo',
      theme: ThemeData.light(useMaterial3: true),
      home: DefaultTabController(
        animationDuration: Duration.zero,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Offline Font Demo'),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: 'Simple'),
                Tab(text: 'Select a font'),
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[
              ExampleSimple(),
              ExampleFontSelection(),
            ],
          ),
        ),
      ),
    );
  }
}
