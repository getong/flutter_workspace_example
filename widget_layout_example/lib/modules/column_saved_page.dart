import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ColumnSavedPage extends StatefulWidget {
  const ColumnSavedPage({super.key});

  @override
  State<ColumnSavedPage> createState() => _ColumnSavedPageState();
}

class _ColumnSavedPageState extends State<ColumnSavedPage> {
  static bool _savedIsEnabled = true;

  void doTheThing() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('The thing was done.')));

    setEnabled(false);
  }

  void setEnabled(bool value) {
    setState(() {
      _savedIsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column Saved')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Let's go!"),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _savedIsEnabled ? doTheThing : null,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.link),
                  ),
                  Text('Do the thing'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setEnabled(!_savedIsEnabled),
              child: Text(
                _savedIsEnabled
                    ? 'Disable _savedIsEnabled'
                    : 'Enable _savedIsEnabled',
              ),
            ),
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
