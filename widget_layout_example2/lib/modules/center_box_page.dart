import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage(name: 'CenterBoxRoute')
class CenterBoxPage extends StatelessWidget {
  const CenterBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Center Box Module')),
      body: SelectionArea(
        child: Center(
          child: Container(width: 100.0, height: 100.0, color: Colors.blue),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}
