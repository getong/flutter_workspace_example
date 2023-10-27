import 'package:flutter/material.dart';

class MyGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GridView Example'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
        ),
        itemCount: 10, // Number of items in the grid
        itemBuilder: (BuildContext context, int index) {
          // This function builds each grid item
          return GridTile(
            child: Container(
              color: Colors.blueAccent,
              child: Center(
                child: Text(
                  'Item $index',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: MyGridView()));
