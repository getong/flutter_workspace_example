import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: Text('Tab Example'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Tab 1', icon: Icon(Icons.directions_car)),
                Tab(text: 'Tab 2',icon: Icon(Icons.directions_transit)),
                Tab(text: 'Tab 3',icon: Icon(Icons.directions_bike)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text('Content of Tab 1')),
              Center(child: Text('Content of Tab 2')),
              Center(child: Text('Content of Tab 3')),
            ],
          ),
        ),
      ),
    );
  }
}
