import 'package:flutter/material.dart';

import '../back_home_button.dart';

class KeyDemoShell extends StatelessWidget {
  const KeyDemoShell({
    required this.title,
    required this.description,
    required this.child,
    super.key,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Expanded(child: child),
          ],
        ),
      ),
      persistentFooterButtons: const <Widget>[BackHomeButton()],
    );
  }
}
