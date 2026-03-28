import 'package:flutter/material.dart';

import '../app_router.dart';

class BackHomeButton extends StatelessWidget {
  const BackHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.home, (Route<dynamic> _) => false);
      },
      icon: const Icon(Icons.home),
      label: const Text('Back Home'),
    );
  }
}
