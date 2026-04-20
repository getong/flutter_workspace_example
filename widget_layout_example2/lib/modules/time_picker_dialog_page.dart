import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TimePickerDialogPage extends StatefulWidget {
  const TimePickerDialogPage({super.key});

  @override
  State<TimePickerDialogPage> createState() => _TimePickerDialogPageState();
}

class _TimePickerDialogPageState extends State<TimePickerDialogPage> {
  TimeOfDay _dialTime = const TimeOfDay(hour: 9, minute: 30);
  TimeOfDay _inputTime = const TimeOfDay(hour: 18, minute: 5);
  bool _use24HourFormat = false;
  TimePickerEntryMode _lastEntryMode = TimePickerEntryMode.dial;
  String _latestResult = 'No TimePickerDialog result yet.';

  Future<void> _openDialDialog() async {
    final TimeOfDay? result = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext dialogContext) {
        return MediaQuery(
          data: MediaQuery.of(
            dialogContext,
          ).copyWith(alwaysUse24HourFormat: _use24HourFormat),
          child: TimePickerDialog(
            initialTime: _dialTime,
            helpText: 'Select standby time',
            confirmText: 'Apply',
            cancelText: 'Cancel',
            onEntryModeChanged: (TimePickerEntryMode mode) {
              setState(() {
                _lastEntryMode = mode;
              });
            },
          ),
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _dialTime = result;
      _latestResult = 'Dial dialog result: ${_formatTime(context, _dialTime)}';
    });
  }

  Future<void> _openInputDialog() async {
    final TimeOfDay? result = await showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return TimePickerDialog(
          initialTime: _inputTime,
          initialEntryMode: TimePickerEntryMode.input,
          helpText: 'Enter support handoff time',
          errorInvalidText: 'Use a valid time value',
          hourLabelText: 'Hour',
          minuteLabelText: 'Minute',
          onEntryModeChanged: (TimePickerEntryMode mode) {
            setState(() {
              _lastEntryMode = mode;
            });
          },
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _inputTime = result;
      _latestResult =
          'Input dialog result: ${_formatTime(context, _inputTime)}';
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
      appBar: AppBar(title: const Text('TimePickerDialog Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'TimePickerDialog is the dialog widget behind Material time picking flows when you want to present it directly with showDialog().',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Dial Entry Mode',
              description:
                  'The default TimePickerDialog experience uses the dial interface and can still be customized when shown directly.',
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
                    onPressed: _openDialDialog,
                    icon: const Icon(Icons.schedule),
                    label: const Text('Open dial dialog'),
                  ),
                  const SizedBox(height: 12),
                  Text('Selected time: ${_formatTime(context, _dialTime)}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Input Entry Mode',
              description:
                  'TimePickerDialog also supports explicit text entry, validation text, and custom field labels.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  OutlinedButton.icon(
                    onPressed: _openInputDialog,
                    icon: const Icon(Icons.keyboard_alt_outlined),
                    label: const Text('Open input dialog'),
                  ),
                  const SizedBox(height: 12),
                  Text('Input time: ${_formatTime(context, _inputTime)}'),
                  const SizedBox(height: 8),
                  Text('Last entry mode: $_lastEntryMode'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Latest Result',
              description:
                  'TimePickerDialog returns a TimeOfDay from Navigator.pop, which can be stored directly in page state.',
              child: Text(_latestResult),
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
