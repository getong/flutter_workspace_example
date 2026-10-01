import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.toggleSwitch)
class ToggleSwitchPage extends StatelessWidget {
  const ToggleSwitchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('toggle_switch · Deprecated')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'This module has been retired',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'Use one of the existing examples below for segmented selection '
            'and animated switches.',
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.animation),
              title: const Text('animated_toggle_switch'),
              subtitle: const Text(
                'Animated choices, vertical layouts, optional selection, '
                'and asynchronous changes.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  context.router.pushPath(AppRoute.animatedToggleSwitch.path),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.view_week_outlined),
              title: const Text('SegmentedButton'),
              subtitle: const Text(
                'Flutter Material controls for single and multiple selection.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  context.router.pushPath(AppRoute.segmentedButton.path),
            ),
          ),
        ],
      ),
    );
  }
}
