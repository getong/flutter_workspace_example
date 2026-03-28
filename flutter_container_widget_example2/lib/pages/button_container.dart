import 'package:flutter/material.dart';

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({required this.page, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter UI Container'),
        ),
        body: Container(color: Colors.lightBlue, child: ButtonBar()),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.ac_unit),
          onPressed: () {
            print('Oh,itiscoldoutside...');
          },
        ),
        theme: ThemeData(
          primaryColor: Colors.indigo,
          accentColor: Colors.amber,
          textTheme: TextTheme(
            bodyText2: TextStyle(fontSize: 26, fontStyle: FontStyle.italic),
          ),
          brightness: Brightness.dark,
        ));
  }
}
