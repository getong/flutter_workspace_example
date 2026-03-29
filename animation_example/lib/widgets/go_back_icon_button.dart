import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoBackIconButton extends StatelessWidget {
  const GoBackIconButton({super.key, this.fallbackPath = '/'});

  final String fallbackPath;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      tooltip: 'Go Back',
      onPressed: () {
        if (context.canPop()) {
          context.pop();
          return;
        }
        context.go(fallbackPath);
      },
    );
  }
}
