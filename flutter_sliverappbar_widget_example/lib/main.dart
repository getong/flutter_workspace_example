import 'package:flutter/material.dart';

class SliverAppBarExample extends StatelessWidget {
  const SliverAppBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sliver AppBar example',
      home: SliverAppBarHome(),
    );
  }
}

void main() {
  runApp(const SliverAppBarExample());
}

class SliverAppBarHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('SliverAppBar example'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'It will collapse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              background: Image.network(
                'https://cdn.pixabay.com/photo/2016/09/10/17/18/book-1659717_960_720.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 50,
            delegate: SliverChildListDelegate([
              Container(color: Colors.red),
              Container(color: Colors.green),
              Container(color: Colors.blue),
              Container(color: Colors.red),
              Container(color: Colors.green),
              Container(color: Colors.blue),
              Container(color: Colors.red),
              Container(color: Colors.green),
              Container(color: Colors.blue),
              Container(color: Colors.red),
              Container(color: Colors.green),
              Container(color: Colors.blue),
            ]),
          ),
        ],
      ),
    );
  }
}
