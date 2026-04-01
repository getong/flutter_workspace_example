import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RowExpandedPage extends StatelessWidget {
  const RowExpandedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: Row(
          children: <Widget>[
            Expanded(flex: 2, child: Container(color: Colors.amber)),
            Expanded(flex: 1, child: Container(color: Colors.blue)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}
