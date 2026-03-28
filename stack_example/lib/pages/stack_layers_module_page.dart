import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StackLayersModulePage extends StatelessWidget {
  const StackLayersModulePage({super.key});

  List<Widget> layeredCards(int n, double width, double height) {
    final List<Widget> cards = <Widget>[];
    const List<Color> fill = <Color>[
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.pink,
    ];

    for (int i = 0; i <= n - 1; i++) {
      cards.add(
        Positioned(
          top: i * 12,
          left: i * 12,
          child: Container(
            alignment: Alignment.center,
            color: fill[i % fill.length],
            width: width,
            height: height,
            child: Text(
              'Layer $i',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack Layers Module')),
      body: Center(
        child: Container(
          width: 300,
          height: 250,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[Colors.blue, Colors.orange],
            ),
          ),
          child: Stack(children: layeredCards(4, 220, 120)),
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
