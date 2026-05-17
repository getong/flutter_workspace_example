import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.flutterAdvancedSwitch)
class FlutterAdvancedSwitchPage extends StatefulWidget {
  const FlutterAdvancedSwitchPage({super.key});

  @override
  State<FlutterAdvancedSwitchPage> createState() =>
      _FlutterAdvancedSwitchPageState();
}

class _FlutterAdvancedSwitchPageState extends State<FlutterAdvancedSwitchPage> {
  final ValueNotifier<bool> _powerController = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _themeController = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _deployController = ValueNotifier<bool>(true);

  bool _callbackValue = false;
  bool _switchEnabled = true;
  final List<String> _events = <String>[
    'Toggle a switch to inspect controller updates and callbacks.',
  ];

  @override
  void initState() {
    super.initState();
    _powerController.addListener(() {
      _log('Power controller changed to ${_powerController.value}');
      if (mounted) {
        setState(() {});
      }
    });
    _themeController.addListener(() {
      _log('Theme controller changed to ${_themeController.value}');
      if (mounted) {
        setState(() {});
      }
    });
    _deployController.addListener(() {
      _log('Deploy controller changed to ${_deployController.value}');
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _powerController.dispose();
    _themeController.dispose();
    _deployController.dispose();
    super.dispose();
  }

  void _log(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';

    setState(() {
      _events.insert(0, '$stamp  $message');
      if (_events.length > 10) {
        _events.removeRange(10, _events.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_advanced_switch Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'flutter_advanced_switch is a highly customizable boolean switch for branded settings, status toggles, and feature controls where the stock Material `Switch` is too limited visually.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates controller-based state, callback-based state, custom active/inactive content, custom thumb widgets, background images, and disabled behavior.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _InfoCard(
              title: 'What it is useful for',
              description:
                  'Use `flutter_advanced_switch` when a plain on/off switch needs richer branding or clearer state communication, such as dark mode, live/offline mode, publishing, deployment, or dashboard controls.',
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Controller-based switch',
              description:
                  'A `ValueNotifier<bool>` lets Flutter UI react instantly to external or programmatic state changes.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Expanded(child: Text('Workspace power')),
                      AdvancedSwitch(
                        controller: _powerController,
                        width: 84,
                        height: 40,
                        activeColor: const Color(0xFF16A34A),
                        inactiveColor: const Color(0xFF475569),
                        activeChild: const Text('ON'),
                        inactiveChild: const Text('OFF'),
                        onChanged: (dynamic value) {
                          final bool nextValue = value as bool;
                          _log('Power onChanged fired with $nextValue');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton(
                        onPressed: () => _powerController.value = true,
                        child: const Text('Force ON'),
                      ),
                      OutlinedButton(
                        onPressed: () => _powerController.value = false,
                        child: const Text('Force OFF'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Current value: ${_powerController.value}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Callback-only switch',
              description:
                  'You can also use `initialValue` + `onChanged` without a controller for simpler local UI state.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Expanded(child: Text('Beta access')),
                      AdvancedSwitch(
                        initialValue: _callbackValue,
                        width: 72,
                        height: 36,
                        activeColor: const Color(0xFF2563EB),
                        inactiveColor: const Color(0xFFCBD5E1),
                        activeChild: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        inactiveChild: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        onChanged: (dynamic value) {
                          final bool nextValue = value as bool;
                          setState(() {
                            _callbackValue = nextValue;
                          });
                          _log('Callback-only switch changed to $nextValue');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Current value: $_callbackValue'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Custom thumb + content',
              description:
                  'This package supports richer thumb UI and inline labels/icons, making boolean state more expressive than a stock switch.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AdvancedSwitch(
                    controller: _themeController,
                    width: 104,
                    height: 48,
                    thumbPadding: 3,
                    activeColor: const Color(0xFFF59E0B),
                    inactiveColor: const Color(0xFF1E293B),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    activeChild: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 14),
                        child: Icon(
                          Icons.wb_sunny_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    inactiveChild: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 14),
                        child: Icon(
                          Icons.nightlight_round,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    thumb: ValueListenableBuilder<bool>(
                      valueListenable: _themeController,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                value
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                                size: 18,
                                color: value
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFF334155),
                              ),
                            );
                          },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _themeController.value
                        ? 'Theme mode is set to daylight UI.'
                        : 'Theme mode is set to night UI.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Background images',
              description:
                  'Active and inactive backgrounds can use images, which is useful for playful or highly branded product controls.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AdvancedSwitch(
                    controller: _deployController,
                    width: 112,
                    height: 48,
                    activeColor: const Color(0xFF0F766E),
                    inactiveColor: const Color(0xFF7C2D12),
                    activeImage: const AssetImage(
                      'assets/images/analytics_badge.png',
                    ),
                    inactiveImage: const AssetImage(
                      'assets/images/image_module_demo.png',
                    ),
                    activeChild: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 14),
                        child: Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    inactiveChild: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Text(
                          'PAUSE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    onChanged: (dynamic value) {
                      final bool nextValue = value as bool;
                      _log('Deploy switch changed to $nextValue');
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _deployController.value
                        ? 'Traffic is live.'
                        : 'Traffic is paused.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Disabled state',
              description:
                  'Use `enabled: false` for read-only or unavailable settings while keeping the visual design consistent.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _switchEnabled
                              ? 'Advanced switch is interactive.'
                              : 'Advanced switch is disabled.',
                        ),
                      ),
                      AdvancedSwitch(
                        controller: _powerController,
                        width: 80,
                        height: 38,
                        enabled: _switchEnabled,
                        disabledOpacity: 0.35,
                        activeColor: const Color(0xFF16A34A),
                        inactiveColor: const Color(0xFF64748B),
                        activeChild: const Text('YES'),
                        inactiveChild: const Text('NO'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _switchEnabled = !_switchEnabled;
                      });
                      _log('Disabled state toggled to ${!_switchEnabled}');
                    },
                    icon: Icon(
                      _switchEnabled
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined,
                    ),
                    label: Text(
                      _switchEnabled ? 'Disable Switch' : 'Enable Switch',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Event log',
              description:
                  'The widget is especially useful when you want a boolean switch that also feels like a branded status chip or tiny control surface.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _events
                    .map(
                      (String event) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(event),
                      ),
                    )
                    .toList(),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.description});

  final String title;
  final String description;

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
          ],
        ),
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
