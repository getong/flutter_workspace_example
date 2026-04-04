import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'SwitchExampleRoute')
class SwitchExamplePage extends StatefulWidget {
  const SwitchExamplePage({super.key});

  @override
  State<SwitchExamplePage> createState() => _SwitchExamplePageState();
}

class _SwitchExamplePageState extends State<SwitchExamplePage> {
  bool _wifiEnabled = true;
  bool _airplaneMode = false;
  bool _syncOverMobileData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Switch Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Switch is a Material toggle for turning a single boolean setting on or off.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Basic Switch',
              description:
                  'Use a Switch when you want an immediate on/off control for one setting.',
              child: Row(
                children: <Widget>[
                  const Expanded(child: Text('Wi-Fi')),
                  Switch(
                    value: _wifiEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _wifiEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'SwitchListTile',
              description:
                  'SwitchListTile combines text, subtitle, and a switch into one common settings-row pattern.',
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Airplane mode'),
                subtitle: const Text(
                  'Disable radios and network services while traveling.',
                ),
                value: _airplaneMode,
                onChanged: (bool value) {
                  setState(() {
                    _airplaneMode = value;
                    if (value) {
                      _wifiEnabled = false;
                      _syncOverMobileData = false;
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Customized Switch',
              description:
                  'You can customize thumb and track colors while still using the same boolean state pattern.',
              child: Row(
                children: <Widget>[
                  const Expanded(child: Text('Sync over mobile data')),
                  Switch(
                    value: _syncOverMobileData,
                    activeThumbColor: Colors.white,
                    activeTrackColor: Colors.deepOrange,
                    inactiveThumbColor: Colors.grey.shade200,
                    inactiveTrackColor: Colors.grey.shade400,
                    onChanged: _airplaneMode
                        ? null
                        : (bool value) {
                            setState(() {
                              _syncOverMobileData = value;
                            });
                          },
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
