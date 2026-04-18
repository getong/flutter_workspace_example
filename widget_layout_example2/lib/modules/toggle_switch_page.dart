import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

@RoutePage(name: 'ToggleSwitchRoute')
class ToggleSwitchPage extends StatefulWidget {
  const ToggleSwitchPage({super.key});

  @override
  State<ToggleSwitchPage> createState() => _ToggleSwitchPageState();
}

class _ToggleSwitchPageState extends State<ToggleSwitchPage> {
  int? _regionIndex = 0;
  int? _statusIndex = 1;
  int? _densityIndex;
  int? _orientationIndex = 0;
  List<String> _events = <String>[
    'Toggle an option to inspect `onToggle` and state changes.',
  ];

  void _log(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';

    setState(() {
      _events = <String>['$stamp  $message', ..._events].take(10).toList();
    });
  }

  Future<bool> _confirmStatusChange(int? nextIndex) async {
    if (nextIndex == 2) {
      final bool? allowed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Escalate deployment?'),
            content: const Text(
              'This demo uses `cancelToggle` to optionally block a switch change '
              'before the internal selection updates.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Allow'),
              ),
            ],
          );
        },
      );
      return allowed ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('toggle_switch Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'toggle_switch is a compact segmented control with gradients, '
            'custom widths, nullable selection, vertical layouts, and '
            'confirmation hooks.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This page demonstrates `labels`, `icons`, `activeBgColors`, '
            '`customWidths`, `doubleTapDisable`, `cancelToggle`, '
            '`radiusStyle`, and `isVertical`.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          _ToggleCard(
            title: 'Basic labels',
            description:
                'A simple segmented switch for environment or region selection.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ToggleSwitch(
                  initialLabelIndex: _regionIndex,
                  totalSwitches: 3,
                  minWidth: 90,
                  cornerRadius: 18,
                  activeBgColors: const <List<Color>>[
                    <Color>[Color(0xFF2563EB)],
                    <Color>[Color(0xFF0F766E)],
                    <Color>[Color(0xFFEA580C)],
                  ],
                  labels: const <String>['US', 'EU', 'APAC'],
                  onToggle: (int? index) {
                    setState(() => _regionIndex = index);
                    _log('Region switch changed to $index');
                  },
                ),
                const SizedBox(height: 12),
                Text('Selected index: ${_regionIndex ?? 'none'}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ToggleCard(
            title: 'Icons, gradients, and confirmation',
            description:
                'Use `cancelToggle` when a switch change needs extra validation or confirmation before applying.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ToggleSwitch(
                  initialLabelIndex: _statusIndex,
                  totalSwitches: 3,
                  minWidth: 104,
                  minHeight: 54,
                  cornerRadius: 16,
                  activeFgColor: Colors.white,
                  inactiveBgColor: const Color(0xFFE2E8F0),
                  inactiveFgColor: const Color(0xFF0F172A),
                  labels: const <String>['Queued', 'Review', 'Deploy'],
                  icons: const <IconData>[
                    Icons.schedule_outlined,
                    Icons.rate_review_outlined,
                    Icons.rocket_launch_outlined,
                  ],
                  activeBgColors: const <List<Color>>[
                    <Color>[Color(0xFF334155), Color(0xFF475569)],
                    <Color>[Color(0xFF7C3AED), Color(0xFFA855F7)],
                    <Color>[Color(0xFFEA580C), Color(0xFFF97316)],
                  ],
                  cancelToggle: _confirmStatusChange,
                  onToggle: (int? index) {
                    setState(() => _statusIndex = index);
                    _log('Status switch changed to $index');
                  },
                ),
                const SizedBox(height: 12),
                Text('Selected index: ${_statusIndex ?? 'none'}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ToggleCard(
            title: 'Nullable selection and double tap disable',
            description:
                'Set `initialLabelIndex: null` and `doubleTapDisable: true` when deselecting should be allowed.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ToggleSwitch(
                  initialLabelIndex: _densityIndex,
                  totalSwitches: 3,
                  minWidth: 100,
                  cornerRadius: 22,
                  radiusStyle: true,
                  doubleTapDisable: true,
                  inactiveBgColor: const Color(0xFFCBD5E1),
                  labels: const <String>['Compact', 'Comfy', 'Roomy'],
                  customTextStyles: const <TextStyle?>[
                    TextStyle(fontWeight: FontWeight.w700),
                    TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F766E),
                    ),
                    TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                  activeBgColors: const <List<Color>>[
                    <Color>[Color(0xFF1D4ED8)],
                    <Color>[Color(0xFF0F766E)],
                    <Color>[Color(0xFFB45309)],
                  ],
                  onToggle: (int? index) {
                    setState(() => _densityIndex = index);
                    _log('Density switch changed to $index');
                  },
                ),
                const SizedBox(height: 12),
                Text('Selected index: ${_densityIndex ?? 'none'}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ToggleCard(
            title: 'Custom widths and vertical layout',
            description:
                'The package also supports narrow icon segments, multi-line text, and vertical toggle arrangements.',
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              children: <Widget>[
                ToggleSwitch(
                  initialLabelIndex: 0,
                  totalSwitches: 2,
                  customWidths: const <double>[120, 72],
                  cornerRadius: 20,
                  activeFgColor: Colors.white,
                  labels: const <String>['Enabled', ''],
                  icons: const <IconData?>[null, Icons.close],
                  activeBgColors: const <List<Color>>[
                    <Color>[Color(0xFF0F766E)],
                    <Color>[Color(0xFFDC2626)],
                  ],
                  onToggle: (int? index) {
                    _log('Custom width switch changed to $index');
                  },
                ),
                ToggleSwitch(
                  initialLabelIndex: _orientationIndex,
                  totalSwitches: 3,
                  isVertical: true,
                  minWidth: 120,
                  minHeight: 56,
                  cornerRadius: 18,
                  centerText: true,
                  multiLineText: true,
                  labels: const <String>[
                    'Left\nRail',
                    'Split\nView',
                    'Right\nRail',
                  ],
                  activeBgColors: const <List<Color>>[
                    <Color>[Color(0xFF2563EB)],
                    <Color>[Color(0xFF7C3AED)],
                    <Color>[Color(0xFFEA580C)],
                  ],
                  onToggle: (int? index) {
                    setState(() => _orientationIndex = index);
                    _log('Vertical switch changed to $index');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ToggleCard(
            title: 'Event log',
            description:
                'Switch callbacks are often enough for filters, compact segmented navigation, and inline settings panels.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _events
                  .map(
                    (String event) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(event),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}
