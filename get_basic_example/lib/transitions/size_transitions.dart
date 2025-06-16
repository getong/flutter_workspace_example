import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizeTransitions extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      alignment: Alignment.center,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animation, curve: curve!),
        child: child,
      ),
    );
  }
}
