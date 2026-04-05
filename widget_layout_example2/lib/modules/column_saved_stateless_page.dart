import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'ColumnSavedStatelessRoute')
class ColumnSavedStatelessPage extends StatelessWidget {
  const ColumnSavedStatelessPage({super.key});

  static final ValueNotifier<bool> _savedIsEnabled = ValueNotifier<bool>(true);

  void _doTheThing(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('The thing was done.')));
    _setEnabled(false);
  }

  void _setEnabled(bool value) {
    if (_savedIsEnabled.value == value) {
      return;
    }

    _savedIsEnabled.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column Saved Stateless')),
      body: SelectionArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ValueListenableBuilder<bool>(
            valueListenable: _savedIsEnabled,
            builder: (BuildContext context, bool isEnabled, Widget? child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Let's go!"),
                  const SizedBox(height: 16),
                  const Text(
                    'This copy keeps the widget stateless by storing the saved flag in a ValueNotifier.',
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: isEnabled ? () => _doTheThing(context) : null,
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
                    onPressed: () => _setEnabled(!isEnabled),
                    child: Text(
                      isEnabled
                          ? 'Disable _savedIsEnabled'
                          : 'Enable _savedIsEnabled',
                    ),
                  ),
                ],
              );
            },
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
