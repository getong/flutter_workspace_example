import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.checkbox)
class CheckboxExamplePage extends StatefulWidget {
  const CheckboxExamplePage({super.key});

  @override
  State<CheckboxExamplePage> createState() => _CheckboxExamplePageState();
}

class _CheckboxExamplePageState extends State<CheckboxExamplePage> {
  bool _emailUpdates = true;
  bool _pushUpdates = false;
  bool? _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkbox Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Checkbox is useful when users can independently select one or more options.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Basic Checkbox',
              description:
                  'A plain Checkbox is usually paired with nearby text in a custom row layout.',
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: _emailUpdates,
                    onChanged: (bool? value) {
                      setState(() {
                        _emailUpdates = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Receive email updates')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'CheckboxListTile',
              description:
                  'CheckboxListTile is the common pattern for settings screens with title and subtitle text.',
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable push notifications'),
                subtitle: const Text('Send reminders to this device.'),
                value: _pushUpdates,
                onChanged: (bool? value) {
                  setState(() {
                    _pushUpdates = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Tristate Checkbox',
              description:
                  'Set tristate to true when you need an indeterminate state such as partially selected content.',
              child: Row(
                children: <Widget>[
                  Checkbox(
                    tristate: true,
                    value: _termsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _termsAccepted = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Review terms status: ${_termsAccepted == null
                          ? 'Partially reviewed'
                          : _termsAccepted!
                          ? 'Accepted'
                          : 'Not accepted'}',
                    ),
                  ),
                ],
              ),
            ),
          ],
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

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
