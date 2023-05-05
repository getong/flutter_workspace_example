import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyStackWidget(),
    );
  }
}

class MyStackWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text("Flutter Stack Widget Example"),
          ),
          body: Center(
            child: Stack(
              children: [
                Positioned(
                  top: 100,
                  child: Text("Stack#1",
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                Positioned(
                  top: 150.0,
                  child: Container(
                    height: 220,
                    width: 220,
                    color: Colors.green,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 160,
                          child: Text("Stack Inside Stack#1",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
