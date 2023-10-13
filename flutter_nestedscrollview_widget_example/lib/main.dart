import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        // onPressed: () {
        //   _controller.animateTo(_selectedIndex += 1);
        // },
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              // controller: _controller,
              indicatorColor: Colors.amberAccent,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 10,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), // Creates border
                color:
                Colors.greenAccent), //Change background color from here
              isScrollable: true,
              tabs: [
                Tab(icon: Icon(Icons.flight)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_car)),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: NestedScrollView(
            headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  title: Text('Tabs Demo'),
                  pinned: true,
                  floating: true,
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(child: Text('Flight')),
                      Tab(child: Text('Train')),
                      Tab(child: Text('Car')),
                      Tab(child: Text('Cycle')),
                      Tab(child: Text('Boat')),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              // controller: _controller,
              children: <Widget>[
                Icon(Icons.flight, size: 350),
                Icon(Icons.directions_transit, size: 350),
                Icon(Icons.directions_car, size: 350),
                Icon(Icons.directions_bike, size: 350),
                Icon(Icons.directions_boat, size: 350),
              ],
            ),
        )),
      ),
    );
  }
}
