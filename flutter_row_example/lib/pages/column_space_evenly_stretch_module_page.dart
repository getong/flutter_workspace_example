import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ColumnSpaceEvenlyStretchModulePage extends StatelessWidget {
  const ColumnSpaceEvenlyStretchModulePage({super.key});

  List<Widget> boxes(int n, double w, double h) {
    final List<Widget> bxs = <Widget>[];
    const List<Color> fill = <Color>[
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.pink,
    ];

    for (int i = 0; i <= n - 1; i++) {
      final Container bx = Container(
        color: fill[i % fill.length],
        width: w,
        height: h,
      );
      bxs.add(bx);
    }

    return bxs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column SpaceEvenly Stretch Module')),
      body: Center(
        child: Container(
          width: 220,
          height: 280,
          decoration: const BoxDecoration(
            color: Colors.lightBlue,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[Colors.blue, Colors.orange],
            ),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: boxes(4, 40, 40),
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[
        TextButton.icon(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.home),
          label: const Text('Back Home'),
        ),
      ],
    );
  }
}
