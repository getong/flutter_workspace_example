import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.column)
class ColumnPage extends StatefulWidget {
  const ColumnPage({super.key});

  @override
  State<ColumnPage> createState() => _ColumnPageState();
}

class _ColumnPageState extends State<ColumnPage> {
  static bool _savedIsEnabled = true;
  late bool isEnabled;

  @override
  void initState() {
    super.initState();
    isEnabled = _savedIsEnabled;
  }

  void doTheThing() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('The thing was done.')));

    setEnabled(false);
  }

  void setEnabled(bool value) {
    setState(() {
      isEnabled = value;
      _savedIsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column')),
      body: SelectionArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Let's go!"),
              const SizedBox(height: 16),
              TextButton(
                onPressed: isEnabled ? doTheThing : null,
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
                onPressed: () => setEnabled(!isEnabled),
                child: Text(
                  isEnabled ? 'Disable isEnabled' : 'Enable isEnabled',
                ),
              ),
            ],
          ),
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
