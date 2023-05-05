import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MaterialApp(
    home: MyRiveAnimation(),
  ));
}

class MyRiveAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        // child: RiveAnimation.network(
        //   'https://cdn.rive.app/animations/vehicles.riv',
        //   fit: BoxFit.cover,
        // ),
        child: RiveAnimation.asset(
          'assets/vehicles.riv',
        ),
      ),
    );
  }
}
