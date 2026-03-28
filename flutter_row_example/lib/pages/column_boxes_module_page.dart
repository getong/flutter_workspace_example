import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ColumnBoxesModulePage extends StatelessWidget {
  const ColumnBoxesModulePage({super.key});

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
        alignment: Alignment.center,
        color: fill[i % fill.length],
        width: w,
        height: h,
        child: Text(i.toString()),
      );
      bxs.add(bx);
    }

    return bxs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column Boxes Module')),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.lightBlue,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[Colors.blue, Colors.orange],
            ),
            shape: BoxShape.rectangle,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
