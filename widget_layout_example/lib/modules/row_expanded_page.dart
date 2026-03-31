import 'package:flutter/material.dart';

class RowExpandedPage extends StatelessWidget {
  const RowExpandedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(flex: 2, child: Container(color: Colors.amber)),
          Expanded(flex: 1, child: Container(color: Colors.blue)),
        ],
      ),
    );
  }
}
