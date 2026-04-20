import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.timePicker)
class TimePickerPage extends StatefulWidget {
  const TimePickerPage({super.key});

  @override
  State<TimePickerPage> createState() => _TimePickerPageState();
}

class _TimePickerPageState extends State<TimePickerPage> {
  TimeOfDay _meetingTime = const TimeOfDay(hour: 9, minute: 30);
  TimeOfDay _breakTime = const TimeOfDay(hour: 15, minute: 0);
  TimeOfDay _manualDialogTime = const TimeOfDay(hour: 18, minute: 15);
  bool _use24HourFormat = false;
  TimePickerEntryMode _lastEntryMode = TimePickerEntryMode.dial;

  Future<void> _openMeetingPicker() async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: _meetingTime,
      helpText: 'Select meeting time',
      onEntryModeChanged: (TimePickerEntryMode mode) {
        setState(() {
          _lastEntryMode = mode;
        });
      },
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(alwaysUse24HourFormat: _use24HourFormat),
          child: child!,
        );
      },
    );

    if (!mounted || selected == null) {
      return;
    }

    setState(() {
      _meetingTime = selected;
    });
  }

  Future<void> _openInputPicker() async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: _breakTime,
      initialEntryMode: TimePickerEntryMode.input,
      helpText: 'Enter break time',
      onEntryModeChanged: (TimePickerEntryMode mode) {
        setState(() {
          _lastEntryMode = mode;
        });
      },
    );

    if (!mounted || selected == null) {
      return;
    }

    setState(() {
      _breakTime = selected;
    });
  }

  Future<void> _openDialogDirectly() async {
    final TimeOfDay? selected = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext dialogContext) {
        return TimePickerDialog(
          initialTime: _manualDialogTime,
          initialEntryMode: TimePickerEntryMode.dial,
          helpText: 'Manual dialog usage',
          onEntryModeChanged: (TimePickerEntryMode mode) {
            setState(() {
              _lastEntryMode = mode;
            });
          },
        );
      },
    );

    if (!mounted || selected == null) {
      return;
    }

    setState(() {
      _manualDialogTime = selected;
    });
  }

  String _formatTime(BuildContext context, TimeOfDay time) {
    return MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(time, alwaysUse24HourFormat: _use24HourFormat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TimePicker Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Time pickers can be shown as a dial, a text-input form, or a manually constructed dialog depending on the experience you need.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'showTimePicker Dial',
              description:
                  'This is the most common entry point for picking a time in a focused modal interaction.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Use 24-hour format'),
                    value: _use24HourFormat,
                    onChanged: (bool value) {
                      setState(() {
                        _use24HourFormat = value;
                      });
                    },
                  ),
                  FilledButton.icon(
                    onPressed: _openMeetingPicker,
                    icon: const Icon(Icons.schedule),
                    label: const Text('Pick Meeting Time'),
                  ),
                  const SizedBox(height: 12),
                  Text('Meeting time: ${_formatTime(context, _meetingTime)}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Input Entry Mode',
              description:
                  'Start directly in text-input mode when users need precision or keyboard-driven entry.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  OutlinedButton.icon(
                    onPressed: _openInputPicker,
                    icon: const Icon(Icons.keyboard),
                    label: const Text('Enter Break Time'),
                  ),
                  const SizedBox(height: 12),
                  Text('Break time: ${_formatTime(context, _breakTime)}'),
                  const SizedBox(height: 8),
                  Text('Last picker entry mode: $_lastEntryMode'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Direct TimePickerDialog',
              description:
                  'You can also construct TimePickerDialog manually when you want to embed it in custom dialog flows.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ActionChip(
                    avatar: const Icon(Icons.alarm, size: 18),
                    label: const Text('Open Custom Time Dialog'),
                    onPressed: _openDialogDirectly,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Manual dialog time: ${_formatTime(context, _manualDialogTime)}',
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
